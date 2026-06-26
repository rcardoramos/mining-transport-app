import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  static const String _keyToken = 'jwt_token';
  static const String _keyPin = 'user_pin';
  static const String _keyUsername = 'cached_username';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  Future<void> savePIN(String pin) async {
    await _storage.write(key: _keyPin, value: pin);
  }

  Future<String?> getPIN() async {
    return await _storage.read(key: _keyPin);
  }

  Future<void> deletePIN() async {
    await _storage.delete(key: _keyPin);
  }

  Future<void> saveUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: _keyUsername);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
