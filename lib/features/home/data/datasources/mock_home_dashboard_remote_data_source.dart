import 'dart:async';
import 'home_dashboard_remote_data_source.dart';
import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/dashboard_summary_model.dart';

/// Implementación Mock de alta fidelidad del Data Source remoto.
/// Mantiene estados en memoria para simular transiciones interactivas.
class MockHomeDashboardRemoteDataSource implements HomeDashboardRemoteDataSource {
  DriverModel _driver = const DriverModel(
    id: 'DRV-998',
    name: 'Ricardo Ramos',
    code: 'COD-48102',
    status: 'active',
    todayTripsCount: 2,
    avatarUrl: null,
  );

  late List<TripModel> _todayTrips;
  late List<TripModel> _pendingTrips;

  MockHomeDashboardRemoteDataSource() {
    final now = DateTime.now();
    _todayTrips = [
      TripModel(
        id: 'TRIP-101',
        route: 'Mina Miski Mayo - Campamento',
        scheduledTime: DateTime(now.year, now.month, now.day, 8, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 42,
        status: 'active',
      ),
      TripModel(
        id: 'TRIP-102',
        route: 'Campamento - Puerto Bayóvar',
        scheduledTime: DateTime(now.year, now.month, now.day, 10, 30).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 15,
        status: 'pending',
      ),
      TripModel(
        id: 'TRIP-103',
        route: 'Puerto Bayóvar - Mina Miski Mayo',
        scheduledTime: DateTime(now.year, now.month, now.day, 14, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 0,
        status: 'pending',
      ),
    ];

    _pendingTrips = [
      TripModel(
        id: 'TRIP-201',
        route: 'Mina Miski Mayo - Piura',
        scheduledTime: DateTime(now.year, now.month, now.day + 1, 6, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'pending',
      ),
      TripModel(
        id: 'TRIP-202',
        route: 'Piura - Mina Miski Mayo',
        scheduledTime: DateTime(now.year, now.month, now.day + 1, 18, 0).toIso8601String(),
        shift: 'Noche',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'pending',
      ),
    ];
  }

  @override
  Future<DriverModel> getDriverInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _driver;
  }

  @override
  Future<List<TripModel>> getTodayTrips() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _todayTrips;
  }

  @override
  Future<List<TripModel>> getPendingTrips() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _pendingTrips;
  }

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    int completed = _todayTrips.where((t) => t.status == 'completed').length;
    int passengers = _todayTrips
        .where((t) => t.status == 'completed')
        .fold(0, (sum, t) => sum + t.passengerCount);
    
    return DashboardSummaryModel(
      completedTrips: completed,
      passengersTransported: passengers,
      observationsRegistered: 1,
    );
  }

  @override
  Future<TripModel> updateTripStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Buscar en hoy
    for (int i = 0; i < _todayTrips.length; i++) {
      if (_todayTrips[i].id == id) {
        _todayTrips[i] = _todayTrips[i].copyWith(status: status);
        
        // Si el viaje se completó, incrementamos los viajes del día del conductor
        if (status == 'completed') {
          _driver = _driver.copyWith(todayTripsCount: _driver.todayTripsCount + 1);
        }
        
        return _todayTrips[i];
      }
    }
    
    // Buscar en pendientes
    for (int i = 0; i < _pendingTrips.length; i++) {
      if (_pendingTrips[i].id == id) {
        _pendingTrips[i] = _pendingTrips[i].copyWith(status: status);
        return _pendingTrips[i];
      }
    }
    
    throw Exception('Viaje no encontrado');
  }
}
