import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/trip_entity.dart';
import '../repositories/home_dashboard_repository.dart';

class GetPendingTripsUseCase {
  final HomeDashboardRepository _repository;

  GetPendingTripsUseCase(this._repository);

  Future<Result<List<TripEntity>, Failure>> execute() {
    return _repository.getPendingTrips();
  }
}
