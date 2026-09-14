import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  static const String _keyToken = 'jwt_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyPin = 'user_pin';
  static const String _keyUsername = 'cached_username';
  static const String _keyPasswordHash = 'password_hash';
  static const String _keyDriverId = 'cached_driver_id';
  static const String _keyFullName = 'cached_full_name';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
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

  Future<void> saveDriverId(String driverId) async {
    await _storage.write(key: _keyDriverId, value: driverId);
  }

  Future<String?> getDriverId() async {
    return await _storage.read(key: _keyDriverId);
  }

  Future<void> deleteDriverId() async {
    await _storage.delete(key: _keyDriverId);
  }

  Future<void> saveFullName(String fullName) async {
    await _storage.write(key: _keyFullName, value: fullName);
  }

  Future<String?> getFullName() async {
    return await _storage.read(key: _keyFullName);
  }

  Future<void> deleteFullName() async {
    await _storage.delete(key: _keyFullName);
  }

  Future<void> savePasswordHash(String hash) async {
    await _storage.write(key: _keyPasswordHash, value: hash);
  }

  Future<String?> getPasswordHash() async {
    return await _storage.read(key: _keyPasswordHash);
  }

  Future<void> deletePasswordHash() async {
    await _storage.delete(key: _keyPasswordHash);
  }


  Future<void> saveTripTravelling(String tripId, bool travelling) async {
    await _storage.write(key: 'trip_travelling_$tripId', value: travelling.toString());
  }

  Future<bool> isTripTravelling(String tripId) async {
    final val = await _storage.read(key: 'trip_travelling_$tripId');
    return val == 'true';
  }

  Future<void> deleteTripTravelling(String tripId) async {
    await _storage.delete(key: 'trip_travelling_$tripId');
  }

  String _completedStopsKey(String tripId) => 'trip_completed_stops_$tripId';

  /// IDs de paraderos ya completados en el viaje (avance local / offline).
  Future<Set<String>> getCompletedStopIds(String tripId) async {
    final raw = await _storage.read(key: _completedStopsKey(tripId));
    if (raw == null || raw.trim().isEmpty) return <String>{};
    return raw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
  }

  Future<void> markStopCompleted(String tripId, String stopId) async {
    final id = stopId.trim();
    if (id.isEmpty) return;
    final current = await getCompletedStopIds(tripId);
    if (!current.add(id)) return;
    await _storage.write(
      key: _completedStopsKey(tripId),
      value: current.join(','),
    );
  }

  Future<void> clearCompletedStops(String tripId) async {
    await _storage.delete(key: _completedStopsKey(tripId));
  }

  String _tripStartedAtKey(String tripId) => 'trip_started_at_$tripId';

  /// Hora real de "Iniciar viaje" (no aperturar embarque).
  Future<void> saveTripStartedAt(String tripId, DateTime startedAt) async {
    await _storage.write(
      key: _tripStartedAtKey(tripId),
      value: startedAt.toUtc().toIso8601String(),
    );
  }

  Future<DateTime?> getTripStartedAt(String tripId) async {
    final raw = await _storage.read(key: _tripStartedAtKey(tripId));
    if (raw == null || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw)?.toUtc();
  }

  Future<void> clearTripStartedAt(String tripId) async {
    await _storage.delete(key: _tripStartedAtKey(tripId));
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
