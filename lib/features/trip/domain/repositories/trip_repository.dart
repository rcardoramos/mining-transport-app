import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';

/// Contrato puro de la capa de Dominio para la gestión de viajes.
/// No conoce detalles de red ni de base de datos.
abstract class TripRepository {
  /// Retorna los viajes programados para el día de hoy.
  Future<Result<List<TripEntity>, Failure>> getTodayTrips();

  /// Retorna los viajes pendientes de días futuros.
  Future<Result<List<TripEntity>, Failure>> getPendingTrips();

  /// Apertura un viaje existente registrando el kilometraje inicial.
  ///
  /// [tripId] Identificador único del viaje a aperturar.
  /// [startKm] Lectura del odómetro al momento de apertura.
  Future<Result<TripEntity, Failure>> openTrip({
    required String tripId,
    required int startKm,
  });

  /// Cierra un viaje activo registrando el kilometraje final.
  ///
  /// [tripId] Identificador único del viaje a cerrar.
  /// [endKm] Lectura del odómetro al momento de cierre.
  /// Regla: [endKm] debe ser mayor que el [startKm] del viaje.
  Future<Result<TripEntity, Failure>> closeTrip({
    required String tripId,
    required int endKm,
  });

  /// Obtiene el detalle completo de un viaje específico,
  /// incluyendo paraderos autorizados y estado actual de aforo.
  Future<Result<TripEntity, Failure>> getTripDetail(String tripId);
}
