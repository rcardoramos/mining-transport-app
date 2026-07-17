import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/di/injection_container.dart';
import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mining_transport_app/features/auth/data/models/login_request.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/features/auth/data/models/user_model.dart';

/// Implementación del repositorio [AuthRepository] encargado de coordinar
/// la lógica de autenticación online y offline.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<UserEntity, Failure>> login(String username, String password) async {
    try {
      double latitude = -5.194490;
      double longitude = -80.632820;
      try {
        final position = locator<GpsService>().currentPosition;
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (_) {}

      // Intentar login remoto con el servidor ERP
      final response = await _remoteDataSource.login(
        LoginRequest(
          username: username,
          password: password,
          lat: latitude,
          lng: longitude,
        ),
      );

      // Guardar sesión y tokens de forma local
      await _localDataSource.saveToken(response.token);
      final userWithToken = response.user.copyWith(token: response.token);
      await _localDataSource.saveUser(userWithToken);
      await _localDataSource.saveUsername(username);

      // Guardar hash de la contraseña para validación offline
      final hash = _hashPassword(password);
      await _localDataSource.savePasswordHash(hash);

      return Success(userWithToken.toEntity());
    } on DioException catch (e) {
      // Si el error es de conectividad, intentar login local en caché
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.error is SocketException) {
        return await _loginOffline(username, password);
      }

      // Manejar códigos de error específicos del backend
      if (e.response?.statusCode == 401) {
        return const FailureResult(UnauthorizedFailure('Usuario o contraseña incorrectos.'));
      }
      if (e.type == DioExceptionType.badResponse && e.error is String) {
        return FailureResult(UnauthorizedFailure(e.error as String));
      }
      if (e.response?.statusCode == 423) {
        return const FailureResult(ValidationFailure('Usuario bloqueado administrativamente.'));
      }

      return FailureResult(ServerFailure(
        'Error en el servidor de autenticación.',
        e.response?.statusCode,
        e,
      ));
    } catch (e) {
      if (e is SocketException) {
        return await _loginOffline(username, password);
      }
      return FailureResult(UnknownFailure('Error inesperado durante el inicio de sesión.', e));
    }
  }

  @override
  Future<Result<void, Failure>> logout() async {
    try {
      await _localDataSource.clearSession();
      return const Success(null);
    } catch (e) {
      return FailureResult(DatabaseFailure('Error al limpiar la sesión local.', e));
    }
  }

  @override
  Future<Result<UserEntity?, Failure>> getCurrentUser() async {
    try {
      final userModel = await _localDataSource.getUser();
      if (userModel == null) return const Success(null);
      return Success(userModel.toEntity());
    } catch (e) {
      return FailureResult(DatabaseFailure('Error al leer el usuario local.', e));
    }
  }

  @override
  Future<Result<bool, Failure>> checkSession() async {
    try {
      final token = await _localDataSource.getToken();
      final user = await _localDataSource.getUser();
      if (token != null && user != null) {
        return const Success(true);
      }
      return const Success(false);
    } catch (e) {
      return FailureResult(CacheFailure('Error al comprobar la sesión.', e));
    }
  }

  /// Realiza el inicio de sesión offline comparando con las credenciales locales cifradas.
  Future<Result<UserEntity, Failure>> _loginOffline(String username, String password) async {
    try {
      final storedUsername = await _localDataSource.getUsername();
      final storedHash = await _localDataSource.getPasswordHash();
      final cachedUser = await _localDataSource.getUser();

      if (storedUsername == null || storedHash == null || cachedUser == null) {
        return const FailureResult(NetworkFailure(
          'Sin conexión a internet y no se encontraron credenciales locales guardadas.',
        ));
      }

      if (storedUsername.toLowerCase() != username.toLowerCase()) {
        return const FailureResult(UnauthorizedFailure(
          'Las credenciales offline no coinciden con la última sesión guardada.',
        ));
      }

      final enteredHash = _hashPassword(password);
      if (storedHash != enteredHash) {
        return const FailureResult(UnauthorizedFailure(
          'Contraseña offline incorrecta.',
        ));
      }

      return Success(cachedUser.toEntity());
    } catch (e) {
      return FailureResult(DatabaseFailure('Error al validar sesión offline.', e));
    }
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
