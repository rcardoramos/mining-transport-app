import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/core/di/injection_container.dart';
import 'package:mining_transport_app/core/utils/session_status_service.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mining_transport_app/features/auth/presentation/states/login_state.dart';

/// ViewModel para la pantalla de inicio de sesión gestionado con Riverpod [StateNotifier].
class LoginViewModel extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CheckSessionUseCase _checkSessionUseCase;

  LoginViewModel({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CheckSessionUseCase checkSessionUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _checkSessionUseCase = checkSessionUseCase,
        super(const LoginState()) {
    checkSession();
    // Escuchar notificaciones de expiración de sesión desde el cliente HTTP
    if (locator.isRegistered<SessionStatusService>()) {
      locator<SessionStatusService>().sessionExpiredStream.listen((_) {
        state = const LoginState(
          isAuthenticated: false,
          isSessionChecked: true,
        );
      });
    }
  }

  /// Realiza el login de usuario disparando estados de carga y error en la UI.
  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _loginUseCase(username, password);

    result.fold(
      onSuccess: (user) {
        state = state.copyWith(
          isLoading: false,
          user: user,
          isAuthenticated: true,
          isSessionChecked: true,
          errorMessage: null,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isAuthenticated: false,
          isSessionChecked: true,
        );
      },
    );
  }

  /// Cierra la sesión activa limpiando el estado.
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    final result = await _logoutUseCase();
    result.fold(
      onSuccess: (_) {
        state = const LoginState(isSessionChecked: true);
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
    );
  }

  /// Verifica de forma asíncrona la validez de la sesión local.
  Future<void> checkSession() async {
    final result = await _checkSessionUseCase();
    await result.fold(
      onSuccess: (hasSession) async {
        if (hasSession) {
          final userResult = await _getCurrentUserUseCase();
          userResult.fold(
            onSuccess: (user) {
              state = state.copyWith(
                isAuthenticated: user != null,
                user: user,
                isSessionChecked: true,
              );
            },
            onFailure: (_) {
              state = state.copyWith(
                isAuthenticated: false,
                isSessionChecked: true,
              );
            },
          );
        } else {
          state = state.copyWith(
            isAuthenticated: false,
            isSessionChecked: true,
          );
        }
      },
      onFailure: (_) {
        state = state.copyWith(
          isAuthenticated: false,
          isSessionChecked: true,
        );
      },
    );
  }
}

/// Proveedor global para el ViewModel de autenticación.
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(
    loginUseCase: locator<LoginUseCase>(),
    logoutUseCase: locator<LogoutUseCase>(),
    getCurrentUserUseCase: locator<GetCurrentUserUseCase>(),
    checkSessionUseCase: locator<CheckSessionUseCase>(),
  );
});
