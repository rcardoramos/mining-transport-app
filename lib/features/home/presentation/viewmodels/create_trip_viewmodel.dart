import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/time/clock.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/catalog/domain/usecases/get_catalogs_usecase.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/presentation/viewmodels/home_dashboard_viewmodel.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'package:mining_transport_app/features/trip/data/datasources/trip_remote_data_source.dart';
import 'package:mining_transport_app/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart';
import 'package:mining_transport_app/features/trip/domain/resolvers/env_aware_chofer_id_resolver.dart';
import 'package:mining_transport_app/features/trip/domain/usecases/create_trip_usecase.dart';

enum CreateTripPhase {
  initial,
  loadingCatalogs,
  ready,
  creating,
  success,
  validationError,
  error,
  offline,
}

class CreateTripState {
  const CreateTripState({
    this.phase = CreateTripPhase.initial,
    this.catalogs,
    this.user,
    this.selectedRouteId,
    this.selectedServiceId,
    this.selectedScheduleId,
    this.selectedBusId,
    this.selectedStopId,
    this.errorMessage,
    this.createdTrip,
    this.isDirty = false,
  });

  final CreateTripPhase phase;
  final CatalogBundle? catalogs;
  final UserEntity? user;
  final int? selectedRouteId;
  final int? selectedServiceId;
  final int? selectedScheduleId;
  final int? selectedBusId;
  final int? selectedStopId;
  final String? errorMessage;
  final CreatedTripResult? createdTrip;
  final bool isDirty;

  /// Etiqueta visible del chofer de sesión (solo lectura).
  String get driverDisplayLabel {
    final u = user;
    if (u == null) return 'Sesión no disponible';

    final name = u.fullName.trim();
    final username = u.username.trim();
    final code = u.driverId?.trim();

    final primary = name.isNotEmpty
        ? name
        : (username.isNotEmpty ? username : 'Chofer');

    final parts = <String>[primary];
    if (username.isNotEmpty && username.toLowerCase() != primary.toLowerCase()) {
      parts.add(username);
    }
    if (code != null && code.isNotEmpty) {
      parts.add('Cod. $code');
    }
    return parts.join(' · ');
  }

  DateTime get serviceDate {
    final now = GetIt.I<Clock>().now().toUtc().subtract(const Duration(hours: 5));
    return DateTime(now.year, now.month, now.day);
  }

  CatalogBus? get selectedBus {
    final id = selectedBusId;
    if (id == null || catalogs == null) return null;
    return catalogs!.buses.where((b) => b.id == id).firstOrNull;
  }

  /// Arma un [TripEntity] local para mostrar en Home si Historial aún no lo lista.
  TripEntity? buildLocalTripPreview() {
    final created = createdTrip;
    final catalogs = this.catalogs;
    final routeId = selectedRouteId;
    final scheduleId = selectedScheduleId;
    final bus = selectedBus;
    if (created == null ||
        catalogs == null ||
        routeId == null ||
        scheduleId == null ||
        bus == null) {
      return null;
    }

    final route = catalogs.routes.where((r) => r.id == routeId).firstOrNull;
    final schedule =
        catalogs.schedules.where((s) => s.id == scheduleId).firstOrNull;
    if (route == null || schedule == null) return null;

    final rawEstado = (created.estado ?? 'P').trim().toUpperCase();
    final status = rawEstado == 'A' || rawEstado == 'IN_PROGRESS'
        ? TripStatus.inProgress
        : TripStatus.scheduled;

    return TripEntity(
      id: created.viajeId,
      route: route.name,
      scheduledTime: schedule.scheduledDateTimeOn(serviceDate),
      shift: schedule.displayLabel,
      unitCode: bus.plate,
      capacity: bus.capacity,
      passengerCount: 0,
      status: status,
    );
  }

  /// Paraderos del catálogo vinculados a la ruta (si Bootstrap trae rutaId).
  List<CatalogStop> get linkedStopsForRoute {
    final routeId = selectedRouteId;
    final all = catalogs?.stops ?? const <CatalogStop>[];
    if (routeId == null) return const [];
    return all.where((s) => s.routeId != null && s.routeId == routeId).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Staging actual: Paraderos sin rutaId → hay que elegir manualmente.
  bool get requiresManualStopSelection {
    if (catalogs == null || selectedRouteId == null) return false;
    return linkedStopsForRoute.isEmpty && catalogs!.stops.isNotEmpty;
  }

  List<CatalogStop> get availableStops {
    final all = catalogs?.stops ?? const <CatalogStop>[];
    return List<CatalogStop>.from(all)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  bool get isFormValid {
    final bus = selectedBus;
    final stopOk = !requiresManualStopSelection || selectedStopId != null;
    return selectedRouteId != null &&
        selectedServiceId != null &&
        selectedScheduleId != null &&
        bus != null &&
        bus.capacity > 0 &&
        user != null &&
        stopOk &&
        phase != CreateTripPhase.creating &&
        phase != CreateTripPhase.loadingCatalogs;
  }

  CreateTripState copyWith({
    CreateTripPhase? phase,
    CatalogBundle? catalogs,
    UserEntity? user,
    int? selectedRouteId,
    int? selectedServiceId,
    int? selectedScheduleId,
    int? selectedBusId,
    int? selectedStopId,
    String? errorMessage,
    CreatedTripResult? createdTrip,
    bool? isDirty,
    bool clearError = false,
    bool clearRoute = false,
    bool clearService = false,
    bool clearSchedule = false,
    bool clearBus = false,
    bool clearStop = false,
  }) {
    return CreateTripState(
      phase: phase ?? this.phase,
      catalogs: catalogs ?? this.catalogs,
      user: user ?? this.user,
      selectedRouteId: clearRoute ? null : (selectedRouteId ?? this.selectedRouteId),
      selectedServiceId:
          clearService ? null : (selectedServiceId ?? this.selectedServiceId),
      selectedScheduleId:
          clearSchedule ? null : (selectedScheduleId ?? this.selectedScheduleId),
      selectedBusId: clearBus ? null : (selectedBusId ?? this.selectedBusId),
      selectedStopId: clearStop ? null : (selectedStopId ?? this.selectedStopId),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdTrip: createdTrip ?? this.createdTrip,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

class CreateTripViewModel extends StateNotifier<CreateTripState> {
  CreateTripViewModel({
    required GetCatalogsUseCase getCatalogsUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required CreateTripUseCase createTripUseCase,
    required Ref ref,
  })  : _getCatalogsUseCase = getCatalogsUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _createTripUseCase = createTripUseCase,
        _ref = ref,
        super(const CreateTripState());

  final GetCatalogsUseCase _getCatalogsUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final CreateTripUseCase _createTripUseCase;
  final Ref _ref;

  Future<void> load() async {
    if (!_ref.read(syncProvider).isOnline) {
      state = state.copyWith(
        phase: CreateTripPhase.offline,
        errorMessage: 'Necesitas conexión para crear un nuevo viaje.',
      );
    }

    state = state.copyWith(
      phase: CreateTripPhase.loadingCatalogs,
      clearError: true,
    );

    // Cache-first + paralelo: no bloquear el formulario con Bootstrap de red.
    final userFuture = _getCurrentUserUseCase();
    final catalogsFuture = _getCatalogsUseCase.execute(forceRefresh: false);
    final userResult = await userFuture;
    final catalogsResult = await catalogsFuture;
    final user = await _resolveSessionUser(userResult.successOrNull);

    if (catalogsResult.isFailure) {
      state = state.copyWith(
        phase: CreateTripPhase.error,
        errorMessage: catalogsResult.failureOrNull?.message ??
            'No se pudieron cargar los catálogos.',
        user: user,
      );
      return;
    }

    if (!_ref.read(syncProvider).isOnline) {
      state = state.copyWith(
        phase: CreateTripPhase.offline,
        catalogs: catalogsResult.successOrNull,
        user: user,
        errorMessage: 'Necesitas conexión para crear un nuevo viaje.',
      );
      return;
    }

    state = state.copyWith(
      phase: CreateTripPhase.ready,
      catalogs: catalogsResult.successOrNull,
      user: user,
      clearError: true,
    );

    // Refresco silencioso en segundo plano (no cierra el formulario).
    unawaited(_refreshCatalogsInBackground());
  }

  Future<void> _refreshCatalogsInBackground() async {
    if (!_ref.read(syncProvider).isOnline) return;
    final refreshed = await _getCatalogsUseCase.execute(forceRefresh: true);
    if (refreshed.isFailure) return;
    if (state.phase != CreateTripPhase.ready &&
        state.phase != CreateTripPhase.validationError) {
      return;
    }
    state = state.copyWith(
      catalogs: refreshed.successOrNull,
      clearError: true,
    );
  }

  /// Preferir usuario de sesión; hidratar nombre/driverId desde SecureStorage.
  Future<UserEntity?> _resolveSessionUser(UserEntity? fromAuth) async {
    final storage = GetIt.I<SecureStorage>();
    final stored = await Future.wait([
      storage.getDriverId(),
      storage.getFullName(),
      storage.getUsername(),
    ]);
    final storedDriverId = stored[0];
    final storedFullName = stored[1];
    final storedUsername = stored[2];

    if (fromAuth != null) {
      final fullName = fromAuth.fullName.trim().isNotEmpty
          ? fromAuth.fullName.trim()
          : (storedFullName?.trim().isNotEmpty == true
              ? storedFullName!.trim()
              : fromAuth.username.trim());
      final driverId = (fromAuth.driverId?.trim().isNotEmpty == true)
          ? fromAuth.driverId!.trim()
          : storedDriverId?.trim();
      return fromAuth.copyWith(
        fullName: fullName.isNotEmpty ? fullName : fromAuth.username,
        driverId: driverId,
      );
    }

    final dashDriver = _ref.read(homeDashboardViewModelProvider).data?.driver;
    final username = dashDriver?.name.trim().isNotEmpty == true
        ? dashDriver!.name.trim()
        : (storedUsername?.trim() ?? '');

    if (username.isEmpty &&
        (storedDriverId == null || storedDriverId.isEmpty)) {
      return null;
    }

    final fullName = storedFullName?.trim().isNotEmpty == true
        ? storedFullName!.trim()
        : (dashDriver?.name.trim().isNotEmpty == true
            ? dashDriver!.name.trim()
            : username);

    return UserEntity(
      id: dashDriver?.id ?? storedUsername ?? 'session',
      username: username.isNotEmpty ? username : 'chofer',
      fullName: fullName.isNotEmpty ? fullName : 'Chofer',
      role: 'DRIVER',
      driverId: storedDriverId,
    );
  }
  void selectRoute(int? id) {
    state = state.copyWith(
      selectedRouteId: id,
      clearStop: true,
      isDirty: true,
      clearError: true,
    );
  }

  void selectService(int? id) {
    state = state.copyWith(selectedServiceId: id, isDirty: true, clearError: true);
  }

  void selectSchedule(int? id) {
    state = state.copyWith(
      selectedScheduleId: id,
      isDirty: true,
      clearError: true,
    );
  }

  void selectBus(int? id) {
    state = state.copyWith(selectedBusId: id, isDirty: true, clearError: true);
  }

  void selectStop(int? id) {
    state = state.copyWith(selectedStopId: id, isDirty: true, clearError: true);
  }

  Future<bool> submit() async {
    if (state.phase == CreateTripPhase.creating) return false;
    if (!state.isFormValid) {
      state = state.copyWith(
        phase: CreateTripPhase.validationError,
        errorMessage: state.requiresManualStopSelection && state.selectedStopId == null
            ? 'Seleccione un paradero para continuar.'
            : 'Complete todos los campos obligatorios.',
      );
      return false;
    }
    if (!_ref.read(syncProvider).isOnline) {
      state = state.copyWith(
        phase: CreateTripPhase.offline,
        errorMessage: 'Necesitas conexión para crear un nuevo viaje.',
      );
      return false;
    }

    state = state.copyWith(phase: CreateTripPhase.creating, clearError: true);

    final manualStops = state.requiresManualStopSelection &&
            state.selectedStopId != null
        ? <int>[state.selectedStopId!]
        : const <int>[];

    final result = await _createTripUseCase.execute(
      user: state.user!,
      catalogs: state.catalogs!,
      routeId: state.selectedRouteId!,
      serviceId: state.selectedServiceId!,
      scheduleId: state.selectedScheduleId!,
      busId: state.selectedBusId!,
      serviceDate: state.serviceDate,
      manualStopIds: manualStops,
    );

    if (result.isFailure) {
      final failure = result.failureOrNull!;
      final phase = failure is ValidationFailure
          ? CreateTripPhase.validationError
          : failure is NetworkFailure
              ? CreateTripPhase.offline
              : CreateTripPhase.error;
      state = state.copyWith(phase: phase, errorMessage: failure.message);
      return false;
    }

    state = state.copyWith(
      phase: CreateTripPhase.success,
      createdTrip: result.successOrNull,
      isDirty: false,
      clearError: true,
    );
    return true;
  }
}

final createTripViewModelProvider =
    StateNotifierProvider.autoDispose<CreateTripViewModel, CreateTripState>((ref) {
  final dataSource = GetIt.I<TripRemoteDataSource>();
  final tripRepository = TripRepositoryImpl(dataSource, ref);
  return CreateTripViewModel(
    getCatalogsUseCase: GetIt.I<GetCatalogsUseCase>(),
    getCurrentUserUseCase: GetIt.I<GetCurrentUserUseCase>(),
    createTripUseCase: CreateTripUseCase(
      tripRepository,
      choferIdResolver: const EnvAwareChoferIdResolver(),
    ),
    ref: ref,
  );
});
