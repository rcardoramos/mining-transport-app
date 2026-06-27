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
        '/auth/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Simular login exitoso en DEV si el servidor no responde o no está disponible
      if (EnvConfig.instance.environment == AppEnvironment.dev) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (request.username.isNotEmpty && request.password.isNotEmpty) {
          return LoginResponse(
            token: 'mock_jwt_token',
            user: UserModel(
              id: 'DRV-998',
              username: request.username,
              fullName: 'Ricardo Ramos',
              role: 'DRIVER',
            ),
          );
        }
      }
      rethrow;
    }
  }
}
