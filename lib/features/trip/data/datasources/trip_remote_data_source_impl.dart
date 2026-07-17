import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/features/home/data/models/trip_model.dart';
import 'trip_remote_data_source.dart';

/// Implementación real del [TripRemoteDataSource] que se comunica con
/// el backend corporativo en .NET a través de [DioClient].
class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  TripRemoteDataSourceImpl(this._dioClient, this._secureStorage);

  @override
  Future<List<TripModel>> getTodayTrips() async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Historial',
      data: {
        'usuario': username,
        'token': token,
        'estado': 'TODOS',
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final list = wrapped['Data'] as List<dynamic>;
    return list.map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TripModel>> getPendingTrips() async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Historial',
      data: {
        'usuario': username,
        'token': token,
        'estado': 'PENDIENTE',
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final list = wrapped['Data'] as List<dynamic>;
    return list.map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<TripModel> openTrip({required String tripId, required int startKm}) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Aperturar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
        'kmInicial': startKm,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }

  @override
  Future<TripModel> closeTrip({required String tripId, required int endKm}) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Cerrar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
        'kmFinal': endKm,
        'paraderoCierreId': 1,
        'lat': 0.0,
        'lng': 0.0,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }

  @override
  Future<TripModel> getTripDetail(String tripId) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Obtener',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }
}
