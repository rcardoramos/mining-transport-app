import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/features/catalog/domain/usecases/get_catalogs_usecase.dart';
import 'package:mining_transport_app/features/home/domain/entities/home_dashboard_data.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_close_context.dart';
import 'package:mining_transport_app/features/home/domain/entities/stop_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/driver_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_driver_info_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_today_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_pending_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/update_trip_status_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/register_passenger_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/complete_stop_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/home/presentation/states/home_dashboard_state.dart';
import 'package:mining_transport_app/features/sync/presentation/viewmodels/sync_viewmodel.dart';
import 'package:mining_transport_app/features/home/data/datasources/home_dashboard_remote_data_source.dart';
import 'package:mining_transport_app/features/home/data/datasources/mock_home_dashboard_remote_data_source.dart';

/// ViewModel que gestiona el estado y eventos de la pantalla principal (Home).
class HomeDashboardViewModel extends StateNotifier<HomeDashboardState> {
  final Ref _ref;
  final GetDriverInfoUseCase _getDriverInfoUseCase;
  final GetTodayTripsUseCase _getTodayTripsUseCase;
  final GetPendingTripsUseCase _getPendingTripsUseCase;
  final UpdateTripStatusUseCase _updateTripStatusUseCase;
  final RegisterPassengerUseCase _registerPassengerUseCase;
  final CompleteStopUseCase _completeStopUseCase;

  HomeDashboardViewModel({
    required Ref ref,
    required GetDriverInfoUseCase getDriverInfoUseCase,
    required GetTodayTripsUseCase getTodayTripsUseCase,
    required GetPendingTripsUseCase getPendingTripsUseCase,
    required UpdateTripStatusUseCase updateTripStatusUseCase,
    required RegisterPassengerUseCase registerPassengerUseCase,
    required CompleteStopUseCase completeStopUseCase,
  })  : _ref = ref,
        _getDriverInfoUseCase = getDriverInfoUseCase,
        _getTodayTripsUseCase = getTodayTripsUseCase,
        _getPendingTripsUseCase = getPendingTripsUseCase,
        _updateTripStatusUseCase = updateTripStatusUseCase,
        _registerPassengerUseCase = registerPassengerUseCase,
        _completeStopUseCase = completeStopUseCase,
        super(const HomeDashboardState()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    // Prefetch catálogos en paralelo para que "Crear viaje" abra al instante.
    unawaited(GetIt.I<GetCatalogsUseCase>().execute(forceRefresh: false));
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
    ]);

    final driverRes = results[0];
    final todayRes = results[1];
    final pendingRes = results[2];

    if (driverRes.isFailure || todayRes.isFailure || pendingRes.isFailure) {
      String msg = 'Error cargando datos del dashboard';
      if (driverRes.isFailure) {
        msg = driverRes.failureOrNull?.message ?? msg;
      } else if (todayRes.isFailure) {
        msg = todayRes.failureOrNull?.message ?? msg;
      } else if (pendingRes.isFailure) {
        msg = pendingRes.failureOrNull?.message ?? msg;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: msg,
      );
      return;
    }

    final driverRaw = driverRes.successOrNull as DriverEntity;
    final todayTrips = sortTripsByOperationalStatus(
      (todayRes.successOrNull as List).cast<TripEntity>(),
    );
    final pendingTrips = sortTripsByOperationalStatus(
      (pendingRes.successOrNull as List).cast<TripEntity>(),
    );
    final summary = _summaryFromTodayTrips(todayTrips);

    // getDriverInfo no recibe todayTripsCount del backend (queda en 0);
    // alinear el contador "Viajes Hoy" con la lista real de viajes del día.
    final driver = driverRaw.copyWith(todayTripsCount: todayTrips.length);

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

  DashboardSummaryEntity _summaryFromTodayTrips(List<TripEntity> todayTrips) {
    final completed =
        todayTrips.where((t) => t.status == TripStatus.completed).toList();
    return DashboardSummaryEntity(
      completedTrips: completed.length,
      passengersTransported:
          completed.fold(0, (sum, t) => sum + t.passengerCount),
      observationsRegistered: 0,
    );
  }

  void _patchTripInState(String tripId, TripEntity Function(TripEntity) patch) {
    final currentData = state.data;
    if (currentData == null) {
      state = state.copyWith(isRefreshing: false);
      return;
    }

    TripEntity? patched;
    final updatedToday = sortTripsByOperationalStatus(
      currentData.todayTrips.map((t) {
        if (t.id != tripId) return t;
        patched = patch(t);
        return patched!;
      }).toList(),
    );
    final updatedPending = sortTripsByOperationalStatus(
      currentData.pendingTrips.map((t) {
        if (t.id != tripId) return t;
        patched = patch(t);
        return patched!;
      }).toList(),
    );

    state = state.copyWith(
      isRefreshing: false,
      errorMessage: null,
      data: currentData.copyWith(
        todayTrips: updatedToday,
        pendingTrips: updatedPending,
        summary: _summaryFromTodayTrips(updatedToday),
        driver: currentData.driver.copyWith(todayTripsCount: updatedToday.length),
      ),
    );
  }

  /// Si Historial aún no lista el viaje recién creado (p.ej. estado P),
  /// lo inserta en "Viajes de Hoy" para poder aperturarlo.
  void ensureCreatedTripVisible(TripEntity trip) {
    final data = state.data;
    if (data == null) return;

    final alreadyInToday = data.todayTrips.any((t) => t.id == trip.id);
    final alreadyInPending = data.pendingTrips.any((t) => t.id == trip.id);
    if (alreadyInToday || alreadyInPending) return;

    final todayTrips = sortTripsByOperationalStatus([trip, ...data.todayTrips]);
    state = state.copyWith(
      data: data.copyWith(
        todayTrips: todayTrips,
        driver: data.driver.copyWith(todayTripsCount: todayTrips.length),
      ),
    );
  }

  Future<void> updateTripStatus(
    String tripId,
    TripStatus newStatus, {
    TripCloseContext? closeContext,
  }) async {
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
      
      _patchTripInState(tripId, (t) => t.copyWith(
        status: newStatus,
        startedAt: newStatus == TripStatus.inProgress ? DateTime.now() : t.startedAt,
        completedAt: newStatus == TripStatus.completed ? DateTime.now() : t.completedAt,
      ));
      return;
    }

    final result = await _updateTripStatusUseCase.execute(
      tripId,
      newStatus,
      closeContext: closeContext,
    );
    
    if (result.isFailure) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: result.failureOrNull?.message ?? 'Fallo al actualizar el viaje',
      );
      return;
    }

    final updated = result.successOrNull;
    _patchTripInState(tripId, (t) {
      if (updated == null) {
        return t.copyWith(
          status: newStatus,
          startedAt: newStatus == TripStatus.inProgress
              ? (t.startedAt ?? DateTime.now())
              : t.startedAt,
          completedAt: newStatus == TripStatus.completed
              ? (t.completedAt ?? DateTime.now())
              : t.completedAt,
        );
      }
      return t.copyWith(
        status: newStatus == TripStatus.travelling
            ? TripStatus.travelling
            : (updated.status == TripStatus.scheduled && newStatus == TripStatus.inProgress
                ? TripStatus.inProgress
                : updated.status),
        passengerCount: updated.passengerCount > 0 ? updated.passengerCount : t.passengerCount,
        capacity: updated.capacity > 0 ? updated.capacity : t.capacity,
        route: updated.route.isNotEmpty ? updated.route : t.route,
        unitCode: updated.unitCode.isNotEmpty ? updated.unitCode : t.unitCode,
        shift: updated.shift.isNotEmpty ? updated.shift : t.shift,
        startedAt: updated.startedAt ??
            (newStatus == TripStatus.inProgress ? DateTime.now() : t.startedAt),
        completedAt: updated.completedAt ??
            (newStatus == TripStatus.completed ? DateTime.now() : t.completedAt),
        stops: (updated.stops != null && updated.stops!.isNotEmpty)
            ? updated.stops
            : t.stops,
      );
    });

    // Sync suave en background solo tras aperturar/cerrar (no bloquea UI ni skeleton).
    if (newStatus == TripStatus.inProgress || newStatus == TripStatus.completed) {
      unawaited(syncDashboardInBackground());
    }
  }

  /// Revalida Historial sin skeleton (`isLoading`) ni indicador de pull-to-refresh.
  Future<void> syncDashboardInBackground() async {
    if (state.data == null) {
      await loadDashboard();
      return;
    }
    await _fetchData();
  }

  Future<bool> registerPassenger(String tripId, String dni, [CollaboratorStatus? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification, String? uidCliente, String? nombreCompleto, String? empresa, int? paraderoId, String? lugarSubida, String? puesto, String? unidad]) async {
    // No marcar isRefreshing del Home: evita rebuilds pesados durante el escaneo.
    state = state.copyWith(errorMessage: null);
    
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
        'uidCliente': uidCliente,
        'nombreCompleto': nombreCompleto,
        'empresa': empresa,
        'paraderoId': paraderoId,
        'lugarSubida': lugarSubida,
        'puesto': puesto,
        'unidad': unidad,
      });
      await _ref.read(syncProvider.notifier).queueAction(
        actionType: 'BOARD_PASSENGER',
        payloadJson: payloadJson,
      );
      
      final remoteDataSource = GetIt.I<HomeDashboardRemoteDataSource>();
      if (remoteDataSource is MockHomeDashboardRemoteDataSource) {
        await remoteDataSource.registerPassenger(tripId, dni, status?.name, category, registrationMethod, lat, lng, justification, uidCliente, nombreCompleto, empresa, paraderoId, lugarSubida, puesto, unidad);
      }

      // Incrementar el aforo localmente en el State del ViewModel para visualización inmediata offline
      final currentData = state.data;
      if (currentData != null) {
        final updatedToday = sortTripsByOperationalStatus(
          currentData.todayTrips.map((t) {
            if (t.id == tripId) {
              return t.copyWith(passengerCount: t.passengerCount + 1);
            }
            return t;
          }).toList(),
        );
        final updatedPending = sortTripsByOperationalStatus(
          currentData.pendingTrips.map((t) {
            if (t.id == tripId) {
              return t.copyWith(passengerCount: t.passengerCount + 1);
            }
            return t;
          }).toList(),
        );
        state = state.copyWith(
          isRefreshing: false,
          data: currentData.copyWith(
            todayTrips: updatedToday,
            pendingTrips: updatedPending,
          ),
        );
      } else {
        state = state.copyWith(isRefreshing: false);
      }

      return true;
    }

    final result = await _registerPassengerUseCase.execute(tripId, dni, status, category, registrationMethod, lat, lng, justification, uidCliente, nombreCompleto, empresa, paraderoId, lugarSubida, puesto, unidad);
    
    if (result.isFailure) {
      final failureMessage = result.failureOrNull?.message ?? 'Fallo al registrar pasajero';
      // Si el backend indica duplicado, refrescar lista y tratarlo como caso conocido
      // (el pasajero ya quedó a bordo en un intento previo).
      if (failureMessage.toUpperCase().contains('DUPLICADO')) {
        state = state.copyWith(
          isRefreshing: false,
          errorMessage: 'DUPLICADO',
        );
        return false;
      }
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: failureMessage,
      );
      return false;
    }

    // Actualizar el viaje en el State local con la entidad actualizada retornada por el servidor
    final updatedTrip = result.successOrNull;
    if (updatedTrip != null) {
      final currentData = state.data;
      if (currentData != null) {
        final updatedToday = sortTripsByOperationalStatus(
          currentData.todayTrips.map<TripEntity>((t) {
            if (t.id == tripId) {
              return t.copyWith(
                passengerCount: updatedTrip.passengerCount,
                status: updatedTrip.status,
                startedAt: updatedTrip.startedAt ?? t.startedAt,
                completedAt: updatedTrip.completedAt ?? t.completedAt,
                stops: (updatedTrip.stops != null && updatedTrip.stops!.isNotEmpty)
                    ? updatedTrip.stops
                    : t.stops,
              );
            }
            return t;
          }).toList(),
        );
        final updatedPending = sortTripsByOperationalStatus(
          currentData.pendingTrips.map<TripEntity>((t) {
            if (t.id == tripId) {
              return t.copyWith(
                passengerCount: updatedTrip.passengerCount,
                status: updatedTrip.status,
                startedAt: updatedTrip.startedAt ?? t.startedAt,
                completedAt: updatedTrip.completedAt ?? t.completedAt,
                stops: (updatedTrip.stops != null && updatedTrip.stops!.isNotEmpty)
                    ? updatedTrip.stops
                    : t.stops,
              );
            }
            return t;
          }).toList(),
        );
        state = state.copyWith(
          data: currentData.copyWith(
            todayTrips: updatedToday,
            pendingTrips: updatedPending,
            summary: _summaryFromTodayTrips(updatedToday),
          ),
        );
      }
    }
    
    return true;
  }

  Future<bool> completeStop(String tripId, String stopId) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    
    // Completar paradero es una acción puramente local en el frontend en producción,
    // ya que no existe un endpoint en el servidor real para esto.
    final remoteDataSource = GetIt.I<HomeDashboardRemoteDataSource>();
    if (remoteDataSource is MockHomeDashboardRemoteDataSource) {
      try {
        await remoteDataSource.completeStop(tripId, stopId);
      } catch (_) {}
    }
    
    final currentData = state.data;
    if (currentData != null) {
      final updatedToday = sortTripsByOperationalStatus(
        currentData.todayTrips.map((t) {
          if (t.id == tripId) {
            final List<StopEntity>? stops = t.stops?.map((s) => s.id == stopId ? s.copyWith(isCompleted: true) : s).toList();
            return t.copyWith(stops: stops);
          }
          return t;
        }).toList(),
      );
      final updatedPending = sortTripsByOperationalStatus(
        currentData.pendingTrips.map((t) {
          if (t.id == tripId) {
            final List<StopEntity>? stops = t.stops?.map((s) => s.id == stopId ? s.copyWith(isCompleted: true) : s).toList();
            return t.copyWith(stops: stops);
          }
          return t;
        }).toList(),
      );
      state = state.copyWith(
        isRefreshing: false,
        data: currentData.copyWith(
          todayTrips: updatedToday,
          pendingTrips: updatedPending,
          summary: currentData.summary, // Mantener el mismo summary
        ),
      );
    } else {
      state = state.copyWith(isRefreshing: false);
    }
    
    return true;
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
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
    updateTripStatusUseCase: GetIt.I<UpdateTripStatusUseCase>(),
    registerPassengerUseCase: GetIt.I<RegisterPassengerUseCase>(),
    completeStopUseCase: GetIt.I<CompleteStopUseCase>(),
  );
});
