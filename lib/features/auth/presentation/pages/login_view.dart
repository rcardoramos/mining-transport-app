import 'package:flutter/material.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/login_form.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Vista de Login con diseño corporativo premium y cabecera orgánica estilizada.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores corporativos basados en el tema
    final topBgColor = isDark ? const Color(0xFF15181F) : DesignColors.primaryLight;
    final bottomBgColor = isDark ? DesignColors.backgroundDark : Colors.white;

    return Scaffold(
      backgroundColor: topBgColor,
      body: CustomScrollView(
        slivers: [
          // ── CABECERA ORGÁNICA (Sección Superior) ────────────────────────
          SliverToBoxAdapter(
            child: Container(
              height: 280,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    DesignSpacing.spacerV16,
                    Text(
                      'Sistema de Control de Embarque',
                      textAlign: TextAlign.center,
                      style: DesignTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DesignSpacing.spacerV8,
                    Text(
                      'ADRYAN Integrado',
                      textAlign: TextAlign.center,
                      style: DesignTypography.bodyMedium.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // ── CARD INFERIOR REDONDEADA (Formulario de Login) ──────────────
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bottomBgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Iniciar Sesión',
                    style: DesignTypography.titleLarge.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : DesignColors.primaryLight,
                    ),
                  ),
                  DesignSpacing.spacerV4,
                  Text(
                    'Por favor ingresa tus datos para acceder',
                    style: DesignTypography.bodyMedium.copyWith(
                      color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                    ),
                  ),
                  DesignSpacing.spacerV32,
                  const LoginForm(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Desarrollado por',
                            style: DesignTypography.caption.copyWith(
                              color: isDark
                                  ? DesignColors.textSecondaryDark.withOpacity(0.4)
                                  : DesignColors.textSecondaryLight.withOpacity(0.4),
                              letterSpacing: 1.0,
                            ),
                          ),
                          DesignSpacing.spacerV8,
                          Image.asset(
                            'assets/images/adryan_logo.png',
                            height: 20,
                            fit: BoxFit.contain,
                            color: isDark ? Colors.white.withOpacity(0.6) : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
