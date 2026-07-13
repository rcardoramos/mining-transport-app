import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Pantalla de Splash que verifica el estado del inicio de sesión al inicio de la app.
class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginViewModelProvider.notifier).checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF11141A) : Colors.white,
      body: Stack(
        children: [
          // Branding del Cliente en el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                DesignSpacing.spacerV32,
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? DesignColors.secondaryDark : DesignColors.secondaryLight,
                  ),
                  strokeWidth: 3.5,
                ),
              ],
            ),
          ),
          
          // Branding del Desarrollador en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Desarrollado por',
                    style: DesignTypography.caption.copyWith(
                      color: isDark
                          ? DesignColors.textSecondaryDark.withOpacity(0.4)
                          : DesignColors.textSecondaryLight.withOpacity(0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  DesignSpacing.spacerV8,
                  Image.asset(
                    'assets/images/adryan_logo.png',
                    height: 24,
                    fit: BoxFit.contain,
                    color: isDark ? Colors.white.withOpacity(0.7) : null,
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
