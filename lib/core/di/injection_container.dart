import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/session_status_service.dart';
import 'package:mining_transport_app/core/audio/audio_service.dart';
import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/core/pdf/pdf_service.dart';
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
// ignore: unused_import
import 'package:mining_transport_app/features/home/data/datasources/home_dashboard_remote_data_source_impl.dart';
import 'package:mining_transport_app/features/home/data/repositories/home_dashboard_repository_impl.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_driver_info_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_today_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_pending_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/update_trip_status_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/register_passenger_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/get_passengers_on_board_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/check_collaborator_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/complete_stop_usecase.dart';

import 'package:mining_transport_app/features/geolocation/data/datasources/geolocation_remote_data_source.dart';
import 'package:mining_transport_app/features/geolocation/data/repositories/geolocation_repository_impl.dart';
import 'package:mining_transport_app/features/geolocation/domain/repositories/geolocation_repository.dart';
import 'package:mining_transport_app/features/geolocation/domain/usecases/validate_stop_geofencing_usecase.dart';
import 'package:mining_transport_app/features/geolocation/domain/usecases/resolve_nearest_stop_usecase.dart';
import 'package:mining_transport_app/features/occupancy/domain/usecases/validate_occupancy_usecase.dart';
import 'package:mining_transport_app/core/sync/sync_queue.dart';
import 'package:mining_transport_app/core/sync/sync_worker.dart';
import 'package:mining_transport_app/core/sync/sync_manager.dart';
// Trip Feature
import 'package:mining_transport_app/features/trip/data/datasources/trip_remote_data_source.dart';
import 'package:mining_transport_app/features/trip/data/datasources/mock_trip_remote_data_source.dart';

// Validation Feature
import 'package:mining_transport_app/features/validation/data/datasources/validation_local_data_source.dart';
import 'package:mining_transport_app/features/validation/domain/repositories/validation_repository.dart';
import 'package:mining_transport_app/features/validation/data/repositories/validation_repository_impl.dart';
import 'package:mining_transport_app/features/validation/domain/usecases/validate_labor_rules_usecase.dart';
// ignore: unused_import
import 'package:mining_transport_app/features/trip/data/datasources/trip_remote_data_source_impl.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // 1. Registrar Logger (Sin dependencias)
  locator.registerLazySingleton<AppLogger>(() => AppLogger());

  // 2. Registrar Secure Storage (Cifrado de tokens y PIN)
  locator.registerLazySingleton<SecureStorage>(() => SecureStorage());

  // 3. Registrar Base de Datos Local Drift (SQLite)
  final database = AppDatabase();
  locator.registerLazySingleton<AppDatabase>(() => database);

  // Sync Infrastructure
  locator.registerLazySingleton<SyncQueueManager>(() => SyncQueueManager());
  locator.registerLazySingleton<SyncWorker>(() => SyncWorker());
  
  final syncManager = SyncManager();
  syncManager.initialize();
  locator.registerLazySingleton<SyncManager>(() => syncManager);

  // 4. Registrar Servicio de Estado de Sesión (para expiraciones globales)
  locator.registerLazySingleton<SessionStatusService>(
    () => SessionStatusService(),
  );

  // 5. Registrar Servicio de GPS / Geolocalización
  locator.registerLazySingleton<GpsService>(() => GpsService());

  // Registrar Servicio de Alertas de Audio
  locator.registerLazySingleton<AudioService>(
    () => AudioServiceImpl(locator<AppLogger>()),
  );

  // Registrar Servicio de Generación de PDF
  locator.registerLazySingleton<PdfService>(() => PdfService());

  // 6. Registrar Cliente HTTP (Dio) con inyección de dependencias
  locator.registerLazySingleton<DioClient>(
    () => DioClient(
      secureStorage: locator<SecureStorage>(),
      logger: locator<AppLogger>(),
    ),
  );

  // 7. DataSources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator<DioClient>()),
  );
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      locator<SecureStorage>(),
      locator<AppDatabase>(),
    ),
  );
  // Determinar si usamos mocks o APIs reales según el entorno
  final isDev = EnvConfig.instance.environment == AppEnvironment.dev;

  if (isDev) {
    locator.registerLazySingleton<HomeDashboardRemoteDataSource>(
      () => MockHomeDashboardRemoteDataSource(),
    );
  } else {
    locator.registerLazySingleton<HomeDashboardRemoteDataSource>(
      () => HomeDashboardRemoteDataSourceImpl(locator<DioClient>(), locator<SecureStorage>()),
    );
  }

  // 8. Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator<AuthRemoteDataSource>(),
      localDataSource: locator<AuthLocalDataSource>(),
    ),
  );
  locator.registerLazySingleton<HomeDashboardRepository>(
    () => HomeDashboardRepositoryImpl(locator<HomeDashboardRemoteDataSource>()),
  );

  // 9. UseCases
  locator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<CheckSessionUseCase>(
    () => CheckSessionUseCase(locator<AuthRepository>()),
  );

  locator.registerLazySingleton<GetDriverInfoUseCase>(
    () => GetDriverInfoUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<GetTodayTripsUseCase>(
    () => GetTodayTripsUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<GetPendingTripsUseCase>(
    () => GetPendingTripsUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<GetDashboardSummaryUseCase>(
    () => GetDashboardSummaryUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<UpdateTripStatusUseCase>(
    () => UpdateTripStatusUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<RegisterPassengerUseCase>(
    () => RegisterPassengerUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<GetPassengersOnBoardUseCase>(
    () => GetPassengersOnBoardUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<CheckCollaboratorUseCase>(
    () => CheckCollaboratorUseCase(locator<HomeDashboardRepository>()),
  );
  locator.registerLazySingleton<CompleteStopUseCase>(
    () => CompleteStopUseCase(locator<HomeDashboardRepository>()),
  );

  // Geolocation UseCases
  locator.registerLazySingleton<ValidateStopGeofencingUseCase>(
    () => ValidateStopGeofencingUseCase(locator<GpsService>()),
  );
  locator.registerLazySingleton<ResolveNearestStopUseCase>(
    () => ResolveNearestStopUseCase(locator<GeolocationRepository>()),
  );

  // Occupancy UseCases
  locator.registerLazySingleton<ValidateOccupancyUseCase>(
    () => ValidateOccupancyUseCase(),
  );

  // Geolocation DataSources
  if (isDev) {
    locator.registerLazySingleton<GeolocationRemoteDataSource>(
      () => MockGeolocationRemoteDataSource(),
    );
  } else {
    locator.registerLazySingleton<GeolocationRemoteDataSource>(
      () => GeolocationRemoteDataSourceImpl(locator<DioClient>(), locator<SecureStorage>()),
    );
  }

  // Geolocation Repositories
  locator.registerLazySingleton<GeolocationRepository>(
    () => GeolocationRepositoryImpl(locator<GeolocationRemoteDataSource>()),
  );

  // ── Trip Feature ──────────────────────────────────────────────────────────
  if (isDev) {
    locator.registerLazySingleton<TripRemoteDataSource>(
      () => MockTripRemoteDataSource(),
    );
  } else {
    locator.registerLazySingleton<TripRemoteDataSource>(
      () => TripRemoteDataSourceImpl(locator<DioClient>(), locator<SecureStorage>()),
    );
  }

  // ── Validation Feature ───────────────────────────────────────────────────
  locator.registerLazySingleton<ValidationLocalDataSource>(
    () => ValidationLocalDataSourceImpl(locator<AppDatabase>()),
  );
  locator.registerLazySingleton<ValidationRepository>(
    () => ValidationRepositoryImpl(
      locator<ValidationLocalDataSource>(),
      locator<HomeDashboardRepository>(),
    ),
  );
  locator.registerLazySingleton<ValidateLaborRulesUseCase>(
    () => ValidateLaborRulesUseCase(locator<ValidationRepository>()),
  );

  locator<AppLogger>().i(
    'Dependency Injection Container initialized successfully.',
  );
}
