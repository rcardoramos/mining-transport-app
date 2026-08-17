import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/network/dio_client.dart';
import 'package:mining_transport_app/core/storage/secure_storage.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import 'package:mining_transport_app/features/home/data/models/trip_model.dart';
import 'package:mining_transport_app/features/trip/data/models/create_trip_dto.dart';
import 'trip_remote_data_source.dart';

/// Implementación real del [TripRemoteDataSource] que se comunica con
/// el backend corporativo en .NET a través de [DioClient].
class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  TripRemoteDataSourceImpl(this._dioClient, this._secureStorage);

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

    final nowPeru = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    return allTrips.where((trip) {
      final statusUpper = trip.status.trim().toUpperCase().replaceAll('_', '');
      final finished = _isTripFinished(trip);

      final isTripActive = !finished &&
          (statusUpper == 'A' ||
              statusUpper == 'INPROGRESS' ||
              statusUpper == 'TRAVELLING' ||
              statusUpper == 'TRANSITO' ||
              statusUpper == 'ENTRANSITO');
      if (isTripActive) return true;

      return _isSamePeruDay(PeruDateFormatter.parseFlexible(trip.scheduledTime), nowPeru) ||
          _isSamePeruDay(PeruDateFormatter.parseFlexible(trip.startedAt), nowPeru) ||
          (_isRealTimestamp(trip.completedAt) &&
              _isSamePeruDay(PeruDateFormatter.parseFlexible(trip.completedAt), nowPeru));
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
    final todayDay = DateTime.utc(nowPeru.year, nowPeru.month, nowPeru.day);

    return allTrips.where((trip) {
      // Solo estados cerrados/cancelados (Historial: "C"). No usar FechaCierre sola:
      // .NET a menudo envía 0001-01-01 y eso borraba los pendientes válidos.
      if (_isTripFinished(trip)) return false;

      final tripDate = PeruDateFormatter.parseFlexible(trip.scheduledTime);
      if (tripDate == null) return false;
      final tripPeru = tripDate.toUtc().subtract(const Duration(hours: 5));
      final tripDay = DateTime.utc(tripPeru.year, tripPeru.month, tripPeru.day);
      return tripDay.isAfter(todayDay);
    }).toList();
  }

  static bool _isTripFinished(TripModel trip) {
    final s = trip.status.trim().toUpperCase().replaceAll('_', '');
    return s == 'C' ||
        s == 'COMPLETED' ||
        s == 'FINALIZADO' ||
        s == 'CANCELLED' ||
        s == 'CANCELADO';
  }

  static bool _isRealTimestamp(String? raw) {
    if (raw == null) return false;
    final clean = raw.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'null') return false;
    final parsed = PeruDateFormatter.parseFlexible(clean);
    return parsed != null && parsed.year >= 2000;
  }

  static bool _isSamePeruDay(DateTime? date, DateTime nowPeru) {
    if (date == null) return false;
    final peru = date.toUtc().subtract(const Duration(hours: 5));
    return peru.year == nowPeru.year &&
        peru.month == nowPeru.month &&
        peru.day == nowPeru.day;
  }

  @override
  Future<TripModel> openTrip({required String tripId, required int startKm}) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Aperturar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
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
    return _tripFromSparseData(tripId, wrapped['Data'], fallbackStatus: 'A');
  }

  @override
  Future<TripModel> closeTrip({required String tripId, required int endKm}) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

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
          'viajeId': int.tryParse(tripId) ?? 1,
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
    } catch (_) {}

    // Resolver ParaderoId de catálogo (mismo criterio que embarque/cierre home).
    int paraderoCierreId = requestedParaderoId ?? 1;
    try {
      final catalogResponse = await _dioClient.dio.post(
        'api/Catalogo/Bootstrap',
        data: {
          'usuario': username,
          'token': token,
        },
      );
      final catalogData = catalogResponse.data is Map ? (catalogResponse.data as Map)['Data'] : null;
      final list = catalogData is Map
          ? (catalogData['Paraderos'] ?? catalogData['paraderos'])
          : null;
      if (list is List) {
        final paraderos = list.whereType<Map>().map((p) {
          final id = int.tryParse('${p['ParaderoId'] ?? p['paraderoId'] ?? p['id'] ?? p['Id'] ?? ''}');
          final name = '${p['Nombre'] ?? p['nombre'] ?? p['Name'] ?? p['name'] ?? ''}'.trim();
          final pLat = double.tryParse('${p['Latitud'] ?? p['latitud'] ?? p['lat'] ?? 0}') ?? 0.0;
          final pLng = double.tryParse('${p['Longitud'] ?? p['longitud'] ?? p['lng'] ?? 0}') ?? 0.0;
          if (id == null) return null;
          return (id: id, name: name, lat: pLat, lng: pLng);
        }).whereType<({int id, String name, double lat, double lng})>().toList();

        if (paraderos.isNotEmpty) {
          final requested = requestedParaderoId;
          if (requested != null && paraderos.any((p) => p.id == requested)) {
            paraderoCierreId = requested;
          } else {
            final normalized = (stopName ?? '').toLowerCase();
            final byName = paraderos.where((p) => p.name.toLowerCase() == normalized);
            if (byName.isNotEmpty) {
              paraderoCierreId = byName.first.id;
            } else if (lat != 0.0 || lng != 0.0) {
              var best = paraderos.first;
              var bestD = double.infinity;
              for (final p in paraderos) {
                final d = (p.lat - lat) * (p.lat - lat) + (p.lng - lng) * (p.lng - lng);
                if (d < bestD) {
                  bestD = d;
                  best = p;
                }
              }
              paraderoCierreId = best.id;
            } else {
              paraderoCierreId = paraderos.first.id;
            }
          }
        }
      }
    } catch (_) {}

    final response = await _dioClient.dio.post(
      'api/Viaje/Cerrar',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
        'paraderoCierreId': paraderoCierreId,
        'odometroFinal': endKm,
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
    return _tripFromSparseData(tripId, wrapped['Data'], fallbackStatus: 'COMPLETED');
  }

  TripModel _tripFromSparseData(
    String id,
    dynamic rawData, {
    required String fallbackStatus,
  }) {
    if (rawData is Map<String, dynamic>) {
      try {
        return TripModel.fromJson(rawData);
      } catch (_) {}
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
  Future<TripModel> getTripDetail(String tripId) async {
    final username = await _secureStorage.getUsername() ?? '';
    final token = await _secureStorage.getToken() ?? '';

    final response = await _dioClient.dio.post(
      'api/Viaje/Obtener',
      data: {
        'usuario': username,
        'token': token,
        'viajeId': int.tryParse(tripId) ?? 1,
      },
    );

    final wrapped = response.data as Map<String, dynamic>;
    return TripModel.fromJson(wrapped['Data'] as Map<String, dynamic>);
  }

  @override
  Future<CreateTripResponseDto> createTrip(CreateTripRequestDto request) async {
    final response = await _dioClient.dio.post(
      'api/Viaje/Crear',
      data: request.toJson(),
    );

    final wrapped = response.data as Map<String, dynamic>;
    if (wrapped['Success'] != true) {
      final message = (wrapped['Message'] ??
              wrapped['message'] ??
              'No pudimos crear el viaje. Inténtelo nuevamente.')
          .toString();
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: message,
      );
    }

    final data = wrapped['Data'];
    if (data is Map<String, dynamic>) {
      return CreateTripResponseDto.fromJson(data);
    }
    // Algunos SP solo confirman Success sin Data detallada.
    return CreateTripResponseDto(viajeId: 0);
  }
}
