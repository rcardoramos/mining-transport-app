import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/time/clock.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/catalog/domain/usecases/get_catalogs_usecase.dart';
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
  final String? errorMessage;
  final CreatedTripResult? createdTrip;
  final bool isDirty;

  DateTime get serviceDate {
    final now = GetIt.I<Clock>().now().toUtc().subtract(const Duration(hours: 5));
    return DateTime(now.year, now.month, now.day);
  }

  CatalogBus? get selectedBus {
    final id = selectedBusId;
    if (id == null || catalogs == null) return null;
    return catalogs!.buses.where((b) => b.id == id).firstOrNull;
  }

  bool get isFormValid {
    final bus = selectedBus;
    return selectedRouteId != null &&
        selectedServiceId != null &&
        selectedScheduleId != null &&
        bus != null &&
        bus.capacity > 0 &&
        user != null &&
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
    String? errorMessage,
    CreatedTripResult? createdTrip,
    bool? isDirty,
    bool clearError = false,
    bool clearRoute = false,
    bool clearService = false,
    bool clearSchedule = false,
    bool clearBus = false,
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
      // Intentar caché de catálogos de todos modos
    }

    state = state.copyWith(
      phase: CreateTripPhase.loadingCatalogs,
      clearError: true,
    );

    final userResult = await _getCurrentUserUseCase();
    final catalogsResult = await _getCatalogsUseCase.execute(forceRefresh: true);

    if (catalogsResult.isFailure) {
      state = state.copyWith(
        phase: CreateTripPhase.error,
        errorMessage: catalogsResult.failureOrNull?.message ??
            'No se pudieron cargar los catálogos.',
        user: userResult.successOrNull,
      );
      return;
    }

    if (!_ref.read(syncProvider).isOnline) {
      state = state.copyWith(
        phase: CreateTripPhase.offline,
        catalogs: catalogsResult.successOrNull,
        user: userResult.successOrNull,
        errorMessage: 'Necesitas conexión para crear un nuevo viaje.',
      );
      return;
    }

    state = state.copyWith(
      phase: CreateTripPhase.ready,
      catalogs: catalogsResult.successOrNull,
      user: userResult.successOrNull,
      clearError: true,
    );
  }

  void selectRoute(int? id) {
    state = state.copyWith(selectedRouteId: id, isDirty: true, clearError: true);
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

  Future<bool> submit() async {
    if (state.phase == CreateTripPhase.creating) return false;
    if (!state.isFormValid) {
      state = state.copyWith(
        phase: CreateTripPhase.validationError,
        errorMessage: 'Complete todos los campos obligatorios.',
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

    final result = await _createTripUseCase.execute(
      user: state.user!,
      catalogs: state.catalogs!,
      routeId: state.selectedRouteId!,
      serviceId: state.selectedServiceId!,
      scheduleId: state.selectedScheduleId!,
      busId: state.selectedBusId!,
      serviceDate: state.serviceDate,
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
