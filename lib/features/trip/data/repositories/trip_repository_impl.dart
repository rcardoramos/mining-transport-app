import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'package:mining_transport_app/features/trip/data/models/create_trip_dto.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';

/// Implementación del [TripRepository] con estrategia Offline-First.
class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource _remoteDataSource;
  final Ref _ref;

  TripRepositoryImpl(this._remoteDataSource, this._ref);

  @override
  Future<Result<List<TripEntity>, Failure>> getTodayTrips() async {
    try {
      final models = await _remoteDataSource.getTodayTrips();
      final entities = <TripEntity>[];
      final secureStorage = GetIt.I<SecureStorage>();
      for (final m in models) {
        var entity = m.toEntity();
        if (entity.status != TripStatus.completed &&
            entity.status != TripStatus.cancelled) {
          final isTravelling = await secureStorage.isTripTravelling(entity.id);
          if (isTravelling) {
            entity = entity.copyWith(status: TripStatus.travelling);
          }
        }
        entities.add(entity);
      }
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getPendingTrips() async {
    try {
      final models = await _remoteDataSource.getPendingTrips();
      final entities = <TripEntity>[];
      final secureStorage = GetIt.I<SecureStorage>();
      for (final m in models) {
        var entity = m.toEntity();
        if (entity.status != TripStatus.completed &&
            entity.status != TripStatus.cancelled) {
          final isTravelling = await secureStorage.isTripTravelling(entity.id);
          if (isTravelling) {
            entity = entity.copyWith(status: TripStatus.travelling);
          }
        }
        entities.add(entity);
      }
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> openTrip({
    required String tripId,
    required int startKm,
  }) async {
    final isOnline = _ref.read(syncProvider).isOnline;

    if (!isOnline) {
      await _ref.read(syncProvider.notifier).queueAction(
            actionType: 'OPEN_TRIP',
            payloadJson: jsonEncode({'tripId': tripId, 'startKm': startKm}),
          );
      try {
        final model =
            await _remoteDataSource.openTrip(tripId: tripId, startKm: startKm);
        return Success(model.toEntity());
      } catch (e) {
        return FailureResult(UnknownFailure(e.toString()));
      }
    }

    try {
      final model =
          await _remoteDataSource.openTrip(tripId: tripId, startKm: startKm);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> closeTrip({
    required String tripId,
    required int endKm,
  }) async {
    final isOnline = _ref.read(syncProvider).isOnline;

    if (!isOnline) {
      await _ref.read(syncProvider.notifier).queueAction(
            actionType: 'CLOSE_TRIP',
            payloadJson: jsonEncode({'tripId': tripId, 'endKm': endKm}),
          );
      await GetIt.I<SecureStorage>().deleteTripTravelling(tripId);
      try {
        final model =
            await _remoteDataSource.closeTrip(tripId: tripId, endKm: endKm);
        var entity = model.toEntity();
        entity = entity.copyWith(status: TripStatus.completed);
        return Success(entity);
      } catch (e) {
        return FailureResult(UnknownFailure(e.toString()));
      }
    }

    try {
      await GetIt.I<SecureStorage>().deleteTripTravelling(tripId);
      final model =
          await _remoteDataSource.closeTrip(tripId: tripId, endKm: endKm);
      var entity = model.toEntity();
      entity = entity.copyWith(status: TripStatus.completed);
      return Success(entity);
    } catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> getTripDetail(String tripId) async {
    try {
      final model = await _remoteDataSource.getTripDetail(tripId);
      var entity = model.toEntity();
      if (entity.status != TripStatus.completed &&
          entity.status != TripStatus.cancelled) {
        final isTravelling =
            await GetIt.I<SecureStorage>().isTripTravelling(tripId);
        if (isTravelling) {
          entity = entity.copyWith(status: TripStatus.travelling);
        }
      }
      return Success(entity);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CreatedTripResult, Failure>> createTrip(
    CreateTripCommand command,
  ) async {
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      return const FailureResult(
        NetworkFailure('Necesitas conexión para crear un nuevo viaje.'),
      );
    }

    try {
      final storage = GetIt.I<SecureStorage>();
      final username = await storage.getUsername() ?? '';
      final token = await storage.getToken() ?? '';
      if (username.isEmpty || token.isEmpty) {
        return const FailureResult(
          UnauthorizedFailure('Sesión inválida. Inicie sesión nuevamente.'),
        );
      }

      final request = CreateTripRequestDto.fromCommand(
        usuario: username,
        token: token,
        command: command,
      );
      final dto = await _remoteDataSource.createTrip(request);
      return Success(dto.toDomain());
    } on DioException catch (e) {
      GetIt.I<AppLogger>().e('Viaje/Crear error', e);
      return FailureResult(_mapCreateError(e));
    } catch (e) {
      GetIt.I<AppLogger>().e('Viaje/Crear error inesperado', e);
      return FailureResult(
        UnknownFailure('No pudimos crear el viaje. Inténtelo nuevamente.', e),
      );
    }
  }

  Failure _mapCreateError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String? serverMessage;
    if (data is Map) {
      serverMessage = (data['Message'] ?? data['message'])?.toString();
    }
    serverMessage ??= e.message;

    if (status == 401) {
      return UnauthorizedFailure(
        serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Sesión expirada. Inicie sesión nuevamente.',
        e,
      );
    }
    if (status == 403) {
      return ServerFailure(
        serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'No tiene permiso para crear viajes.',
        status,
        e,
      );
    }
    if (status == 404) {
      return ServerFailure(
        serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Recurso de viaje no encontrado.',
        status,
        e,
      );
    }
    if (status == 409) {
      return ServerFailure(
        serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Ya existe un viaje registrado para este horario.',
        status,
        e,
      );
    }
    if (status == 400) {
      return ValidationFailure(
        serverMessage?.isNotEmpty == true
            ? serverMessage!
            : 'Datos inválidos para crear el viaje.',
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(
        'La solicitud tardó demasiado. Inténtelo nuevamente.',
        e,
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
        'Necesitas conexión para crear un nuevo viaje.',
      );
    }
    if (status != null && status >= 500) {
      return ServerFailure(
        'No pudimos crear el viaje. Inténtelo nuevamente.',
        status,
        e,
      );
    }
    return ServerFailure(
      serverMessage?.isNotEmpty == true
          ? serverMessage!
          : 'No pudimos crear el viaje. Inténtelo nuevamente.',
      status,
      e,
    );
  }
}
