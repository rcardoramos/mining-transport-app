import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';
import 'package:mining_transport_app/features/passenger/data/models/passenger_model.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';

class ManifestDto {
  ManifestDto({
    required this.passengers,
    this.route,
    this.plate,
    this.driverName,
    this.shift,
    this.service,
    this.estado,
  });

  final List<PassengerEntity> passengers;
  final String? route;
  final String? plate;
  final String? driverName;
  final String? shift;
  final String? service;
  final String? estado;

  factory ManifestDto.fromJson(Map<String, dynamic> data) {
    final cabeceraRaw = data['cabecera'] ?? data['Cabecera'] ?? data['header'];
    Map<String, dynamic> header = {};
    if (cabeceraRaw is Map) {
      header = Map<String, dynamic>.from(cabeceraRaw);
    }

    final pasajerosRaw = data['pasajeros'] ?? data['Pasajeros'] ?? data['passengers'];
    final list = <PassengerEntity>[];
    if (pasajerosRaw is List) {
      for (final item in pasajerosRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        list.add(PassengerModel.fromJson(map).toEntity());
      }
    }

    return ManifestDto(
      passengers: list,
      route: _str(header, const ['Ruta', 'ruta', 'NombreRuta', 'route']),
      plate: _str(header, const ['Placa', 'placa', 'Bus', 'bus', 'unitCode']),
      driverName: _str(header, const ['Chofer', 'chofer', 'Conductor', 'conductor', 'NombreChofer']),
      shift: _str(header, const ['Horario', 'horario', 'Turno', 'turno', 'shift']),
      service: _str(header, const ['Servicio', 'servicio', 'service']),
      estado: _str(header, const ['Estado', 'estado', 'status']) ??
          _str(data, const ['Estado', 'estado']),
    );
  }

  ManifestSnapshot toSnapshot(String tripId) => ManifestSnapshot(
        tripId: tripId,
        passengers: passengers,
        headerRoute: route,
        headerPlate: plate,
        headerDriverName: driverName,
        headerShift: shift,
        headerService: service,
        rawEstado: estado,
        source: ManifestDataSource.viajeManifiesto,
      );

  static String? _str(Map<String, dynamic> map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v != null && '$v'.trim().isNotEmpty) return '$v'.trim();
    }
    return null;
  }
}
