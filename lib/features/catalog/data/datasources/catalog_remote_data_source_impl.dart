import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:mining_transport_app/features/catalog/data/models/catalog_models.dart';

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl(this._dioClient, this._secureStorage, this._logger);

  final DioClient _dioClient;
  final SecureStorage _secureStorage;
  final AppLogger _logger;

  @override
  Future<CatalogBootstrapModel> fetchBootstrap() async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Catalogo/Bootstrap',
      data: {
        'usuario': username,
        'token': token,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final success = wrapped['Success'] == true;
    if (!success) {
      final message =
          (wrapped['Message'] ?? wrapped['message'] ?? 'No se pudieron cargar los catálogos.')
              .toString();
      _logger.e('Catalogo/Bootstrap Success=false: $message');
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }

    final data = wrapped['Data'];
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Respuesta de catálogos inválida.',
      );
    }

    return CatalogBootstrapModel.fromJson(data);
  }
}
