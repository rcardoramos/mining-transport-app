import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/trip_entity.dart';
import '../entities/collaborator_entity.dart';
import '../repositories/home_dashboard_repository.dart';

/// Caso de uso para registrar el embarque de un pasajero mediante su DNI.
class RegisterPassengerUseCase {
  final HomeDashboardRepository _repository;

  RegisterPassengerUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute(String tripId, String dni, [CollaboratorStatus? status, String? category]) {
    return _repository.registerPassenger(tripId, dni, status, category);
  }
}
