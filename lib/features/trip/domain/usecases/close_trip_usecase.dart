import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

/// Caso de uso para cerrar un viaje activo.
///
/// Regla de negocio: [endKm] debe ser estrictamente mayor al [startKm]
/// registrado al aperturar el viaje.
class CloseTripUseCase {
  final TripRepository _repository;

  CloseTripUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute({
    required String tripId,
    required int endKm,
    int? startKm,
  }) {
    // Validación: kilometraje final debe ser mayor al inicial
    if (startKm != null && endKm <= startKm) {
      return Future.value(
        FailureResult(
          ValidationFailure(
            'El kilometraje final ($endKm km) debe ser mayor al inicial ($startKm km).',
          ),
        ),
      );
    }

    if (endKm <= 0) {
      return Future.value(
        FailureResult(
          ValidationFailure('El kilometraje final debe ser mayor a cero.'),
        ),
      );
    }

    return _repository.closeTrip(tripId: tripId, endKm: endKm);
  }
}
