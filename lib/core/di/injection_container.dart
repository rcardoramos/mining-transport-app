import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Registrar Logger (Sin dependencias)
  locator.registerLazySingleton<AppLogger>(() => AppLogger());

  // 2. Registrar Secure Storage (Cifrado de tokens y PIN)
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // 3. Registrar Base de Datos Local Drift (SQLite)
  final database = AppDatabase();
  locator.registerLazySingleton<AppDatabase>(() => database);

  // 4. Registrar Cliente HTTP (Dio) con inyección de dependencias
  locator.registerLazySingleton<DioClient>(() => DioClient(
        secureStorage: locator<SecureStorage>(),
        logger: locator<AppLogger>(),
      ));

  locator<AppLogger>().i('Dependency Injection Container initialized successfully.');
}
