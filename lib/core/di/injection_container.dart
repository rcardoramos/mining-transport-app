import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/session_status_service.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mining_transport_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mining_transport_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mining_transport_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mining_transport_app/features/home/data/datasources/home_dashboard_remote_data_source.dart';
import 'package:mining_transport_app/features/home/data/datasources/mock_home_dashboard_remote_data_source.dart';
import 'package:mining_transport_app/features/home/data/repositories/home_dashboard_repository_impl.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_driver_info_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_today_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_pending_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/update_trip_status_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/register_passenger_usecase.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Registrar Logger (Sin dependencias)
  locator.registerLazySingleton<AppLogger>(() => AppLogger());

  // 2. Registrar Secure Storage (Cifrado de tokens y PIN)
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // 3. Registrar Base de Datos Local Drift (SQLite)
  final database = AppDatabase();
  locator.registerLazySingleton<AppDatabase>(() => database);

  // 4. Registrar Servicio de Estado de Sesión (para expiraciones globales)
  locator.registerLazySingleton<SessionStatusService>(() => SessionStatusService());

  // 5. Registrar Cliente HTTP (Dio) con inyección de dependencias
  locator.registerLazySingleton<DioClient>(() => DioClient(
        secureStorage: locator<SecureStorage>(),
        logger: locator<AppLogger>(),
      ));

  // 6. DataSources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<DioClient>()),
  );
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(locator<SecureStorage>(), locator<AppDatabase>()),
  );
  locator.registerLazySingleton<HomeDashboardRemoteDataSource>(
    () => MockHomeDashboardRemoteDataSource(),
  );

  // 7. Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<HomeDashboardRepository>(
    () => HomeDashboardRepositoryImpl(locator<HomeDashboardRemoteDataSource>()),
  );

  // 8. UseCases
  locator.registerLazySingleton<LoginUseCase>(() => LoginUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton<GetCurrentUserUseCase>(() => GetCurrentUserUseCase(locator<AuthRepository>()));
  locator.registerLazySingleton<CheckSessionUseCase>(() => CheckSessionUseCase(locator<AuthRepository>()));

  locator.registerLazySingleton<GetDriverInfoUseCase>(() => GetDriverInfoUseCase(locator<HomeDashboardRepository>()));
  locator.registerLazySingleton<GetTodayTripsUseCase>(() => GetTodayTripsUseCase(locator<HomeDashboardRepository>()));
  locator.registerLazySingleton<GetPendingTripsUseCase>(() => GetPendingTripsUseCase(locator<HomeDashboardRepository>()));
  locator.registerLazySingleton<GetDashboardSummaryUseCase>(() => GetDashboardSummaryUseCase(locator<HomeDashboardRepository>()));
  locator.registerLazySingleton<UpdateTripStatusUseCase>(() => UpdateTripStatusUseCase(locator<HomeDashboardRepository>()));
  locator.registerLazySingleton<RegisterPassengerUseCase>(() => RegisterPassengerUseCase(locator<HomeDashboardRepository>()));

  locator<AppLogger>().i('Dependency Injection Container initialized successfully.');
}
