import 'package:flutter/material.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/login_form.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Vista de Login que orquesta la UI del formulario de autenticación de forma elegante.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: DesignSpacing.allL,
            child: FadeInAnimation(
              duration: const Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: DesignSpacing.allM,
                    decoration: BoxDecoration(
                      color: isDark
                          ? DesignColors.primaryDark.withOpacity(0.1)
                          : DesignColors.primaryLight.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_bus_filled_rounded,
                      size: 80,
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                    ),
                  ),
                  DesignSpacing.spacerV20,
                  Text(
                    'Miski Mayo',
                    style: DesignTypography.display.copyWith(
                      color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  DesignSpacing.spacerV8,
                  Text(
                    'Control de Transporte de Buses',
                    style: DesignTypography.bodyLarge.copyWith(
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  DesignSpacing.spacerV32,
                  DesignCard.elevated(
                    padding: DesignSpacing.allL,
                    child: const LoginForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
