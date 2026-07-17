import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/features/auth/data/models/login_request.dart';
import 'package:mining_transport_app/features/auth/data/models/login_response.dart';

import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/features/auth/data/models/user_model.dart';

/// Interfaz para la fuente de datos remota de autenticación.
abstract class AuthRemoteDataSource {
  /// Realiza la llamada HTTP de login al servidor remoto.
  Future<LoginResponse> login(LoginRequest request);
}

/// Implementación concreta de [AuthRemoteDataSource] utilizando [DioClient].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.dio.post(
        'api/Auth/Login',
        data: request.toJson(),
      );
      
      final wrapped = response.data as Map<String, dynamic>;
      final success = wrapped['Success'] as bool? ?? false;
      
      if (!success) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: wrapped['Message'] ?? 'Usuario o clave incorrectos',
        );
      }
      
      final data = wrapped['Data'] as Map<String, dynamic>;
      final token = data['Token'] as String;
      final userJson = data['User'] as Map<String, dynamic>;
      
      return LoginResponse(
        token: token,
        user: UserModel.fromJson(userJson),
      );
    } catch (e) {
      // Simular login exitoso en DEV únicamente si el servidor no responde (error de red/conexión)
      // NUNCA si el servidor respondió explícitamente con credenciales inválidas.
      final isNetworkError = e is DioException && (
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.error is SocketException
      );

      if (isNetworkError && EnvConfig.instance.environment == AppEnvironment.dev) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (request.username.isNotEmpty && request.password.isNotEmpty) {
          return LoginResponse(
            token: 'mock_jwt_token',
            user: UserModel(
              id: 'DRV-998',
              username: request.username,
              fullName: 'Ricardo Ramos (Simulado)',
              role: 'DRIVER',
            ),
          );
        }
      }
      rethrow;
    }
  }
}
