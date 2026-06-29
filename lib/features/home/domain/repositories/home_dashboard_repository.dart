import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/driver_entity.dart';
import '../entities/trip_entity.dart';
import '../entities/dashboard_summary_entity.dart';
import '../entities/passenger_entity.dart';
import '../entities/collaborator_entity.dart';

/// Interfaz abstracta del Repositorio de Home Dashboard en la capa de Dominio.
abstract class HomeDashboardRepository {
  Future<Result<DriverEntity, Failure>> getDriverInfo();
  Future<Result<List<TripEntity>, Failure>> getTodayTrips();
  Future<Result<List<TripEntity>, Failure>> getPendingTrips();
  Future<Result<DashboardSummaryEntity, Failure>> getDashboardSummary();
  Future<Result<TripEntity, Failure>> updateTripStatus(String id, TripStatus status);
  Future<Result<TripEntity, Failure>> registerPassenger(String id, String dni, [CollaboratorStatus? status, String? category]);
  /// Devuelve la lista de pasajeros registrados a bordo de un viaje.
  Future<Result<List<PassengerEntity>, Failure>> getPassengersOnBoard(String tripId);
  /// Verifica el estado laboral y de embarque de un colaborador por su DNI.
  Future<Result<CollaboratorEntity, Failure>> checkCollaborator(String dni);
}
