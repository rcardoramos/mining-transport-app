import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/error_message.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/login_button.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/password_field.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/username_field.dart';

/// Formulario principal de inicio de sesión que gestiona la validación y el submit.
class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref.read(loginViewModelProvider.notifier).login(
            _usernameController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UsernameField(
            controller: _usernameController,
            enabled: !state.isLoading,
          ),
          const SizedBox(height: 16),
          PasswordField(
            controller: _passwordController,
            enabled: !state.isLoading,
            onFieldSubmitted: _submit,
          ),
          const SizedBox(height: 24),
          ErrorMessage(message: state.errorMessage),
          if (state.errorMessage != null) const SizedBox(height: 16),
          LoginButton(
            onPressed: _submit,
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }
}
