import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para verificar la existencia y validez de la sesión local.
class CheckSessionUseCase {
  final AuthRepository _repository;

  CheckSessionUseCase(this._repository);

  /// Retorna true si hay una sesión válida activa, false en caso contrario.
  Future<Result<bool, Failure>> call() {
    return _repository.checkSession();
  }
}
