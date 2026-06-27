import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/features/auth/data/models/login_request.dart';
import 'package:mining_transport_app/features/auth/data/models/login_response.dart';

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
    final response = await _dioClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
