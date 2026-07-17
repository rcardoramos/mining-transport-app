import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/entities/home_dashboard_data.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/usecases/get_driver_info_usecase.dart';
import '../../domain/usecases/get_today_trips_usecase.dart';
import '../../domain/usecases/get_pending_trips_usecase.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/update_trip_status_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/register_passenger_usecase.dart';
import '../../domain/usecases/complete_stop_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import '../states/home_dashboard_state.dart';
import 'package:mining_transport_app/core/utils/sync_provider.dart';

/// ViewModel que gestiona el estado y eventos de la pantalla principal (Home).
class HomeDashboardViewModel extends StateNotifier<HomeDashboardState> {
  final Ref _ref;
  final GetDriverInfoUseCase _getDriverInfoUseCase;
  final GetTodayTripsUseCase _getTodayTripsUseCase;
  final GetPendingTripsUseCase _getPendingTripsUseCase;
  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final UpdateTripStatusUseCase _updateTripStatusUseCase;
  final RegisterPassengerUseCase _registerPassengerUseCase;
  final CompleteStopUseCase _completeStopUseCase;

  HomeDashboardViewModel({
    required Ref ref,
    required GetDriverInfoUseCase getDriverInfoUseCase,
    required GetTodayTripsUseCase getTodayTripsUseCase,
    required GetPendingTripsUseCase getPendingTripsUseCase,
    required GetDashboardSummaryUseCase getDashboardSummaryUseCase,
    required UpdateTripStatusUseCase updateTripStatusUseCase,
    required RegisterPassengerUseCase registerPassengerUseCase,
    required CompleteStopUseCase completeStopUseCase,
  })  : _ref = ref,
        _getDriverInfoUseCase = getDriverInfoUseCase,
        _getTodayTripsUseCase = getTodayTripsUseCase,
        _getPendingTripsUseCase = getPendingTripsUseCase,
        _getDashboardSummaryUseCase = getDashboardSummaryUseCase,
        _updateTripStatusUseCase = updateTripStatusUseCase,
        _registerPassengerUseCase = registerPassengerUseCase,
        _completeStopUseCase = completeStopUseCase,
        super(const HomeDashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _fetchData();
  }

  Future<void> refreshDashboard() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    await _fetchData();
  }

  Future<void> _fetchData() async {
    final results = await Future.wait([
      _getDriverInfoUseCase.execute(),
      _getTodayTripsUseCase.execute(),
      _getPendingTripsUseCase.execute(),
      _getDashboardSummaryUseCase.execute(),
    ]);

    final driverRes = results[0];
    final todayRes = results[1];
    final pendingRes = results[2];
    final summaryRes = results[3];

    if (driverRes.isFailure || todayRes.isFailure || pendingRes.isFailure || summaryRes.isFailure) {
      String msg = 'Error cargando datos del dashboard';
      if (driverRes.isFailure) {
        msg = driverRes.failureOrNull?.message ?? msg;
      } else if (todayRes.isFailure) {
        msg = todayRes.failureOrNull?.message ?? msg;
      } else if (pendingRes.isFailure) {
        msg = pendingRes.failureOrNull?.message ?? msg;
      } else if (summaryRes.isFailure) {
        msg = summaryRes.failureOrNull?.message ?? msg;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: msg,
      );
      return;
    }

    final driver = driverRes.successOrNull as DriverEntity;
    final todayTrips = (todayRes.successOrNull as List).cast<TripEntity>();
    final pendingTrips = (pendingRes.successOrNull as List).cast<TripEntity>();
    final summary = summaryRes.successOrNull as DashboardSummaryEntity;

    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      errorMessage: null,
      data: HomeDashboardData(
        driver: driver,
        todayTrips: todayTrips,
        pendingTrips: pendingTrips,
        summary: summary,
      ),
    );
  }

  Future<void> updateTripStatus(String tripId, TripStatus newStatus) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final result = await _updateTripStatusUseCase.execute(tripId, newStatus);
    
    if (result.isFailure) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: result.failureOrNull?.message ?? 'Fallo al actualizar el viaje',
      );
      return;
    }
    
    // Si no hay conexión a internet, aumentar los pendientes de sincronización
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      _ref.read(syncProvider.notifier).incrementPendingSync();
    }
    
    await _fetchData();
  }

  Future<bool> registerPassenger(String tripId, String dni, [CollaboratorStatus? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification]) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final result = await _registerPassengerUseCase.execute(tripId, dni, status, category, registrationMethod, lat, lng, justification);
    
    if (result.isFailure) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: result.failureOrNull?.message ?? 'Fallo al registrar pasajero',
      );
      return false;
    }
    
    // Si no hay conexión a internet, aumentar los pendientes de sincronización
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      _ref.read(syncProvider.notifier).incrementPendingSync();
    }
    
    await _fetchData();
    return true;
  }

  Future<bool> completeStop(String tripId, String stopId) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final result = await _completeStopUseCase.execute(tripId, stopId);
    
    if (result.isFailure) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: result.failureOrNull?.message ?? 'Fallo al completar el paradero',
      );
      return false;
    }
    
    await _fetchData();
    return true;
  }
}

/// Proveedor global expuesto para la UI de Home.
final homeDashboardViewModelProvider =
    StateNotifierProvider<HomeDashboardViewModel, HomeDashboardState>((ref) {
  return HomeDashboardViewModel(
    ref: ref,
    getDriverInfoUseCase: GetIt.I<GetDriverInfoUseCase>(),
    getTodayTripsUseCase: GetIt.I<GetTodayTripsUseCase>(),
    getPendingTripsUseCase: GetIt.I<GetPendingTripsUseCase>(),
    getDashboardSummaryUseCase: GetIt.I<GetDashboardSummaryUseCase>(),
    updateTripStatusUseCase: GetIt.I<UpdateTripStatusUseCase>(),
    registerPassengerUseCase: GetIt.I<RegisterPassengerUseCase>(),
    completeStopUseCase: GetIt.I<CompleteStopUseCase>(),
  );
});
