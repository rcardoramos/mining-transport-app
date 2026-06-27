import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mining_transport_app/features/auth/data/models/login_request.dart';
import 'package:mining_transport_app/features/auth/data/models/login_response.dart';
import 'package:mining_transport_app/features/auth/data/models/user_model.dart';
import 'package:mining_transport_app/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late AuthRepositoryImpl repository;

  const tUsername = 'dispatcher_01';
  const tPassword = 'SecurePassword123';
  final tPasswordHash = sha256.convert(utf8.encode(tPassword)).toString();
  const tUserModel = UserModel(
    id: 'a6b1c8d2-4321-9876-bcde-5f4e3d2c1b0a',
    username: tUsername,
    fullName: 'Ricardo Ramos Julca',
    role: 'DISPATCHER',
  );
  const tToken = 'jwt_token';
  const tLoginResponse = LoginResponse(token: tToken, user: tUserModel);
  final tLoginRequest = LoginRequest(username: tUsername, password: tPassword);

  setUpAll(() {
    registerFallbackValue(tUserModel);
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('login online', () {
    test('debe retornar UserEntity e iniciar sesión exitosamente en red', () async {
      // Arrange
      when(() => mockRemoteDataSource.login(tLoginRequest))
          .thenAnswer((_) async => tLoginResponse);
      when(() => mockLocalDataSource.saveToken(any())).thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveUser(any())).thenAnswer((_) async {});
      when(() => mockLocalDataSource.saveUsername(any())).thenAnswer((_) async {});
      when(() => mockLocalDataSource.savePasswordHash(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.login(tUsername, tPassword);

      // Assert
      expect(result.isSuccess, true);
      expect(result.successOrNull?.id, tUserModel.id);
      verify(() => mockRemoteDataSource.login(tLoginRequest)).called(1);
      verify(() => mockLocalDataSource.saveToken(tToken)).called(1);
      verify(() => mockLocalDataSource.savePasswordHash(tPasswordHash)).called(1);
    });

    test('debe retornar UnauthorizedFailure al recibir error HTTP 401', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
        ),
      );
      when(() => mockRemoteDataSource.login(tLoginRequest)).thenThrow(dioException);

      // Act
      final result = await repository.login(tUsername, tPassword);

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
    });
  });

  group('login offline', () {
    test('debe autenticar contra credenciales locales si falla la red', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
        error: const SocketException('No internet'),
      );
      when(() => mockRemoteDataSource.login(tLoginRequest)).thenThrow(dioException);
      when(() => mockLocalDataSource.getUsername()).thenAnswer((_) async => tUsername);
      when(() => mockLocalDataSource.getPasswordHash()).thenAnswer((_) async => tPasswordHash);
      when(() => mockLocalDataSource.getUser()).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.login(tUsername, tPassword);

      // Assert
      expect(result.isSuccess, true);
      expect(result.successOrNull?.id, tUserModel.id);
      verify(() => mockLocalDataSource.getUsername()).called(1);
      verify(() => mockLocalDataSource.getPasswordHash()).called(1);
      verify(() => mockLocalDataSource.getUser()).called(1);
    });

    test('debe fallar offline si no coinciden hashes de contraseña', () async {
      // Arrange
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.connectionError,
        error: const SocketException('No internet'),
      );
      when(() => mockRemoteDataSource.login(tLoginRequest)).thenThrow(dioException);
      when(() => mockLocalDataSource.getUsername()).thenAnswer((_) async => tUsername);
      when(() => mockLocalDataSource.getPasswordHash()).thenAnswer((_) async => 'otro_hash');
      when(() => mockLocalDataSource.getUser()).thenAnswer((_) async => tUserModel);

      // Act
      final result = await repository.login(tUsername, tPassword);

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<UnauthorizedFailure>());
    });
  });
}
