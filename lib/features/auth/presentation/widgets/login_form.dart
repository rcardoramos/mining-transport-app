import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DesignTextField(
            labelText: 'Usuario',
            hintText: 'Ingresa tu usuario de red',
            controller: _usernameController,
            enabled: !state.isLoading,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El usuario es requerido';
              }
              return null;
            },
          ),
          DesignSpacing.spacerV16,
          DesignPasswordField(
            labelText: 'Contraseña',
            hintText: 'Ingresa tu contraseña',
            controller: _passwordController,
            enabled: !state.isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es requerida';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          if (state.errorMessage != null) ...[
            DesignSpacing.spacerV16,
            DesignCard.status(
              statusColor: isDark ? DesignColors.dangerDark : DesignColors.dangerLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: isDark ? DesignColors.dangerDark : DesignColors.dangerLight,
                    size: 20,
                  ),
                  DesignSpacing.spacerH12,
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: DesignTypography.bodyMedium.copyWith(
                        color: isDark ? DesignColors.dangerDark : DesignColors.dangerLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          DesignSpacing.spacerV24,
          DesignButton.primary(
            text: 'Iniciar Sesión',
            onTap: _submit,
            isLoading: state.isLoading,
          ),
        ],
      ),
    );
  }
}
