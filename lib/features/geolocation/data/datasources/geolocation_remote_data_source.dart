import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/features/geolocation/data/models/nearest_stop_model.dart';

abstract class GeolocationRemoteDataSource {
  Future<NearestStopModel> resolveNearestStop(double lat, double lng);
}

class GeolocationRemoteDataSourceImpl implements GeolocationRemoteDataSource {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  GeolocationRemoteDataSourceImpl(this._dioClient, this._secureStorage);

  @override
  Future<NearestStopModel> resolveNearestStop(double lat, double lng) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Pasajero/ResolverParadero',
      data: {
        'usuario': username,
        'token': token,
        'lat': lat,
        'lng': lng,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      if (data['Success'] == true) {
        return NearestStopModel.fromJson(data['Data']);
      }
      throw Exception(data['Message'] ?? 'Fallo al resolver paradero');
    }
    throw Exception('Error del servidor al resolver paradero');
  }
}

class MockGeolocationRemoteDataSource implements GeolocationRemoteDataSource {
  @override
  Future<NearestStopModel> resolveNearestStop(double lat, double lng) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Devolver paradero mockizado cercano
    return const NearestStopModel(
      paraderoId: 2,
      nombre: 'Catacaos (Simulado)',
      distanciaMetros: 12.5,
    );
  }
}
