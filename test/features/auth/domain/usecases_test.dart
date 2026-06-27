import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/logout_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;
  late LogoutUseCase logoutUseCase;
  late CheckSessionUseCase checkSessionUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
    logoutUseCase = LogoutUseCase(mockRepository);
    checkSessionUseCase = CheckSessionUseCase(mockRepository);
  });

  const tUsername = 'test_user';
  const tPassword = 'password123';
  const tUser = UserEntity(
    id: '1',
    username: tUsername,
    fullName: 'Test User',
    role: 'DISPATCHER',
    token: 'jwt_token',
  );

  group('LoginUseCase', () {
    test('debe retornar UserEntity cuando el repositorio retorna Success', () async {
      // Arrange
      when(() => mockRepository.login(tUsername, tPassword))
          .thenAnswer((_) async => const Success(tUser));

      // Act
      final result = await loginUseCase(tUsername, tPassword);

      // Assert
      expect(result.isSuccess, true);
      expect(result.successOrNull, tUser);
      verify(() => mockRepository.login(tUsername, tPassword)).called(1);
    });

    test('debe retornar Failure cuando el repositorio retorna FailureResult', () async {
      // Arrange
      const tFailure = UnauthorizedFailure('Credenciales incorrectas');
      when(() => mockRepository.login(tUsername, tPassword))
          .thenAnswer((_) async => const FailureResult(tFailure));

      // Act
      final result = await loginUseCase(tUsername, tPassword);

      // Assert
      expect(result.isFailure, true);
      expect(result.failureOrNull, tFailure);
      verify(() => mockRepository.login(tUsername, tPassword)).called(1);
    });
  });

  group('LogoutUseCase', () {
    test('debe llamar a logout en el repositorio y retornar Success', () async {
      // Arrange
      when(() => mockRepository.logout())
          .thenAnswer((_) async => const Success(null));

      // Act
      final result = await logoutUseCase();

      // Assert
      expect(result.isSuccess, true);
      verify(() => mockRepository.logout()).called(1);
    });
  });

  group('CheckSessionUseCase', () {
    test('debe retornar true si el repositorio indica una sesión activa', () async {
      // Arrange
      when(() => mockRepository.checkSession())
          .thenAnswer((_) async => const Success(true));

      // Act
      final result = await checkSessionUseCase();

      // Assert
      expect(result.isSuccess, true);
      expect(result.successOrNull, true);
      verify(() => mockRepository.checkSession()).called(1);
    });
  });
}
