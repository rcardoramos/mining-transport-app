import 'package:flutter/material.dart';
import 'package:mining_transport_app/core/utils/phone_layout.dart';
import 'package:mining_transport_app/features/auth/presentation/widgets/login_form.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Vista de Login scrolleable y adaptada a phones compactos.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topBgColor =
        isDark ? const Color(0xFF15181F) : DesignColors.primaryLight;
    final bottomBgColor = isDark ? DesignColors.backgroundDark : Colors.white;
    final heroH = PhoneLayout.heroHeight(context);
    final compact = PhoneLayout.isCompact(context);
    final gutter = PhoneLayout.horizontalGutter(context);

    return Scaffold(
      backgroundColor: topBgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: heroH,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: gutter,
                  vertical: compact ? 12 : 16,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: compact ? 52 : 70,
                      fit: BoxFit.contain,
                    ),
                    DesignSpacing.spacerV12,
                    Text(
                      'Sistema de Control de Embarque',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DesignTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: compact ? 16 : 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    DesignSpacing.spacerV8,
                    Text(
                      'ADRYAN Integrado',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DesignTypography.bodyMedium.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: compact ? 12 : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                padding: EdgeInsets.fromLTRB(
                  gutter + 4,
                  compact ? 24 : 32,
                  gutter + 4,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Iniciar Sesión',
                      style: DesignTypography.titleLarge.copyWith(
                        fontSize: compact ? 22 : 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : DesignColors.primaryLight,
                      ),
                    ),
                    DesignSpacing.spacerV4,
                    Text(
                      'Ingresa tu DNI y contraseña para acceder',
                      style: DesignTypography.bodyMedium.copyWith(
                        color: isDark
                            ? DesignColors.textSecondaryDark
                            : DesignColors.textSecondaryLight,
                      ),
                    ),
                    DesignSpacing.spacerV24,
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
                                  ? DesignColors.textSecondaryDark
                                      .withOpacity(0.4)
                                  : DesignColors.textSecondaryLight
                                      .withOpacity(0.4),
                              letterSpacing: 1.0,
                            ),
                          ),
                          DesignSpacing.spacerV8,
                          Image.asset(
                            'assets/images/adryan_logo.png',
                            height: 20,
                            fit: BoxFit.contain,
                            color: isDark
                                ? Colors.white.withOpacity(0.6)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
