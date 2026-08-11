import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import 'home_dashboard_remote_data_source.dart';
import '../models/driver_model.dart';
import '../models/trip_model.dart';
import '../models/dashboard_summary_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/passenger_model.dart';
import 'package:mining_transport_app/features/passenger/data/models/collaborator_model.dart';

/// Implementación real del [HomeDashboardRemoteDataSource] utilizando [DioClient]
/// para la integración con el backend en .NET.
class HomeDashboardRemoteDataSourceImpl implements HomeDashboardRemoteDataSource {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  /// Caché del catálogo maestro de paraderos (ParaderoId real del backend).
  /// Viaje/Obtener a veces envía un `id` de relación distinto al ParaderoId de catálogo;
  /// Registrar con ese id inventado provoca HTTP 500.
  List<_CatalogParadero>? _paraderoCatalog;

  HomeDashboardRemoteDataSourceImpl(this._dioClient, this._secureStorage);

  @override
  Future<DriverModel> getDriverInfo() async {
    final username = await _secureStorage.getUsername() ?? 'Chofer';
    // Nota: Si el backend tiene un endpoint de perfil de conductor se puede invocar aquí.
    // De lo contrario, se reconstruye a partir de la sesión local.
    return DriverModel(
      id: 'DRV-998',
      name: username,
      code: 'COD-48102',
      status: 'active',
      todayTripsCount: 0,
    );
  }

  @override
  Future<List<TripModel>> getTodayTrips() async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Historial',
      data: {
        'usuario': username,
        'token': token,
        'estado': null,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final list = wrapped['Data'] as List<dynamic>;
    final allTrips = list.map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList();

    // Diagnostic logs to debug backend state
    for (final t in allTrips) {
      print('DIAGNOSTIC - Trip ID: ${t.id}, Route: ${t.route}, Status: ${t.status}, Scheduled: ${t.scheduledTime}, Started: ${t.startedAt}, Completed: ${t.completedAt}');
    }

    final nowPeru = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    return allTrips.where((trip) {
      final statusUpper = trip.status.trim().toUpperCase();
      final isTripActive = (statusUpper == 'A' || 
                           statusUpper == 'IN_PROGRESS' || 
                           statusUpper == 'INPROGRESS' || 
                           statusUpper == 'TRAVELLING' || 
                           statusUpper == 'TRANSITO') &&
                          trip.completedAt == null;
      if (isTripActive) return true;

      final tripDate = PeruDateFormatter.parseFlexible(trip.scheduledTime);
      if (tripDate == null) return false;
      final tripPeru = tripDate.toUtc().subtract(const Duration(hours: 5));
      return tripPeru.year == nowPeru.year &&
             tripPeru.month == nowPeru.month &&
             tripPeru.day == nowPeru.day;
    }).toList();
  }

  @override
  Future<List<TripModel>> getPendingTrips() async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Historial',
      data: {
        'usuario': username,
        'token': token,
        'estado': null,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final list = wrapped['Data'] as List<dynamic>;
    final allTrips = list.map((item) => TripModel.fromJson(item as Map<String, dynamic>)).toList();

    final nowPeru = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    final todayEnd = DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day, 23, 59, 59).add(const Duration(hours: 5));
    return allTrips.where((trip) {
      final tripDate = PeruDateFormatter.parseFlexible(trip.scheduledTime);
      if (tripDate == null) return false;
      final statusUpper = trip.status.trim().toUpperCase();
      return tripDate.isAfter(todayEnd) && statusUpper != 'COMPLETED' && statusUpper != 'CANCELLED';
    }).toList();
  }

  @override
  Future<DashboardSummaryModel> getDashboardSummary() async {
    // Retorna datos calculados o llama a un endpoint centralizado si el backend lo expone.
    return const DashboardSummaryModel(
      completedTrips: 0,
      passengersTransported: 0,
      observationsRegistered: 0,
    );
  }

  @override
  Future<TripModel> updateTripStatus(String id, String status) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';
    final normalized = status.trim().toLowerCase();

    if (normalized == 'completed') {
      return _closeTripRemote(id: id, username: username, token: token);
    }

    if (normalized == 'travelling' || normalized == 'transito' || normalized == 'en_transito') {
      // "Iniciar viaje" es un estado local de tránsito: no volver a llamar Aperturar
      // (el viaje ya fue aperturado). Re-aperturar con payload incompleto deja el
      // viaje en un estado que luego hace fallar Viaje/Cerrar en el backend.
      return TripModel(
        id: id,
        route: '',
        scheduledTime: DateTime.now().toIso8601String(),
        shift: '',
        unitCode: '',
        capacity: 40,
        passengerCount: 0,
        status: 'TRAVELLING',
        startedAt: DateTime.now().toIso8601String(),
      );
    }

    // Aperturar viaje (inProgress / scheduled → activo)
    final response = await _dioClient.dio.post(
      'api/Viaje/Aperturar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(id) ?? 1,
      },
    );
    final wrapped = response.data as Map<String, dynamic>;
    if (wrapped['Success'] == false) {
      final message = (wrapped['Message'] ?? wrapped['message'] ?? 'Error al aperturar el viaje.').toString();
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }
    return _tripFromCloseOrOpenData(id, wrapped['Data'], fallbackStatus: 'A');
  }

  Future<TripModel> _closeTripRemote({
    required String id,
    required String username,
    required String token,
  }) async {
    double lat = 0.0;
    double lng = 0.0;
    String? stopName;
    int? requestedParaderoId;

    try {
      final detailResponse = await _dioClient.dio.post(
        'api/Viaje/Obtener',
        data: {
          'usuario': username,
          'token': token,
          'viajeId': int.tryParse(id) ?? 1,
        },
      );
      final detailWrapped = detailResponse.data as Map<String, dynamic>;
      final detailData = detailWrapped['Data'];
      if (detailData is Map<String, dynamic>) {
        final stops = detailData['ParaderosAutorizados'] ?? detailData['paraderos'];
        if (stops is List && stops.isNotEmpty) {
          final sorted = [...stops.whereType<Map>()];
          sorted.sort((a, b) {
            final oa = int.tryParse('${a['orden'] ?? a['Orden'] ?? 0}') ?? 0;
            final ob = int.tryParse('${b['orden'] ?? b['Orden'] ?? 0}') ?? 0;
            return oa.compareTo(ob);
          });
          final last = Map<String, dynamic>.from(sorted.last);
          requestedParaderoId = int.tryParse('${last['id'] ?? last['Id'] ?? last['paraderoId'] ?? last['ParaderoId'] ?? ''}');
          stopName = '${last['nombre'] ?? last['Nombre'] ?? ''}'.trim();
          lat = double.tryParse('${last['latitud'] ?? last['Latitud'] ?? 0}') ?? 0;
          lng = double.tryParse('${last['longitud'] ?? last['Longitud'] ?? 0}') ?? 0;
        }
      }
    } catch (_) {
      // Si falla el detalle, seguimos con resolución por catálogo/GPS.
    }

    // Solo usar GPS si no hay coordenadas del paradero de cierre.
    // GpsService por defecto simula Lima; sobrescribir el paradero real provoca HTTP 500.
    if (lat == 0.0 && lng == 0.0) {
      try {
        if (GetIt.I.isRegistered<GpsService>()) {
          final pos = GetIt.I<GpsService>().currentPosition;
          if (pos.latitude != 0.0 || pos.longitude != 0.0) {
            lat = pos.latitude;
            lng = pos.longitude;
          }
        }
      } catch (_) {}
    }

    final paraderoCierreId = await _resolveCatalogParaderoId(
      requestedId: requestedParaderoId,
      name: stopName,
      lat: lat,
      lng: lng,
    );

    // Contrato observado en staging: además de paradero/coords, el backend
    // acepta odometroFinal (Postman no lo documenta, pero cierra el viaje).
    final response = await _dioClient.dio.post(
      'api/Viaje/Cerrar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(id) ?? 1,
        'paraderoCierreId': paraderoCierreId,
        'odometroFinal': 0,
        'lat': lat,
        'lng': lng,
      },
    );
    final wrapped = response.data as Map<String, dynamic>;
    if (wrapped['Success'] == false) {
      final message = (wrapped['Message'] ?? wrapped['message'] ?? 'Ocurrió un error al cerrar el viaje.').toString();
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }

    return _tripFromCloseOrOpenData(id, wrapped['Data'], fallbackStatus: 'COMPLETED');
  }

  TripModel _tripFromCloseOrOpenData(
    String id,
    dynamic rawData, {
    required String fallbackStatus,
  }) {
    if (rawData is Map<String, dynamic>) {
      // Algunos endpoints solo devuelven { ViajeId }.
      if (rawData.containsKey('ViajeId') || rawData.containsKey('viajeId') || rawData.containsKey('id')) {
        try {
          return TripModel.fromJson(rawData);
        } catch (_) {
          // Continuar con modelo mínimo.
        }
      }
    }
    return TripModel(
      id: id,
      route: '',
      scheduledTime: DateTime.now().toIso8601String(),
      shift: '',
      unitCode: '',
      capacity: 40,
      passengerCount: 0,
      status: fallbackStatus,
      completedAt: fallbackStatus.toUpperCase().contains('COMPLETE')
          ? DateTime.now().toIso8601String()
          : null,
    );
  }

  @override
  Future<TripModel> registerPassenger(
    String id,
    String dni, [
    String? status,
    String? category,
    String? registrationMethod,
    double? lat,
    double? lng,
    String? justification,
    String? uidCliente,
    String? nombreCompleto,
    String? empresa,
    int? paraderoId,
    String? lugarSubida,
    String? puesto,
    String? unidad,
  ]) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final isVisita = category == 'Visita' || registrationMethod == 'visit';
    final endpoint = isVisita ? 'api/Pasajero/RegistrarVisita' : 'api/Pasajero/Registrar';

    final mappedStatus = (status == null)
        ? 'OK'
        : (status.toLowerCase() == 'ok'
            ? 'OK'
            : (status.toLowerCase() == 'vacation'
                ? 'VACACIONES'
                : (status.toLowerCase() == 'medicalleave'
                    ? 'DESCANSO_MEDICO'
                    : (status.toLowerCase() == 'license'
                        ? 'LICENCIA'
                        : (status.toLowerCase() == 'terminated'
                            ? 'CESADO'
                            : status.toUpperCase())))));

    // Generar client UID único si no se provee
    final clientUid = uidCliente ?? const Uuid().v4();

    // Mapear nombres y empresas reales.
    // Validar suele devolver Empresa como código ("01") o vacío; Registrar espera el nombre.
    final finalName = nombreCompleto ?? (isVisita ? 'VISITANTE EXTERNO' : 'COLABORADOR REGULAR');
    final finalCompany = _normalizeEmpresa(empresa, isVisita: isVisita);

    // Mapear puesto y unidad por defecto si es colaborador y vienen vacíos
    final finalPuesto = isVisita ? null : (puesto?.trim().isNotEmpty == true ? puesto : 'Operario de Planta');
    final finalUnidad = isVisita ? null : (unidad?.trim().isNotEmpty == true ? unidad : 'Fosfatos');

    final resolvedParaderoId = await _resolveCatalogParaderoId(
      requestedId: paraderoId,
      name: lugarSubida,
      lat: lat,
      lng: lng,
    );

    final body = <String, dynamic>{
      'usuario': username,
      'token': token,
      'viajeId': int.tryParse(id) ?? 1,
      'dni': dni,
      'uidCliente': clientUid,
      // No inventar codigoUnico (ej. EMP-{dni}): el backend responde HTTP 500.
      // Si Validar llega a exponer el código real, se podrá reenviar aquí.
      'nombreCompleto': finalName,
      'empresa': finalCompany,
      'tipoPasajero': isVisita ? 'VISITA' : 'MISKI_MAYO',
      'estadoLaboral': mappedStatus,
      'resultado': justification != null ? 'EXCEPCION' : 'ABORDO',
      'observacion': justification,
      'paraderoId': resolvedParaderoId,
      'lugarSubida': lugarSubida ?? '',
      'lat': lat ?? 0.0,
      'lng': lng ?? 0.0,
    };

    if (finalPuesto != null) {
      body['puesto'] = finalPuesto;
    }
    if (finalUnidad != null) {
      body['unidad'] = finalUnidad;
    }

    if (isVisita) {
      body['motivoVisita'] = 'Inspección';
      body['autorizadoPor'] = 'Supervisor';
    }

    final response = await _dioClient.dio.post(endpoint, data: body);
    final wrapped = response.data as Map<String, dynamic>;

    if (wrapped['Success'] == false) {
      final message = (wrapped['Message'] ?? wrapped['message'] ?? 'Ocurrió un error al registrar el pasajero.').toString();
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }

    // El backend no devuelve un objeto Viaje (TripModel) completo, sino un resumen de aforo:
    // { Success: true, Message: "OK", Data: { Mensaje: "OK", Capacidad: 25, Ocupados: 1, ... } }
    final rawData = wrapped['Data'];
    final dataMap = rawData is Map<String, dynamic> ? rawData : <String, dynamic>{};
    final ocupados = int.tryParse('${dataMap['Ocupados'] ?? dataMap['ocupados'] ?? 0}') ?? 0;
    final capacidad = int.tryParse('${dataMap['Capacidad'] ?? dataMap['capacidad'] ?? 25}') ?? 25;

    return TripModel(
      id: id,
      route: '',
      scheduledTime: DateTime.now().toIso8601String(),
      shift: '',
      unitCode: '',
      capacity: capacidad,
      passengerCount: ocupados,
      status: 'A',
    );
  }

  /// Normaliza el campo Empresa de Validar al valor que espera Registrar.
  static String _normalizeEmpresa(String? empresa, {required bool isVisita}) {
    final raw = (empresa ?? '').trim();
    if (raw.isEmpty) {
      return isVisita ? 'Terceros' : 'MISKI MAYO';
    }
    // Códigos corporativos frecuentes en Validar
    if (raw == '01' || raw == '1') return 'MISKI MAYO';
    if (RegExp(r'^\d+$').hasMatch(raw)) return 'MISKI MAYO';
    return raw;
  }

  Future<void> _ensureParaderoCatalog() async {
    if (_paraderoCatalog != null) return;

    try {
      final username = await _secureStorage.getUsername() ?? '';
      final token = await _secureStorage.getToken() ?? '';
      final response = await _dioClient.dio.post(
        'api/Catalogo/Bootstrap',
        data: {
          'usuario': username,
          'token': token,
        },
      );
      final wrapped = response.data as Map<String, dynamic>;
      final data = wrapped['Data'];
      final list = data is Map<String, dynamic>
          ? (data['Paraderos'] as List<dynamic>? ?? const [])
          : const <dynamic>[];

      _paraderoCatalog = list
          .whereType<Map>()
          .map((raw) {
            final map = Map<String, dynamic>.from(raw);
            final id = int.tryParse('${map['ParaderoId'] ?? map['paraderoId'] ?? map['id'] ?? ''}');
            if (id == null) return null;
            return _CatalogParadero(
              id: id,
              name: '${map['Nombre'] ?? map['nombre'] ?? ''}'.trim(),
              lat: double.tryParse('${map['Latitud'] ?? map['latitud'] ?? 0}') ?? 0,
              lng: double.tryParse('${map['Longitud'] ?? map['longitud'] ?? 0}') ?? 0,
            );
          })
          .whereType<_CatalogParadero>()
          .toList();
    } catch (_) {
      _paraderoCatalog = const [];
    }
  }

  /// Resuelve el ParaderoId real del catálogo.
  ///
  /// `Viaje/Obtener.ParaderosAutorizados[].id` puede ser un id de relación
  /// (ej. 11) distinto al ParaderoId maestro (ej. 5 = PARADERO TEST1).
  Future<int> _resolveCatalogParaderoId({
    int? requestedId,
    String? name,
    double? lat,
    double? lng,
  }) async {
    await _ensureParaderoCatalog();
    final catalog = _paraderoCatalog ?? const <_CatalogParadero>[];
    if (catalog.isEmpty) {
      return requestedId ?? 1;
    }

    if (requestedId != null && catalog.any((p) => p.id == requestedId)) {
      return requestedId;
    }

    final normalizedName = (name ?? '').trim().toLowerCase();
    if (normalizedName.isNotEmpty) {
      final byName = catalog.where((p) => p.name.toLowerCase() == normalizedName);
      if (byName.isNotEmpty) return byName.first.id;

      final byContains = catalog.where(
        (p) =>
            p.name.toLowerCase().contains(normalizedName) ||
            normalizedName.contains(p.name.toLowerCase()),
      );
      if (byContains.isNotEmpty) return byContains.first.id;
    }

    if (lat != null && lng != null && (lat != 0.0 || lng != 0.0)) {
      _CatalogParadero? nearest;
      var bestDistance = double.infinity;
      for (final p in catalog) {
        final dLat = p.lat - lat;
        final dLng = p.lng - lng;
        final distance = dLat * dLat + dLng * dLng;
        if (distance < bestDistance) {
          bestDistance = distance;
          nearest = p;
        }
      }
      if (nearest != null) return nearest.id;
    }

    return requestedId ?? catalog.first.id;
  }

  @override
  Future<List<PassengerModel>> getPassengersOnBoard(String tripId) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Pasajero/Lista',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
        'buscar': null,
        'filtro': 'TODOS',
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    final list = wrapped['Data'] as List<dynamic>;
    return list.map((item) => PassengerModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  @override
  Future<CollaboratorModel> checkCollaborator(String dni) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';
    final identifier = dni.trim();
    final isDni = RegExp(r'^\d{8}$').hasMatch(identifier);

    // DNI: campo dni. Fotocheck (código de empleado): campo codigo del contrato API.
    final body = <String, dynamic>{
      'usuario': username,
      'token': token,
    };
    if (isDni) {
      body['dni'] = identifier;
    } else {
      body['codigo'] = identifier;
    }

    final response = await _dioClient.dio.post(
      'api/Pasajero/Validar',
      data: body,
    );

    final wrapped = response.data as Map<String, dynamic>;
    if (wrapped['Success'] == false) {
      throw Exception('not_found');
    }
    return CollaboratorModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }

  @override
  Future<TripModel> completeStop(String id, String stopId) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/CompletarParadero',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(id) ?? 1,
        'paraderoId': int.tryParse(stopId) ?? 1,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }
}

class _CatalogParadero {
  final int id;
  final String name;
  final double lat;
  final double lng;

  const _CatalogParadero({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });
}
