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
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'dart:convert';
import 'package:mining_transport_app/features/home/data/datasources/home_dashboard_remote_data_source.dart';
import 'package:mining_transport_app/features/home/data/datasources/mock_home_dashboard_remote_data_source.dart';

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
    
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      final payloadJson = jsonEncode({
        'tripId': tripId,
        'status': newStatus.name,
      });
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'CLOSE_TRIP',
        payloadJson: payloadJson,
      );
      
      final remoteDataSource = GetIt.I<HomeDashboardRemoteDataSource>();
      if (remoteDataSource is MockHomeDashboardRemoteDataSource) {
        await remoteDataSource.updateTripStatus(tripId, newStatus.name);
      }
      
      await _fetchData();
      return;
    }

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

  Future<bool> registerPassenger(String tripId, String dni, [CollaboratorStatus? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification]) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      final payloadJson = jsonEncode({
        'tripId': tripId,
        'dni': dni,
        'status': status?.name,
        'category': category,
        'registrationMethod': registrationMethod,
        'lat': lat,
        'lng': lng,
        'justification': justification,
      });
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'BOARD_PASSENGER',
        payloadJson: payloadJson,
      );
      
      final remoteDataSource = GetIt.I<HomeDashboardRemoteDataSource>();
      if (remoteDataSource is MockHomeDashboardRemoteDataSource) {
        await remoteDataSource.registerPassenger(tripId, dni, status?.name, category, registrationMethod, lat, lng, justification);
      }

      await _fetchData();
      return true;
    }

    final result = await _registerPassengerUseCase.execute(tripId, dni, status, category, registrationMethod, lat, lng, justification);
    
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

  Future<bool> completeStop(String tripId, String stopId) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    final isOnline = _ref.read(syncProvider).isOnline;
    if (!isOnline) {
      final payloadJson = jsonEncode({
        'tripId': tripId,
        'stopId': stopId,
      });
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'COMPLETE_STOP',
        payloadJson: payloadJson,
      );
      
      final remoteDataSource = GetIt.I<HomeDashboardRemoteDataSource>();
      if (remoteDataSource is MockHomeDashboardRemoteDataSource) {
        await remoteDataSource.completeStop(tripId, stopId);
      }
      
      await _fetchData();
      return true;
    }

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
