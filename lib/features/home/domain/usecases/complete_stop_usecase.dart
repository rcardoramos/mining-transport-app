import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/trip_entity.dart';
import '../repositories/home_dashboard_repository.dart';

/// Caso de uso para marcar un paradero como completado en un viaje.
class CompleteStopUseCase {
  final HomeDashboardRepository _repository;

  CompleteStopUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute(String tripId, String stopId) {
    return _repository.completeStop(tripId, stopId);
  }
}
