import 'package:mining_transport_app/features/home/data/models/trip_model.dart';

/// Interfaz abstracta del Data Source remoto del módulo Trip.
/// Define las operaciones de datos puras sin implementación tecnológica.
abstract class TripRemoteDataSource {
  /// Obtiene los viajes programados para el día de hoy.
  Future<List<TripModel>> getTodayTrips();

  /// Obtiene los viajes pendientes de días futuros.
  Future<List<TripModel>> getPendingTrips();

  /// Apertura un viaje registrando el kilometraje inicial.
  Future<TripModel> openTrip({required String tripId, required int startKm});

  /// Cierra un viaje registrando el kilometraje final.
  Future<TripModel> closeTrip({required String tripId, required int endKm});

  /// Obtiene el detalle completo de un viaje por su ID.
  Future<TripModel> getTripDetail(String tripId);
}
