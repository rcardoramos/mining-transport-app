import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import '../../domain/usecases/open_trip_usecase.dart';
import '../../domain/usecases/close_trip_usecase.dart';
import '../../domain/usecases/get_trip_detail_usecase.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../data/datasources/trip_remote_data_source.dart';
import '../../data/datasources/mock_trip_remote_data_source.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../states/trip_state.dart';

/// ViewModel que gestiona el ciclo completo de vida de los viajes:
/// listado, apertura con odómetro y cierre con validación de kilometraje.
class TripViewModel extends StateNotifier<TripState> {
  final OpenTripUseCase _openTripUseCase;
  final CloseTripUseCase _closeTripUseCase;
  final GetTripDetailUseCase _getTripDetailUseCase;
  final TripRepository _repository;

  TripViewModel({
    required Ref ref,
    required OpenTripUseCase openTripUseCase,
    required CloseTripUseCase closeTripUseCase,
    required GetTripDetailUseCase getTripDetailUseCase,
    required TripRepository repository,
  })  : _openTripUseCase = openTripUseCase,
        _closeTripUseCase = closeTripUseCase,
        _getTripDetailUseCase = getTripDetailUseCase,
        _repository = repository,
        super(const TripState()) {
    loadTrips();
  }

  // ── Carga de viajes ────────────────────────────────────────────────────────

  Future<void> loadTrips() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _fetchTrips();
  }

  Future<void> refreshTrips() async {
    state = state.copyWith(errorMessage: null);
    await _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    final results = await Future.wait([
      _repository.getTodayTrips(),
      _repository.getPendingTrips(),
    ]);

    final todayRes = results[0];
    final pendingRes = results[1];

    if (todayRes.isFailure || pendingRes.isFailure) {
      final msg = todayRes.failureOrNull?.message ??
          pendingRes.failureOrNull?.message ??
          'Error al cargar los viajes';
      state = state.copyWith(isLoading: false, errorMessage: msg);
      return;
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      todayTrips: (todayRes.successOrNull as List).cast<TripEntity>(),
      pendingTrips: (pendingRes.successOrNull as List).cast<TripEntity>(),
    );
  }

  // ── Apertura de Viaje ──────────────────────────────────────────────────────

  /// Apertura un viaje con el [startKm] del odómetro capturado por el usuario.
  /// Retorna `true` si la operación fue exitosa, `false` en caso de error.
  Future<bool> openTrip({required String tripId, required int startKm}) async {
    state = state.copyWith(isActionLoading: true, errorMessage: null);

    final allTrips = [...state.todayTrips, ...state.pendingTrips];

    final result = await _openTripUseCase.execute(
      tripId: tripId,
      startKm: startKm,
      currentTrips: allTrips,
    );

    if (result.isFailure) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: result.failureOrNull?.message ?? 'Error al aperturar el viaje',
      );
      return false;
    }

    // Guardar el startKm para validar el cierre posterior
    state = state.copyWith(
      isActionLoading: false,
      activeStartKm: startKm,
    );
    await _fetchTrips();
    return true;
  }

  // ── Cierre de Viaje ────────────────────────────────────────────────────────

  /// Cierra un viaje con el [endKm] del odómetro capturado por el usuario.
  /// Valida que endKm > startKm antes de proceder.
  /// Retorna `true` si la operación fue exitosa, `false` en caso de error.
  Future<bool> closeTrip({required String tripId, required int endKm}) async {
    state = state.copyWith(isActionLoading: true, errorMessage: null);

    final result = await _closeTripUseCase.execute(
      tripId: tripId,
      endKm: endKm,
      startKm: state.activeStartKm,
    );

    if (result.isFailure) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: result.failureOrNull?.message ?? 'Error al cerrar el viaje',
      );
      return false;
    }

    state = state.copyWith(
      isActionLoading: false,
      activeStartKm: null,
    );
    await _fetchTrips();
    return true;
  }

  // ── Detalle de Viaje ───────────────────────────────────────────────────────

  Future<void> selectTrip(String tripId) async {
    state = state.copyWith(isActionLoading: true, errorMessage: null);

    final result = await _getTripDetailUseCase.execute(tripId);

    if (result.isFailure) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: result.failureOrNull?.message ?? 'Error al obtener el detalle',
      );
      return;
    }

    state = state.copyWith(
      isActionLoading: false,
      selectedTrip: result.successOrNull as TripEntity,
    );
  }

  void clearSelectedTrip() {
    state = state.copyWith(selectedTrip: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ── Provider ─────────────────────────────────────────────────────────────────

/// Provider global del módulo Trip. Usa el mock datasource por defecto.
/// Para producción, reemplazar [MockTripRemoteDataSource] por [TripRemoteDataSourceImpl].
final tripViewModelProvider = StateNotifierProvider<TripViewModel, TripState>((ref) {
  final dataSource = GetIt.I<TripRemoteDataSource>();
  final repository = TripRepositoryImpl(dataSource, ref);

  return TripViewModel(
    ref: ref,
    openTripUseCase: OpenTripUseCase(repository),
    closeTripUseCase: CloseTripUseCase(repository),
    getTripDetailUseCase: GetTripDetailUseCase(repository),
    repository: repository,
  );
});
