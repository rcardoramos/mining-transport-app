import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/features/manifest/data/models/manifest_dto.dart';

abstract class ManifestRemoteDataSource {
  Future<ManifestDto> fetchViajeManifiesto(String tripId);
}

class ManifestRemoteDataSourceImpl implements ManifestRemoteDataSource {
  ManifestRemoteDataSourceImpl(this._dioClient, this._secureStorage, this._logger);

  final DioClient _dioClient;
  final SecureStorage _secureStorage;
  final AppLogger _logger;

  @override
  Future<ManifestDto> fetchViajeManifiesto(String tripId) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Manifiesto',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? tripId,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    if (wrapped['Success'] != true) {
      final message = (wrapped['Message'] ??
              wrapped['message'] ??
              'No pudimos generar el manifiesto. Inténtelo nuevamente.')
          .toString();
      _logger.e('Viaje/Manifiesto Success=false: $message');
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }

    final data = wrapped['Data'];
    if (data is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Respuesta de manifiesto inválida.',
      );
    }
    return ManifestDto.fromJson(Map<String, dynamic>.from(data));
  }
}
