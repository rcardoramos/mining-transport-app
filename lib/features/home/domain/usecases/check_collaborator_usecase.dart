import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/collaborator_entity.dart';
import '../repositories/home_dashboard_repository.dart';

/// Caso de uso para verificar la disponibilidad laboral y reglas de embarque de un colaborador por su DNI.
class CheckCollaboratorUseCase {
  final HomeDashboardRepository _repository;

  CheckCollaboratorUseCase(this._repository);

  Future<Result<CollaboratorEntity, Failure>> execute(String dni) {
    return _repository.checkCollaborator(dni);
  }
}
