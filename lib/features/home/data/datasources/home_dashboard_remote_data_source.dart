import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/dashboard_summary_model.dart';

/// Interfaz abstracta del Data Source remoto de Home Dashboard.
abstract class HomeDashboardRemoteDataSource {
  Future<DriverModel> getDriverInfo();
  Future<List<TripModel>> getTodayTrips();
  Future<List<TripModel>> getPendingTrips();
  Future<DashboardSummaryModel> getDashboardSummary();
  Future<TripModel> updateTripStatus(String id, String status);
  Future<TripModel> registerPassenger(String id, String dni);
}
