import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mining_transport_app/features/auth/presentation/pages/login_view.dart';
import 'package:mining_transport_app/features/auth/presentation/pages/splash_view.dart';
import 'package:mining_transport_app/features/auth/presentation/pages/design_system_preview.dart';
import 'package:mining_transport_app/features/auth/presentation/viewmodels/login_viewmodel.dart';

/// Proveedor que expone la instancia de [GoRouter] con lógica de redirección reactiva.
final routerProvider = Provider<GoRouter>((ref) {
  // Escuchar el notifier para obtener el stream, el notifier en sí no cambia
  final notifier = ref.watch(loginViewModelProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(notifier.stream),
    redirect: (context, state) {
      // Permitir acceso irrestricto al catálogo del Design System en desarrollo
      final isDesignSystem = state.matchedLocation == '/design-system-preview';
      if (isDesignSystem) return null;

      // Leer el estado actual de forma de datos sin provocar la reconstrucción de GoRouter
      final authState = ref.read(loginViewModelProvider);
      
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/';

      // 1. Si aún no se ha comprobado la sesión, forzar la permanencia en el Splash
      if (!authState.isSessionChecked) {
        return isSplash ? null : '/';
      }

      // 2. Una vez comprobada la sesión, si no está autenticado, redirigir a Login
      if (!authState.isAuthenticated) {
        return isLoggingIn ? null : '/login';
      }

      // 3. Si está autenticado, evitar las pantallas de Login o Splash redirigiendo al Dashboard
      if (isLoggingIn || isSplash) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardView(),
      ),
      GoRoute(
        path: '/design-system-preview',
        builder: (context, state) => const DesignSystemPreview(),
      ),
    ],
  );
});

/// Adaptador para convertir un [Stream] en un [Listenable] compatible con GoRouter.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Stub temporal para compilación limpia de la siguiente feature
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(child: Text('Dashboard View Placeholder')),
    );
  }
}

