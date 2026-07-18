import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/di/injection_container.dart';
import 'package:mining_transport_app/core/router/app_router.dart';
import 'package:mining_transport_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Determinar entorno de ejecución a partir de --dart-define=ENV=xxx
  const envString = String.fromEnvironment('ENV', defaultValue: 'dev');
  AppEnvironment environment;
  switch (envString.toLowerCase()) {
    case 'prod':
    case 'production':
      environment = AppEnvironment.prod;
      break;
    case 'staging':
      environment = AppEnvironment.staging;
      break;
    case 'dev':
    default:
      environment = AppEnvironment.dev;
      break;
  }

  debugPrint('Iniciando aplicación en modo: ${environment.name.toUpperCase()}');

  // Inicializar la configuración de entorno
  EnvConfig.initialize(environment);

  // Inicializar localizador de dependencias (GetIt)
  await setupLocator();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Miski Mayo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Sigue el tema del sistema operativo
      routerConfig: router,
    );
  }
}
