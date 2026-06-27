import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para obtener el usuario autenticado actualmente en memoria o base de datos.
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Recupera el usuario activo.
  Future<Result<UserEntity?, Failure>> call() {
    return _repository.getCurrentUser();
  }
}
