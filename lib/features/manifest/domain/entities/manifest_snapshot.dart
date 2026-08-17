import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';

/// Snapshot de manifiesto (mismo concepto para anticipado y final).
class ManifestSnapshot {
  const ManifestSnapshot({
    required this.tripId,
    required this.passengers,
    this.headerRoute,
    this.headerPlate,
    this.headerDriverName,
    this.headerShift,
    this.headerService,
    this.rawEstado,
    this.source = ManifestDataSource.passengersList,
  });

  final String tripId;
  final List<PassengerEntity> passengers;
  final String? headerRoute;
  final String? headerPlate;
  final String? headerDriverName;
  final String? headerShift;
  final String? headerService;
  final String? rawEstado;
  final ManifestDataSource source;

  bool get hasPassengers => passengers.isNotEmpty;
}

enum ManifestDataSource {
  /// POST /api/Viaje/Manifiesto
  viajeManifiesto,

  /// Fallback: POST /api/Pasajero/Lista (+ datos locales del viaje)
  passengersList,
}

/// Resultado listo para PDF/preview sin mutar el estado del viaje.
class ManifestGenerationResult {
  const ManifestGenerationResult({
    required this.snapshot,
    required this.trip,
    required this.driverName,
    required this.generatedAt,
  });

  final ManifestSnapshot snapshot;
  final TripEntity trip;
  final String driverName;
  final DateTime generatedAt;

  String get statusLabel {
    switch (trip.status) {
      case TripStatus.completed:
        return 'FINALIZADO';
      case TripStatus.cancelled:
        return 'CANCELADO';
      case TripStatus.travelling:
      case TripStatus.inProgress:
        return 'EN CURSO';
      default:
        return trip.status.name.toUpperCase();
    }
  }

  String get fileName {
    final id = trip.id.replaceAll(RegExp(r'[^\w-]'), '');
    final d = generatedAt.toLocal();
    final stamp =
        '${d.year.toString().padLeft(4, '0')}'
        '${d.month.toString().padLeft(2, '0')}'
        '${d.day.toString().padLeft(2, '0')}_'
        '${d.hour.toString().padLeft(2, '0')}'
        '${d.minute.toString().padLeft(2, '0')}';
    return 'manifiesto_viaje_${id}_$stamp.pdf';
  }
}
