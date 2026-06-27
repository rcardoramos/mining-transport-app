import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isLoading,
    String? errorMessage,
    UserEntity? user,
    @Default(false) bool isAuthenticated,
    @Default(false) bool isSessionChecked,
  }) = _LoginState;
}
