import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/trip_entity.dart';
import '../repositories/home_dashboard_repository.dart';

class GetTodayTripsUseCase {
  final HomeDashboardRepository _repository;

  GetTodayTripsUseCase(this._repository);

  Future<Result<List<TripEntity>, Failure>> execute() {
    return _repository.getTodayTrips();
  }
}
