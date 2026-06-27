import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/features/auth/data/models/user_model.dart';

/// Interfaz para la fuente de datos local de autenticación.
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> deleteRefreshToken();

  Future<void> saveUsername(String username);
  Future<String?> getUsername();

  Future<void> savePasswordHash(String hash);
  Future<String?> getPasswordHash();

  Future<void> savePIN(String pin);
  Future<String?> getPIN();

  /// Persiste el modelo de usuario en la base de datos relacional local (Drift).
  Future<void> saveUser(UserModel user);

  /// Recupera el usuario guardado localmente desde Drift.
  Future<UserModel?> getUser();

  /// Elimina los registros del usuario de la base de datos local.
  Future<void> deleteUser();

  /// Limpia los tokens y datos de la sesión activa (por ejemplo, en el logout).
  Future<void> clearSession();
}

/// Implementación concreta de [AuthLocalDataSource] usando [SecureStorage] y [AppDatabase].
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;
  final AppDatabase _database;

  AuthLocalDataSourceImpl(this._secureStorage, this._database);

  @override
  Future<void> saveToken(String token) => _secureStorage.saveToken(token);

  @override
  Future<String?> getToken() => _secureStorage.getToken();

  @override
  Future<void> deleteToken() => _secureStorage.deleteToken();

  @override
  Future<void> saveRefreshToken(String token) => _secureStorage.saveRefreshToken(token);

  @override
  Future<String?> getRefreshToken() => _secureStorage.getRefreshToken();

  @override
  Future<void> deleteRefreshToken() => _secureStorage.deleteRefreshToken();

  @override
  Future<void> saveUsername(String username) => _secureStorage.saveUsername(username);

  @override
  Future<String?> getUsername() => _secureStorage.getUsername();

  @override
  Future<void> savePasswordHash(String hash) => _secureStorage.savePasswordHash(hash);

  @override
  Future<String?> getPasswordHash() => _secureStorage.getPasswordHash();

  @override
  Future<void> savePIN(String pin) => _secureStorage.savePIN(pin);

  @override
  Future<String?> getPIN() => _secureStorage.getPIN();

  @override
  Future<void> saveUser(UserModel user) async {
    await _database.into(_database.users).insertOnConflictUpdate(user.toDrift());
  }

  @override
  Future<UserModel?> getUser() async {
    final userRow = await _database.select(_database.users).getSingleOrNull();
    if (userRow == null) return null;
    return UserModel.fromDrift(userRow);
  }

  @override
  Future<void> deleteUser() async {
    await _database.delete(_database.users).go();
  }

  @override
  Future<void> clearSession() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteUser();
  }
}
