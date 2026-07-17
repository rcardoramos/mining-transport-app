import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import '../repositories/trip_repository.dart';

/// Caso de uso para obtener el detalle completo de un viaje.
class GetTripDetailUseCase {
  final TripRepository _repository;

  GetTripDetailUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute(String tripId) {
    return _repository.getTripDetail(tripId);
  }
}
