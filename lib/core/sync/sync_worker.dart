import 'dart:convert';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:get_it/get_it.dart';

class SyncWorker {
  final SyncQueueManager _queueManager = GetIt.I<SyncQueueManager>();
  HomeDashboardRepository get _homeRepository => GetIt.I<HomeDashboardRepository>();

  Future<void> processQueue() async {
    final pending = await _queueManager.getPendingActions();
    if (pending.isEmpty) return;

    for (final action in pending) {
      final attempts = action.attempts + 1;
      try {
        final payload = jsonDecode(action.payloadJson) as Map<String, dynamic>;

        if (action.actionType == 'BOARD_PASSENGER') {
          final tripId = payload['tripId'] as String;
          final dni = payload['dni'] as String;
          final category = payload['category'] as String?;
          final registrationMethod = payload['registrationMethod'] as String?;
          final lat = payload['lat'] as double?;
          final lng = payload['lng'] as double?;
          final justification = payload['justification'] as String?;

          final result = await _homeRepository.registerPassenger(
            tripId,
            dni,
            null, // Will be resolved by remote/mock repository impl
            category,
            registrationMethod,
            lat,
            lng,
            justification,
          );

          if (result.isSuccess) {
            await _queueManager.markAsSynced(action.id);
          } else {
            await _queueManager.markAsFailed(
              action.id,
              result.failureOrNull?.message ?? 'Error desconocido',
              attempts,
            );
          }
        } else if (action.actionType == 'CLOSE_TRIP') {
          final tripId = payload['tripId'] as String;
          final result = await _homeRepository.updateTripStatus(
            tripId,
            TripStatus.completed,
          );

          if (result.isSuccess) {
            await _queueManager.markAsSynced(action.id);
          } else {
            await _queueManager.markAsFailed(
              action.id,
              result.failureOrNull?.message ?? 'Error al cerrar viaje',
              attempts,
            );
          }
        } else if (action.actionType == 'COMPLETE_STOP') {
          final tripId = payload['tripId'] as String;
          final stopId = payload['stopId'] as String;

          final result = await _homeRepository.completeStop(tripId, stopId);

          if (result.isSuccess) {
            await _queueManager.markAsSynced(action.id);
          } else {
            await _queueManager.markAsFailed(
              action.id,
              result.failureOrNull?.message ?? 'Error al completar paradero',
              attempts,
            );
          }
        }
      } catch (e) {
        await _queueManager.markAsFailed(action.id, e.toString(), attempts);
      }
    }
  }
}
