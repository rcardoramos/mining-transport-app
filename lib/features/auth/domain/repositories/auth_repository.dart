import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';

/// Interfaz para el repositorio de autenticación en la capa de dominio.
abstract class AuthRepository {
  /// Realiza el inicio de sesión remoto u offline según disponibilidad.
  Future<Result<UserEntity, Failure>> login(String username, String password);

  /// Cierra la sesión activa limpiando los tokens y la base de datos local.
  Future<Result<void, Failure>> logout();

  /// Obtiene el usuario autenticado actualmente si existe en persistencia local.
  Future<Result<UserEntity?, Failure>> getCurrentUser();

  /// Comprueba la existencia y validez de la sesión iniciada al arrancar la app.
  Future<Result<bool, Failure>> checkSession();
}
