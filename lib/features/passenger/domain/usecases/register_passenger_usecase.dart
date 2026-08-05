import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';

/// Caso de uso para registrar el embarque de un pasajero mediante su DNI.
class RegisterPassengerUseCase {
  final HomeDashboardRepository _repository;

  RegisterPassengerUseCase(this._repository);

  Future<Result<TripEntity, Failure>> execute(
    String tripId,
    String dni, [
    CollaboratorStatus? status,
    String? category,
    String? registrationMethod,
    double? lat,
    double? lng,
    String? justification,
    String? uidCliente,
    String? nombreCompleto,
    String? empresa,
    int? paraderoId,
    String? lugarSubida,
    String? puesto,
    String? unidad,
  ]) {
    return _repository.registerPassenger(
      tripId,
      dni,
      status,
      category,
      registrationMethod,
      lat,
      lng,
      justification,
      uidCliente,
      nombreCompleto,
      empresa,
      paraderoId,
      lugarSubida,
      puesto,
      unidad,
    );
  }
}
