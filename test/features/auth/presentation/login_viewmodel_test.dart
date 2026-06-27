import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckSessionUseCase mockCheckSessionUseCase;
  late LoginViewModel viewModel;

  const tUsername = 'dispatcher_01';
  const tPassword = 'SecurePassword123';
  const tUser = UserEntity(
    id: 'a6b1c8d2-4321-9876-bcde-5f4e3d2c1b0a',
    username: tUsername,
    fullName: 'Ricardo Ramos Julca',
    role: 'DISPATCHER',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckSessionUseCase = MockCheckSessionUseCase();
    
    // Configurar retornos por defecto para el constructor (que llama a checkSession)
    when(() => mockCheckSessionUseCase()).thenAnswer((_) async => const Success(false));

    viewModel = LoginViewModel(
      loginUseCase: mockLoginUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkSessionUseCase: mockCheckSessionUseCase,
    );
  });

  group('checkSession', () {
    test('debe cambiar estado a autenticado si checkSession y getCurrentUser retornan exito', () async {
      // Arrange
      when(() => mockCheckSessionUseCase()).thenAnswer((_) async => const Success(true));
      when(() => mockGetCurrentUserUseCase()).thenAnswer((_) async => const Success(tUser));

      // Act
      await viewModel.checkSession();

      // Assert
      expect(viewModel.state.isAuthenticated, true);
      expect(viewModel.state.user, tUser);
    });
  });

  group('login', () {
    test('debe emitir isLoading=true y luego éxito al iniciar sesión correctamente', () async {
      // Arrange
      when(() => mockLoginUseCase(tUsername, tPassword))
          .thenAnswer((_) async => const Success(tUser));

      // Act & Assert
      final states = <dynamic>[];
      viewModel.addListener((state) {
        states.add(state.isLoading);
      });

      await viewModel.login(tUsername, tPassword);

      expect(viewModel.state.isAuthenticated, true);
      expect(viewModel.state.user, tUser);
      expect(viewModel.state.errorMessage, null);
      expect(states.contains(true), true); // Verificamos que pasó por el estado de carga
    });

    test('debe emitir error de autenticación si falla el caso de uso', () async {
      // Arrange
      const tFailure = UnauthorizedFailure('Credenciales incorrectas');
      when(() => mockLoginUseCase(tUsername, tPassword))
          .thenAnswer((_) async => const FailureResult(tFailure));

      // Act
      await viewModel.login(tUsername, tPassword);

      // Assert
      expect(viewModel.state.isAuthenticated, false);
      expect(viewModel.state.user, null);
      expect(viewModel.state.errorMessage, tFailure.message);
    });
  });

  group('logout', () {
    test('debe limpiar el estado al cerrar sesión exitosamente', () async {
      // Arrange
      when(() => mockLogoutUseCase()).thenAnswer((_) async => const Success(null));

      // Act
      await viewModel.logout();

      // Assert
      expect(viewModel.state.isAuthenticated, false);
      expect(viewModel.state.user, null);
    });
  });
}
