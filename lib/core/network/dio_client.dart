import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/di/injection_container.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/session_status_service.dart';

class DioClient {
  final Dio _dio;
  final SecureStorage _secureStorage;
  final AppLogger _logger;

  DioClient({
    required SecureStorage secureStorage,
    required AppLogger logger,
  })  : _secureStorage = secureStorage,
        _logger = logger,
        _dio = Dio(
          BaseOptions(
            baseUrl: EnvConfig.instance.baseUrl,
            connectTimeout: EnvConfig.instance.connectTimeout,
            receiveTimeout: EnvConfig.instance.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.addAll([
      _AuthInterceptor(secureStorage: _secureStorage),
      _LoggingInterceptor(logger: _logger),
    ]);
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  _AuthInterceptor({required SecureStorage secureStorage}) : _secureStorage = secureStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Borrar credenciales de almacenamiento local al desautorizarse
      await _secureStorage.deleteToken();
      await _secureStorage.deleteRefreshToken();
      
      // Notificar al sistema que la sesión expiró
      if (locator.isRegistered<SessionStatusService>()) {
        locator<SessionStatusService>().notifySessionExpired();
      }
    }
    handler.next(err);
  }
}

class _LoggingInterceptor extends Interceptor {
  final AppLogger _logger;

  _LoggingInterceptor({required AppLogger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('HTTP Request: ${options.method} ${options.uri}');
    if (options.data != null) {
      _logger.d('HTTP Request Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d('HTTP Response: ${response.statusCode} ${response.requestOptions.uri}');
    _logger.d('HTTP Response Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('HTTP Error: ${err.response?.statusCode} ${err.requestOptions.uri}');
    _logger.e('HTTP Error Message: ${err.message}');
    handler.next(err);
  }
}
