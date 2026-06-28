import 'dart:async';
import 'home_dashboard_remote_data_source.dart';
import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/dashboard_summary_model.dart';
import '../models/passenger_model.dart';
import '../models/collaborator_model.dart';

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

  /// Mapa que almacena la lista de pasajeros por tripId en memoria.
  final Map<String, List<PassengerModel>> _passengers = {};

  /// Nombres mock para simular resolución de DNI contra BD offline.
  static const List<String> _mockNames = [
    'Carlos Mendoza Rojas',
    'Ana Flores Pineda',
    'Jorge Torres Vega',
    'Luz Huamán Ríos',
    'Pedro Salinas Cruz',
    'María Cárdenas López',
    'José Quispe Mamani',
    'Rosa Vargas Espinoza',
    'Luis Pacheco Neira',
    'Carmen Díaz Alcántara',
    'Miguel Ángel Soto Reyes',
    'Elena Castillo Herrera',
    'Raúl Medina Fuentes',
    'Patricia Núñez Campos',
    'Francisco Lara Tello',
  ];

  int _nameIndex = 0;

  MockHomeDashboardRemoteDataSource() {
    final now = DateTime.now();
    _todayTrips = [
      TripModel(
        id: 'TRIP-101',
        route: 'Mina Miski Mayo - Campamento',
        scheduledTime: DateTime(now.year, now.month, now.day, 8, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 40,
        passengerCount: 15,
        status: 'readyToStart',
      ),
      TripModel(
        id: 'TRIP-102',
        route: 'Campamento - Puerto Bayóvar',
        scheduledTime: DateTime(now.year, now.month, now.day, 10, 30).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-01',
        capacity: 45,
        passengerCount: 15,
        status: 'scheduled',
      ),
      TripModel(
        id: 'TRIP-103',
        route: 'Puerto Bayóvar - Mina Miski Mayo',
        scheduledTime: DateTime(now.year, now.month, now.day, 14, 0).toIso8601String(),
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
        scheduledTime: DateTime(now.year, now.month, now.day + 1, 6, 0).toIso8601String(),
        shift: 'Día',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'scheduled',
      ),
      TripModel(
        id: 'TRIP-202',
        route: 'Piura - Mina Miski Mayo',
        scheduledTime: DateTime(now.year, now.month, now.day + 1, 18, 0).toIso8601String(),
        shift: 'Noche',
        unitCode: 'BUS-03',
        capacity: 50,
        passengerCount: 0,
        status: 'scheduled',
      ),
    ];

    // Semilla de pasajeros iniciales para TRIP-101 (ya tiene 15 registrados en mock)
    final seedTime = now.subtract(const Duration(minutes: 30));
    _passengers['TRIP-101'] = List.generate(15, (i) {
      return PassengerModel(
        dni: '${48000000 + i + 1}',
        fullName: _mockNames[i % _mockNames.length],
        boardedAt: seedTime.add(Duration(minutes: i * 2)).toIso8601String(),
        registrationMethod: i % 3 == 0 ? 'manual' : 'qr_scan',
        status: 'ok',
        seatNumber: '${i + 1}',
      );
    });
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
        // Al pasar a 'inProgress' seteamos el timestamp de inicio actual
        if (status == 'inProgress') {
          _todayTrips[i] = _todayTrips[i].copyWith(
            status: status,
            startedAt: DateTime.now().toIso8601String(),
          );
        } else {
          _todayTrips[i] = _todayTrips[i].copyWith(status: status);
        }
        
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
        if (status == 'inProgress') {
          _pendingTrips[i] = _pendingTrips[i].copyWith(
            status: status,
            startedAt: DateTime.now().toIso8601String(),
          );
        } else {
          _pendingTrips[i] = _pendingTrips[i].copyWith(status: status);
        }
        return _pendingTrips[i];
      }
    }
    
    throw Exception('Viaje no encontrado');
  }

  @override
  Future<TripModel> registerPassenger(String id, String dni, [String? status]) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Determinar el nombre (simulación de resolución contra BD offline)
    final name = _mockNames[dni.hashCode % _mockNames.length];

    final finalStatus = status ?? _determineStatus(dni);

    final newPassenger = PassengerModel(
      dni: dni,
      fullName: name,
      boardedAt: DateTime.now().toIso8601String(),
      registrationMethod: 'manual',
      status: finalStatus,
      seatNumber: '${(_passengers[id]?.length ?? 0) + 1}',
    );

    // Guardar en el mapa de pasajeros
    _passengers.putIfAbsent(id, () => []);

    // Verificar duplicidad en memoria
    final isDuplicate = _passengers[id]!.any((p) => p.dni.trim() == dni.trim());
    if (isDuplicate) {
      throw Exception('Colaborador ya registrado en este viaje');
    }

    // Buscar en hoy y aumentar el conteo de pasajeros
    for (int i = 0; i < _todayTrips.length; i++) {
      if (_todayTrips[i].id == id) {
        if (_todayTrips[i].passengerCount < _todayTrips[i].capacity) {
          _passengers[id]!.add(newPassenger);
          _todayTrips[i] = _todayTrips[i].copyWith(
            passengerCount: _todayTrips[i].passengerCount + 1,
          );
        } else {
          throw Exception('Se ha superado la capacidad máxima del bus');
        }
        return _todayTrips[i];
      }
    }

    // Buscar en pendientes
    for (int i = 0; i < _pendingTrips.length; i++) {
      if (_pendingTrips[i].id == id) {
        if (_pendingTrips[i].passengerCount < _pendingTrips[i].capacity) {
          _passengers[id]!.add(newPassenger);
          _pendingTrips[i] = _pendingTrips[i].copyWith(
            passengerCount: _pendingTrips[i].passengerCount + 1,
          );
        } else {
          throw Exception('Se ha superado la capacidad máxima del bus');
        }
        return _pendingTrips[i];
      }
    }

    throw Exception('Viaje no encontrado');
  }

  @override
  Future<List<PassengerModel>> getPassengersOnBoard(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_passengers[tripId] ?? []);
  }

  @override
  Future<CollaboratorModel> checkCollaborator(String dni) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final name = _mockNames[dni.hashCode % _mockNames.length];
    final statusStr = _determineStatus(dni);
    return CollaboratorModel(
      dni: dni,
      fullName: name,
      status: statusStr,
    );
  }

  String _determineStatus(String dni) {
    if (dni == '11111111' || dni.endsWith('1')) return 'vacation';
    if (dni == '22222222' || dni.endsWith('2')) return 'medicalLeave';
    if (dni == '33333333' || dni.endsWith('3')) return 'license';
    if (dni == '44444444' || dni.endsWith('4')) return 'terminated';
    return 'ok';
  }
}
