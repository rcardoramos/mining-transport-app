import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/dashboard_summary_model.dart';
import '../models/passenger_model.dart';
import '../models/collaborator_model.dart';

/// Interfaz abstracta del Data Source remoto de Home Dashboard.
abstract class HomeDashboardRemoteDataSource {
  Future<DriverModel> getDriverInfo();
  Future<List<TripModel>> getTodayTrips();
  Future<List<TripModel>> getPendingTrips();
  Future<DashboardSummaryModel> getDashboardSummary();
  Future<TripModel> updateTripStatus(String id, String status);
  Future<TripModel> registerPassenger(String id, String dni, [String? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification]);
  /// Retorna la lista de [PassengerModel] registrados en el viaje [tripId].
  Future<List<PassengerModel>> getPassengersOnBoard(String tripId);
  /// Obtiene los detalles de un colaborador por su DNI.
  Future<CollaboratorModel> checkCollaborator(String dni);
  /// Completa el abordaje de un paradero.
  Future<TripModel> completeStop(String id, String stopId);
}
