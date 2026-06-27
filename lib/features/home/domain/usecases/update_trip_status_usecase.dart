import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/trip_entity.dart';
import '../repositories/home_dashboard_repository.dart';

class UpdateTripStatusUseCase {
  final HomeDashboardRepository _repository;

  UpdateTripStatusUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute(String tripId, TripStatus status) {
    return _repository.updateTripStatus(tripId, status);
  }
}
