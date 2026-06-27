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
import '../../domain/usecases/register_passenger_usecase.dart';
import '../states/home_dashboard_state.dart';

/// ViewModel que gestiona el estado y eventos de la pantalla principal (Home).
class HomeDashboardViewModel extends StateNotifier<HomeDashboardState> {
  final GetDriverInfoUseCase _getDriverInfoUseCase;
  final GetTodayTripsUseCase _getTodayTripsUseCase;
  final GetPendingTripsUseCase _getPendingTripsUseCase;
  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final UpdateTripStatusUseCase _updateTripStatusUseCase;
  final RegisterPassengerUseCase _registerPassengerUseCase;

  HomeDashboardViewModel({
    required GetDriverInfoUseCase getDriverInfoUseCase,
    required GetTodayTripsUseCase getTodayTripsUseCase,
    required GetPendingTripsUseCase getPendingTripsUseCase,
    required GetDashboardSummaryUseCase getDashboardSummaryUseCase,
    required UpdateTripStatusUseCase updateTripStatusUseCase,
    required RegisterPassengerUseCase registerPassengerUseCase,
  })  : _getDriverInfoUseCase = getDriverInfoUseCase,
        _getTodayTripsUseCase = getTodayTripsUseCase,
        _getPendingTripsUseCase = getPendingTripsUseCase,
        _getDashboardSummaryUseCase = getDashboardSummaryUseCase,
        _updateTripStatusUseCase = updateTripStatusUseCase,
        _registerPassengerUseCase = registerPassengerUseCase,
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
    
    await _fetchData();
  }

  Future<bool> registerPassenger(String tripId, String dni) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final result = await _registerPassengerUseCase.execute(tripId, dni);
    
    if (result.isFailure) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: result.failureOrNull?.message ?? 'Fallo al registrar pasajero',
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
    getDriverInfoUseCase: GetIt.I<GetDriverInfoUseCase>(),
    getTodayTripsUseCase: GetIt.I<GetTodayTripsUseCase>(),
    getPendingTripsUseCase: GetIt.I<GetPendingTripsUseCase>(),
    getDashboardSummaryUseCase: GetIt.I<GetDashboardSummaryUseCase>(),
    updateTripStatusUseCase: GetIt.I<UpdateTripStatusUseCase>(),
    registerPassengerUseCase: GetIt.I<RegisterPassengerUseCase>(),
  );
});
