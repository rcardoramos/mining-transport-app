import 'dart:async';
import 'home_dashboard_remote_data_source.dart';
import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/stop_model.dart';
import '../models/dashboard_summary_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/passenger_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/collaborator_model.dart';

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



  MockHomeDashboardRemoteDataSource() {
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
            latitud: -12.046374,
            longitud: -77.042793,
            radioPermitido: 50.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-101-2',
            nombre: 'Paradero 2 - Cruce Bayóvar',
            latitud: -12.050000,
            longitud: -77.050000,
            radioPermitido: 100.0,
            orden: 2,
          ),
          const StopModel(
            id: 'STOP-101-3',
            nombre: 'Paradero 3 - Campamento Central',
            latitud: -12.060000,
            longitud: -77.060000,
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
        passengerCount: 15,
        status: 'scheduled',
        stops: [
          const StopModel(
            id: 'STOP-102-1',
            nombre: 'Paradero 1 - Terminal Campamento',
            latitud: -5.265000,
            longitud: -81.050000,
            radioPermitido: 120.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-102-2',
            nombre: 'Paradero 2 - Control de Entrada',
            latitud: -5.275000,
            longitud: -81.060000,
            radioPermitido: 100.0,
            orden: 2,
          ),
        ],
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
        stops: [
          const StopModel(
            id: 'STOP-103-1',
            nombre: 'Paradero 1 - Puerto Bayóvar',
            latitud: -5.250000,
            longitud: -81.020000,
            radioPermitido: 150.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-103-2',
            nombre: 'Paradero 2 - Cruce Autopista',
            latitud: -5.260000,
            longitud: -81.030000,
            radioPermitido: 100.0,
            orden: 2,
          ),
        ],
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
        stops: [
          const StopModel(
            id: 'STOP-201-1',
            nombre: 'Paradero 1 - Mina Principal',
            latitud: -5.850000,
            longitud: -80.800000,
            radioPermitido: 150.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-201-2',
            nombre: 'Paradero 2 - Control General',
            latitud: -5.860000,
            longitud: -80.810000,
            radioPermitido: 100.0,
            orden: 2,
          ),
        ],
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
        stops: [
          const StopModel(
            id: 'STOP-202-1',
            nombre: 'Paradero 1 - Terminal Piura',
            latitud: -5.200000,
            longitud: -80.630000,
            radioPermitido: 120.0,
            orden: 1,
          ),
          const StopModel(
            id: 'STOP-202-2',
            nombre: 'Paradero 2 - Garita Piura',
            latitud: -5.210000,
            longitud: -80.640000,
            radioPermitido: 100.0,
            orden: 2,
          ),
        ],
      ),
    ];

    // Semilla de pasajeros iniciales para TRIP-101 (ya tiene 15 registrados en mock)
    final seedTime = nowUtc.subtract(const Duration(minutes: 30));
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
            startedAt: DateTime.now().toUtc().toIso8601String(),
          );
        } else if (status == 'completed') {
          _todayTrips[i] = _todayTrips[i].copyWith(
            status: status,
            completedAt: DateTime.now().toUtc().toIso8601String(),
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
            startedAt: DateTime.now().toUtc().toIso8601String(),
          );
        } else if (status == 'completed') {
          _pendingTrips[i] = _pendingTrips[i].copyWith(
            status: status,
            completedAt: DateTime.now().toUtc().toIso8601String(),
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
  Future<TripModel> registerPassenger(String id, String dni, [String? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification]) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Determinar la categoría (si es proporcionada, la usamos; si no, la deducimos del DNI)
    String finalCategory = category ?? 'Miski Mayo';
    if (category == null) {
      if (dni.endsWith('7')) {
        finalCategory = 'Contratista';
      } else if (dni.endsWith('8')) {
        finalCategory = 'Terceros';
      } else if (dni.endsWith('9')) {
        finalCategory = 'Visita';
      }
    }

    // Determinar el nombre
    String finalName;
    if (finalCategory == 'Contratista' || finalCategory == 'Terceros' || finalCategory == 'Visita') {
      finalName = 'Externo ($finalCategory)';
    } else {
      finalName = _mockNames[dni.hashCode % _mockNames.length];
    }

    final finalStatus = status ?? _determineStatus(dni);

    // Determinar si el viaje está en tránsito (travelling)
    final isTravelling = _todayTrips.any((t) => t.id == id && t.status == 'travelling') ||
                         _pendingTrips.any((t) => t.id == id && t.status == 'travelling');
    
    final isScan = ['48102030', '11111111', '22222222', '33333333', '44444444'].contains(dni);
    final prefix = isScan ? 'qr_scan' : 'manual';
    
    final method = registrationMethod ?? (isTravelling ? '${prefix}_transit' : prefix);
    final finalMethod = justification != null ? '$method (Forzado: $justification)' : method;

    final newPassenger = PassengerModel(
      dni: dni,
      fullName: finalName,
      boardedAt: DateTime.now().toIso8601String(),
      registrationMethod: finalMethod,
      status: finalStatus,
      seatNumber: '${(_passengers[id]?.length ?? 0) + 1}',
      category: finalCategory,
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

    // Si el DNI empieza con 99, simulamos que no está en la base de datos
    if (dni.startsWith('99')) {
      throw Exception('not_found: El colaborador no existe en el padrón local');
    }

    final name = _mockNames[dni.hashCode % _mockNames.length];
    final statusStr = _determineStatus(dni);

    // Determinar categoría por defecto según el DNI
    String category = 'Miski Mayo';
    if (dni.endsWith('7')) {
      category = 'Contratista';
    } else if (dni.endsWith('8')) {
      category = 'Terceros';
    } else if (dni.endsWith('9')) {
      category = 'Visita';
    }

    return CollaboratorModel(
      dni: dni,
      fullName: name,
      status: statusStr,
      category: category,
    );
  }

  String _determineStatus(String dni) {
    if (dni == '11111111' || dni.endsWith('1')) return 'vacation';
    if (dni == '22222222' || dni.endsWith('2')) return 'medicalLeave';
    if (dni == '33333333' || dni.endsWith('3')) return 'license';
    if (dni == '44444444' || dni.endsWith('4')) return 'terminated';
    return 'ok';
  }

  @override
  Future<TripModel> completeStop(String id, String stopId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    // Buscar en hoy
    for (int i = 0; i < _todayTrips.length; i++) {
      if (_todayTrips[i].id == id) {
        final currentStops = _todayTrips[i].stops ?? [];
        final updatedStops = currentStops.map((stop) {
          if (stop.id == stopId) {
            return stop.copyWith(completado: true);
          }
          return stop;
        }).toList();
        _todayTrips[i] = _todayTrips[i].copyWith(stops: updatedStops);
        return _todayTrips[i];
      }
    }

    // Buscar en pendientes
    for (int i = 0; i < _pendingTrips.length; i++) {
      if (_pendingTrips[i].id == id) {
        final currentStops = _pendingTrips[i].stops ?? [];
        final updatedStops = currentStops.map((stop) {
          if (stop.id == stopId) {
            return stop.copyWith(completado: true);
          }
          return stop;
        }).toList();
        _pendingTrips[i] = _pendingTrips[i].copyWith(stops: updatedStops);
        return _pendingTrips[i];
      }
    }

    throw Exception('Viaje no encontrado');
  }
}
