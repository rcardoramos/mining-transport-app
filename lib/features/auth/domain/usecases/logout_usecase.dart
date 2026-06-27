import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cerrar sesión.
class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  /// Ejecuta el flujo de cierre de sesión limpiando tokens y estados.
  Future<Result<void, Failure>> call() {
    return _repository.logout();
  }
}
