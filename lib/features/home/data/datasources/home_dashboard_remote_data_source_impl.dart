import 'package:uuid/uuid.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
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

    if (status == 'completed') {
      final response = await _dioClient.dio.post(
        'api/Viaje/Cerrar',
        data: {
          'usuario': username,
          'token': token,
          'viajeId': int.tryParse(id) ?? 1,
          'paraderoCierreId': 1,
          'lat': 0.0,
          'lng': 0.0,
        },
      );
      final wrapped = response.data as Map<String, dynamic>;
      return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
    } else {
      // Aperturar / Iniciar viaje en tránsito
      final response = await _dioClient.dio.post(
        'api/Viaje/Aperturar',
        data: {
          'usuario': username,
          'token': token,
          'viajeId': int.tryParse(id) ?? 1,
        },
      );
      final wrapped = response.data as Map<String, dynamic>;
      return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
    }
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

    // Mapear nombres y empresas reales
    final finalName = nombreCompleto ?? (isVisita ? 'VISITANTE EXTERNO' : 'COLABORADOR REGULAR');
    final finalCompany = empresa ?? (isVisita ? 'Terceros' : 'MISKI MAYO');

    final body = {
      'usuario': username,
      'token': token,
      'viajeId': int.tryParse(id) ?? 1,
      'uidCliente': clientUid,
      'codigoUnico': 'EMP-$dni',
      'dni': dni,
      'nombreCompleto': finalName,
      'empresa': finalCompany,
      'tipoPasajero': isVisita ? 'VISITA' : 'MISKI_MAYO',
      'estadoLaboral': mappedStatus,
      'resultado': justification != null ? 'EXCEPCION' : 'ABORDO',
      'observacion': justification,
      'paraderoId': paraderoId ?? 1,
      'lugarSubida': lugarSubida ?? '',
      'lat': lat ?? 0.0,
      'lng': lng ?? 0.0,
    };

    if (isVisita) {
      body['motivoVisita'] = 'Inspección';
      body['autorizadoPor'] = 'Supervisor';
    }

    final response = await _dioClient.dio.post(endpoint, data: body);
    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
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

    final response = await _dioClient.dio.post(
      'api/Pasajero/Validar',
      data: {
        'usuario': username,
        'token': token,
        'dni': dni,
      },
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
