import 'dart:async';
import 'package:mining_transport_app/features/home/data/models/stop_model.dart';
import 'package:mining_transport_app/features/home/data/models/trip_model.dart';
import 'trip_remote_data_source.dart';

/// Implementación Mock de alta fidelidad del [TripRemoteDataSource].
/// Mantiene estados en memoria para simular transiciones interactivas durante desarrollo.
class MockTripRemoteDataSource implements TripRemoteDataSource {
  /// Kilometraje de apertura en memoria por tripId.
  final Map<String, int> _startKmByTrip = {};

  late List<TripModel> _todayTrips;
  late List<TripModel> _pendingTrips;

  MockTripRemoteDataSource() {
    _init();
  }

  void _init() {
    final nowUtc = DateTime.now().toUtc();
    final nowPeru = nowUtc.subtract(const Duration(hours: 5));

    _todayTrips = [
      TripModel(
        id: 'TRIP-101',
        route: 'Mina Miski Mayo - Campamento',
        scheduledTime: DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day, 8 + 5, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 40,
        passengerCount: 15,
        status: 'readyToStart',
        stops: [
          const StopModel(
            id: 'STOP-101-1',
            nombre: 'Paradero 1 - Garita Principal',
            latitud: -5.194490,
            longitud: -80.632820,
            radioPermitido: 50.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-101-2',
            nombre: 'Paradero 2 - Cruce Bayóvar',
            latitud: -5.265000,
            longitud: -80.678000,
            radioPermitido: 100.0,
            orden: 2,
          ),
          const StopModel(
            id: 'STOP-101-3',
            nombre: 'Paradero 3 - Campamento Central',
            latitud: -5.833000,
            longitud: -81.050000,
            radioPermitido: 75.0,
            orden: 3,
          ),
        ],
      ),
      TripModel(
        id: 'TRIP-102',
        route: 'Campamento - Puerto Bayóvar',
        scheduledTime: DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day, 10 + 5, 30).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 0,
        status: 'scheduled',
      ),
      TripModel(
        id: 'TRIP-103',
        route: 'Puerto Bayóvar - Mina Miski Mayo',
        scheduledTime: DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day, 14 + 5, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 0,
        status: 'scheduled',
      ),
    ];

    _pendingTrips = [
      TripModel(
        id: 'TRIP-201',
        route: 'Mina Miski Mayo - Piura',
        scheduledTime: DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day + 1, 6 + 5, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'scheduled',
      ),
      TripModel(
        id: 'TRIP-202',
        route: 'Piura - Mina Miski Mayo',
        scheduledTime: DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day + 1, 18 + 5, 0).toIso8601String(),
        shift: 'Noche',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'scheduled',
      ),
    ];
  }

  @override
  Future<List<TripModel>> getTodayTrips() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_todayTrips);
  }

  @override
  Future<List<TripModel>> getPendingTrips() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_pendingTrips);
  }

  @override
  Future<TripModel> openTrip({required String tripId, required int startKm}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    _startKmByTrip[tripId] = startKm;

    for (int i = 0; i < _todayTrips.length; i++) {
      if (_todayTrips[i].id == tripId) {
        _todayTrips[i] = _todayTrips[i].copyWith(
          status: 'inProgress',
          startedAt: DateTime.now().toUtc().toIso8601String(),
        );
        return _todayTrips[i];
      }
    }

    for (int i = 0; i < _pendingTrips.length; i++) {
      if (_pendingTrips[i].id == tripId) {
        _pendingTrips[i] = _pendingTrips[i].copyWith(
          status: 'inProgress',
          startedAt: DateTime.now().toUtc().toIso8601String(),
        );
        return _pendingTrips[i];
      }
    }

    throw Exception('Viaje no encontrado: $tripId');
  }

  @override
  Future<TripModel> closeTrip({required String tripId, required int endKm}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    for (int i = 0; i < _todayTrips.length; i++) {
      if (_todayTrips[i].id == tripId) {
        _todayTrips[i] = _todayTrips[i].copyWith(
          status: 'completed',
          completedAt: DateTime.now().toUtc().toIso8601String(),
        );
        return _todayTrips[i];
      }
    }

    for (int i = 0; i < _pendingTrips.length; i++) {
      if (_pendingTrips[i].id == tripId) {
        _pendingTrips[i] = _pendingTrips[i].copyWith(
          status: 'completed',
          completedAt: DateTime.now().toUtc().toIso8601String(),
        );
        return _pendingTrips[i];
      }
    }

    throw Exception('Viaje no encontrado: $tripId');
  }

  @override
  Future<TripModel> getTripDetail(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final all = [..._todayTrips, ..._pendingTrips];
    final trip = all.where((t) => t.id == tripId).firstOrNull;

    if (trip == null) throw Exception('Viaje no encontrado: $tripId');
    return trip;
  }
}
