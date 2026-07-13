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
    final size = MediaQuery.of(context).size;

    // Colores corporativos basados en el tema
    final topBgColor = isDark ? const Color(0xFF15181F) : DesignColors.primaryLight;
    final bottomBgColor = isDark ? DesignColors.backgroundDark : Colors.white;
    final brandColor = isDark ? DesignColors.secondaryDark : DesignColors.secondaryLight;

    return Scaffold(
      backgroundColor: topBgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── CABECERA ORGÁNICA (Sección Superior) ────────────────────────
            Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              alignment: Alignment.bottomLeft,
              child: SafeArea(
                bottom: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Mensaje de Bienvenida a la izquierda
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '¡Hola!',
                            style: DesignTypography.display.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 38,
                            ),
                          ),
                          DesignSpacing.spacerV4,
                          Text(
                            'Bienvenido a Buses Miski Mayo',
                            style: DesignTypography.bodyLarge.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          DesignSpacing.spacerV8,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: brandColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: brandColor.withOpacity(0.5), width: 1),
                            ),
                            child: Text(
                              'Transporte Seguro',
                              style: DesignTypography.caption.copyWith(
                                color: brandColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Elemento gráfico (Logo de Miski Mayo)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.15), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // ── CARD INFERIOR REDONDEADA (Formulario de Login) ──────────────
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: size.height - 250,
              ),
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
                  DesignSpacing.spacerV32,
                  Center(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
