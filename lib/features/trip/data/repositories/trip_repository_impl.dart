import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_remote_data_source.dart';

/// Implementación del [TripRepository] con estrategia Offline-First.
///
/// - Si hay red disponible → llama al datasource remoto directamente.
/// - Si no hay red → encola la acción en [SyncQueue] y actualiza el estado
///   en el mock datasource local para mantener la UI reactiva.
class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource _remoteDataSource;
  final Ref _ref;

  TripRepositoryImpl(this._remoteDataSource, this._ref);

  @override
  Future<Result<List<TripEntity>, Failure>> getTodayTrips() async {
    try {
      final models = await _remoteDataSource.getTodayTrips();
      return Success(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getPendingTrips() async {
    try {
      final models = await _remoteDataSource.getPendingTrips();
      return Success(models.map((m) => m.toEntity()).toList());
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
      // Modo Offline: encolar en SyncQueue
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'OPEN_TRIP',
        payloadJson: jsonEncode({'tripId': tripId, 'startKm': startKm}),
      );
      // Actualizar estado local en el mock para mantener la UI reactiva
      try {
        final model = await _remoteDataSource.openTrip(tripId: tripId, startKm: startKm);
        return Success(model.toEntity());
      } catch (e) {
        return FailureResult(UnknownFailure(e.toString()));
      }
    }

    try {
      final model = await _remoteDataSource.openTrip(tripId: tripId, startKm: startKm);
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
      // Modo Offline: encolar en SyncQueue
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'CLOSE_TRIP',
        payloadJson: jsonEncode({'tripId': tripId, 'endKm': endKm}),
      );
      // Actualizar estado local en el mock para mantener la UI reactiva
      try {
        final model = await _remoteDataSource.closeTrip(tripId: tripId, endKm: endKm);
        return Success(model.toEntity());
      } catch (e) {
        return FailureResult(UnknownFailure(e.toString()));
      }
    }

    try {
      final model = await _remoteDataSource.closeTrip(tripId: tripId, endKm: endKm);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> getTripDetail(String tripId) async {
    try {
      final model = await _remoteDataSource.getTripDetail(tripId);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
