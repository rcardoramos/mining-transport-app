import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

/// Caso de uso para aperturar un viaje.
///
/// Regla de negocio: solo se puede aperturar si no existe otro viaje en estado
/// [TripStatus.inProgress] para el mismo conductor.
class OpenTripUseCase {
  final TripRepository _repository;

  OpenTripUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute({
    required String tripId,
    required int startKm,
    List<TripEntity> currentTrips = const [],
  }) {
    // Validación: no puede haber otro viaje en curso
    final hasActiveTrip = currentTrips.any(
      (t) => t.status == TripStatus.inProgress || t.status == TripStatus.travelling,
    );

    if (hasActiveTrip) {
      return Future.value(
        FailureResult(
          ValidationFailure('Ya existe un viaje en curso. Ciérralo antes de aperturar uno nuevo.'),
        ),
      );
    }

    if (startKm <= 0) {
      return Future.value(
        FailureResult(
          ValidationFailure('El kilometraje inicial debe ser mayor a cero.'),
        ),
      );
    }

    return _repository.openTrip(tripId: tripId, startKm: startKm);
  }
}
