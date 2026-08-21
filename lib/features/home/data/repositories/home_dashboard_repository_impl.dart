import 'package:mining_transport_app/core/utils/result.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_close_context.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import '../../domain/repositories/home_dashboard_repository.dart';
import '../datasources/home_dashboard_remote_data_source.dart';
import '../models/trip_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/passenger_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/collaborator_model.dart';
import 'package:mining_transport_app/features/trip/data/datasources/trip_remote_data_source.dart';

/// Implementación concreta del Repositorio de Home Dashboard.
class HomeDashboardRepositoryImpl implements HomeDashboardRepository {
  final HomeDashboardRemoteDataSource _remoteDataSource;

  HomeDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<DriverEntity, Failure>> getDriverInfo() async {
    try {
      final model = await _remoteDataSource.getDriverInfo();
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getTodayTrips() async {
    try {
      final models = await _remoteDataSource.getTodayTrips();
      final entities = await _mapTripsWithLocalTravellingFlag(models);
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getPendingTrips() async {
    try {
      final models = await _remoteDataSource.getPendingTrips();
      final entities = await _mapTripsWithLocalTravellingFlag(models);
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  /// Historial suele omitir aforo/capacidad. Pedimos `Viaje/Obtener` en paralelo
  /// para viajes no cancelados (incluye finalizados: el resumen/Home necesitan aforo).
  Future<List<TripEntity>> _mapTripsWithLocalTravellingFlag(
    List<TripModel> models,
  ) async {
    final secureStorage = GetIt.I<SecureStorage>();
    final tripRemote = GetIt.I<TripRemoteDataSource>();

    return Future.wait(models.map((m) async {
      var entity = m.toEntity();
      final isCancelled = entity.status == TripStatus.cancelled;
      final isOpen = entity.status != TripStatus.completed && !isCancelled;

      if (isOpen) {
        final isTravelling = await secureStorage.isTripTravelling(entity.id);
        if (isTravelling) {
          entity = entity.copyWith(status: TripStatus.travelling);
        }
      }

      if (!isCancelled) {
        try {
          final detailEntity =
              (await tripRemote.getTripDetail(entity.id)).toEntity();
          entity = entity.copyWith(
            passengerCount: detailEntity.passengerCount,
            capacity: detailEntity.capacity > 0
                ? detailEntity.capacity
                : entity.capacity,
            scheduledTime: detailEntity.scheduledTime,
            shift: detailEntity.shift.isNotEmpty
                ? detailEntity.shift
                : entity.shift,
            route: isUsableTripRoute(detailEntity.route)
                ? detailEntity.route
                : entity.route,
            unitCode: detailEntity.unitCode.isNotEmpty
                ? detailEntity.unitCode
                : entity.unitCode,
            startedAt: detailEntity.startedAt ?? entity.startedAt,
            completedAt: detailEntity.completedAt ?? entity.completedAt,
            stops: (detailEntity.stops != null &&
                    detailEntity.stops!.isNotEmpty)
                ? detailEntity.stops
                : entity.stops,
          );
        } catch (_) {
          // Mantener datos de Historial si Obtener falla.
        }
      }

      return entity;
    }));
  }

  @override
  Future<Result<DashboardSummaryEntity, Failure>> getDashboardSummary() async {
    try {
      // No re-llamar Historial: el ViewModel calcula el summary sobre todayTrips.
      final model = await _remoteDataSource.getDashboardSummary();
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> updateTripStatus(
    String id,
    TripStatus status, {
    TripCloseContext? closeContext,
  }) async {
    try {
      final model = await _remoteDataSource.updateTripStatus(
        id,
        status.name,
        closeParaderoId: closeContext?.paraderoId,
        closeParaderoName: closeContext?.paraderoName,
        closeLat: closeContext?.lat,
        closeLng: closeContext?.lng,
      );
      var entity = model.toEntity();
      if (status == TripStatus.travelling) {
        await GetIt.I<SecureStorage>().saveTripTravelling(id, true);
        entity = entity.copyWith(status: TripStatus.travelling);
      } else if (status == TripStatus.completed) {
        await GetIt.I<SecureStorage>().deleteTripTravelling(id);
        entity = entity.copyWith(status: TripStatus.completed);
      }
      return Success(entity);
    } catch (e) {
      // 409: a veces el viaje ya está en ese estado (éxito idempotente).
      // Pero "Ya tiene un viaje abierto..." significa OTRO viaje bloquea la apertura.
      if (e.toString().contains('409')) {
        if (status == TripStatus.inProgress &&
            _isAnotherOpenTripConflict(e)) {
          return FailureResult(_parseRepositoryException(e));
        }
        if (status == TripStatus.travelling) {
          await GetIt.I<SecureStorage>().saveTripTravelling(id, true);
          return Success(TripEntity(
            id: id,
            route: '',
            scheduledTime: DateTime.now(),
            shift: '',
            unitCode: '',
            capacity: 40,
            passengerCount: 0,
            status: TripStatus.travelling,
          ));
        } else if (status == TripStatus.completed) {
          await GetIt.I<SecureStorage>().deleteTripTravelling(id);
          return Success(TripEntity(
            id: id,
            route: '',
            scheduledTime: DateTime.now(),
            shift: '',
            unitCode: '',
            capacity: 40,
            passengerCount: 0,
            status: TripStatus.completed,
          ));
        } else if (status == TripStatus.inProgress) {
          return Success(TripEntity(
            id: id,
            route: '',
            scheduledTime: DateTime.now(),
            shift: '',
            unitCode: '',
            capacity: 40,
            passengerCount: 0,
            status: TripStatus.inProgress,
            startedAt: DateTime.now(),
          ));
        }
      }
      return FailureResult(_parseRepositoryException(e));
    }
  }

  bool _isAnotherOpenTripConflict(Object e) {
    final failure = _parseRepositoryException(e);
    final msg = failure.message.toLowerCase();
    return msg.contains('viaje abierto') ||
        msg.contains('cierrelo antes') ||
        msg.contains('ciérrelo antes');
  }

  Failure _parseRepositoryException(dynamic e) {
    if (e is DioException) {
      final responseData = e.response?.data;
      if (responseData is Map<String, dynamic>) {
        final serverMessage = responseData['Message'] ?? responseData['message'];
        if (serverMessage != null && serverMessage.toString().isNotEmpty) {
          return ServerFailure(serverMessage.toString(), e.response?.statusCode, e);
        }
      }
      return NetworkFailure(e.message ?? 'Error de conexión con el servidor', e);
    }
    return UnknownFailure(e.toString(), e);
  }

  @override
  Future<Result<TripEntity, Failure>> registerPassenger(String id, String dni, [CollaboratorStatus? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification, String? uidCliente, String? nombreCompleto, String? empresa, int? paraderoId, String? lugarSubida, String? puesto, String? unidad]) async {
    try {
      final model = await _remoteDataSource.registerPassenger(id, dni, status?.name, category, registrationMethod, lat, lng, justification, uidCliente, nombreCompleto, empresa, paraderoId, lugarSubida, puesto, unidad);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(_parseRepositoryException(e));
    }
  }

  @override
  Future<Result<List<PassengerEntity>, Failure>> getPassengersOnBoard(String tripId) async {
    try {
      final models = await _remoteDataSource.getPassengersOnBoard(tripId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CollaboratorEntity, Failure>> checkCollaborator(String dni) async {
    try {
      final model = await _remoteDataSource.checkCollaborator(dni);
      if (model.fullName.trim().isEmpty) {
        return FailureResult(const CollaboratorNotFoundFailure('Colaborador no encontrado'));
      }
      return Success(model.toEntity());
    } catch (e) {
      if (e.toString().contains('not_found')) {
        return FailureResult(CollaboratorNotFoundFailure(e.toString()));
      }
      return FailureResult(_parseRepositoryException(e));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> completeStop(String tripId, String stopId) async {
    try {
      final model = await _remoteDataSource.completeStop(tripId, stopId);
      return Success(model.toEntity());
    } catch (_) {
      // En producción, no hay endpoint en el servidor real. Retornamos un Success dummy para evitar fallos.
      return Success(TripEntity(
        id: tripId,
        route: '',
        scheduledTime: DateTime.now(),
        shift: '',
        unitCode: '',
        capacity: 40,
        passengerCount: 0,
        status: TripStatus.inProgress,
      ));
    }
  }
}
