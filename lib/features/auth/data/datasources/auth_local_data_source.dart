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
    // Backup: Crear viaje / hidratación si Drift queda incompleto tras migrar.
    if (user.driverId != null && user.driverId!.trim().isNotEmpty) {
      await _secureStorage.saveDriverId(user.driverId!.trim());
    }
    if (user.fullName.trim().isNotEmpty) {
      await _secureStorage.saveFullName(user.fullName.trim());
    }
    if (user.username.trim().isNotEmpty) {
      await _secureStorage.saveUsername(user.username.trim());
    }
  }

  @override
  Future<UserModel?> getUser() async {
    UserModel? user;
    try {
      final userRow = await _database.select(_database.users).getSingleOrNull();
      if (userRow != null) {
        user = UserModel.fromDrift(userRow);
      }
    } catch (_) {
      user = null;
    }

    final storedDriverId = await _secureStorage.getDriverId();
    final storedFullName = await _secureStorage.getFullName();
    final storedUsername = await _secureStorage.getUsername();

    if (user == null) {
      if ((storedUsername == null || storedUsername.isEmpty) &&
          (storedDriverId == null || storedDriverId.isEmpty)) {
        return null;
      }
      return UserModel(
        id: storedUsername ?? 'session',
        username: storedUsername ?? '',
        fullName: storedFullName ?? storedUsername ?? '',
        role: 'DRIVER',
        driverId: storedDriverId,
      );
    }

    final needsHydration =
        (user.driverId == null || user.driverId!.trim().isEmpty) ||
            user.fullName.trim().isEmpty;
    if (!needsHydration) return user;

    final hydrated = user.copyWith(
      driverId: (user.driverId == null || user.driverId!.trim().isEmpty)
          ? storedDriverId
          : user.driverId,
      fullName: user.fullName.trim().isEmpty
          ? (storedFullName ?? user.username)
          : user.fullName,
    );

    try {
      await _database
          .into(_database.users)
          .insertOnConflictUpdate(hydrated.toDrift());
    } catch (_) {}

    return hydrated;
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
    await _secureStorage.deleteDriverId();
    await _secureStorage.deleteFullName();
  }
}
