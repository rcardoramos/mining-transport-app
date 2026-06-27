import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para realizar el inicio de sesión.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Ejecuta el flujo de login llamando al repositorio.
  Future<Result<UserEntity, Failure>> call(String username, String password) {
    return _repository.login(username, password);
  }
}
