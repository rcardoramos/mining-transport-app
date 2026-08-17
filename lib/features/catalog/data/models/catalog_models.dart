import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';

/// DTOs / modelos de catálogo (capa data). Presentation no los consume.

class CatalogRouteModel {
  CatalogRouteModel({
    required this.id,
    required this.name,
    this.distanceKm,
  });

  final int id;
  final String name;
  final double? distanceKm;

  factory CatalogRouteModel.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse('${json['id'] ?? json['Id'] ?? json['RutaId'] ?? ''}') ?? 0;
    final name = '${json['nombre'] ?? json['Nombre'] ?? json['name'] ?? ''}'.trim();
    final distance = double.tryParse(
      '${json['distanciaKm'] ?? json['DistanciaKm'] ?? json['distanceKm'] ?? ''}',
    );
    return CatalogRouteModel(id: id, name: name, distanceKm: distance);
  }

  CatalogRoute toEntity() {
    String? origin;
    String? destination;
    final parts = name.split(RegExp(r'\s*/\s*'));
    if (parts.length >= 2) {
      origin = parts.first.trim();
      destination = parts.sublist(1).join(' / ').trim();
    }
    return CatalogRoute(
      id: id,
      name: name,
      distanceKm: distanceKm,
      origin: origin,
      destination: destination,
    );
  }
}

class CatalogServiceModel {
  CatalogServiceModel({required this.id, required this.name});

  final int id;
  final String name;

  factory CatalogServiceModel.fromJson(Map<String, dynamic> json) {
    return CatalogServiceModel(
      id: int.tryParse('${json['id'] ?? json['Id'] ?? json['ServicioId'] ?? ''}') ?? 0,
      name: '${json['nombre'] ?? json['Nombre'] ?? json['name'] ?? ''}'.trim(),
    );
  }

  CatalogService toEntity() => CatalogService(id: id, name: name);
}

class CatalogScheduleModel {
  CatalogScheduleModel({required this.id, required this.departureTime});

  final int id;
  final String departureTime;

  factory CatalogScheduleModel.fromJson(Map<String, dynamic> json) {
    final rawTime =
        '${json['horaSalida'] ?? json['HoraSalida'] ?? json['HoraInicio'] ?? json['horaInicio'] ?? json['departureTime'] ?? ''}'
            .trim();
    // Staging a veces manda "06:00" sin segundos.
    final departureTime = rawTime.length == 5 ? '$rawTime:00' : rawTime;
    return CatalogScheduleModel(
      id: int.tryParse('${json['id'] ?? json['Id'] ?? json['HorarioId'] ?? ''}') ?? 0,
      departureTime: departureTime,
    );
  }

  CatalogSchedule toEntity() =>
      CatalogSchedule(id: id, departureTime: departureTime);
}

class CatalogBusModel {
  CatalogBusModel({
    required this.id,
    required this.plate,
    required this.capacity,
    required this.model,
  });

  final int id;
  final String plate;
  final int capacity;
  final String model;

  factory CatalogBusModel.fromJson(Map<String, dynamic> json) {
    return CatalogBusModel(
      id: int.tryParse('${json['id'] ?? json['Id'] ?? json['BusId'] ?? ''}') ?? 0,
      plate: '${json['placa'] ?? json['Placa'] ?? json['plate'] ?? ''}'.trim(),
      capacity: int.tryParse(
            '${json['capacidad'] ?? json['Capacidad'] ?? json['capacity'] ?? 0}',
          ) ??
          0,
      // Staging envía "Marca"; Postman documentaba "modelo".
      model: '${json['Marca'] ?? json['marca'] ?? json['Modelo'] ?? json['modelo'] ?? json['model'] ?? ''}'
          .trim(),
    );
  }

  CatalogBus toEntity() =>
      CatalogBus(id: id, plate: plate, capacity: capacity, model: model);
}

class CatalogStopModel {
  CatalogStopModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.allowedRadiusMeters,
    required this.order,
    this.routeId,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double allowedRadiusMeters;
  final int order;
  final int? routeId;

  factory CatalogStopModel.fromJson(Map<String, dynamic> json) {
    final routeRaw = json['rutaId'] ?? json['RutaId'] ?? json['routeId'];
    return CatalogStopModel(
      id: int.tryParse(
            '${json['id'] ?? json['Id'] ?? json['ParaderoId'] ?? json['paraderoId'] ?? ''}',
          ) ??
          0,
      name: '${json['nombre'] ?? json['Nombre'] ?? json['name'] ?? ''}'.trim(),
      latitude: double.tryParse(
            '${json['latitud'] ?? json['Latitud'] ?? json['lat'] ?? 0}',
          ) ??
          0,
      longitude: double.tryParse(
            '${json['longitud'] ?? json['Longitud'] ?? json['lng'] ?? 0}',
          ) ??
          0,
      allowedRadiusMeters: double.tryParse(
            '${json['radioPermitido'] ?? json['RadioPermitido'] ?? 50}',
          ) ??
          50,
      order: int.tryParse('${json['orden'] ?? json['Orden'] ?? 0}') ?? 0,
      routeId: routeRaw == null ? null : int.tryParse('$routeRaw'),
    );
  }

  CatalogStop toEntity() => CatalogStop(
        id: id,
        name: name,
        latitude: latitude,
        longitude: longitude,
        allowedRadiusMeters: allowedRadiusMeters,
        order: order,
        routeId: routeId,
      );
}

class CatalogBootstrapModel {
  CatalogBootstrapModel({
    required this.routes,
    required this.services,
    required this.schedules,
    required this.buses,
    required this.stops,
  });

  final List<CatalogRouteModel> routes;
  final List<CatalogServiceModel> services;
  final List<CatalogScheduleModel> schedules;
  final List<CatalogBusModel> buses;
  final List<CatalogStopModel> stops;

  factory CatalogBootstrapModel.fromJson(Map<String, dynamic> data) {
    List<Map<String, dynamic>> asMaps(dynamic raw) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return CatalogBootstrapModel(
      routes: asMaps(data['Rutas'] ?? data['rutas'])
          .map(CatalogRouteModel.fromJson)
          .where((e) => e.id > 0)
          .toList(),
      services: asMaps(data['Servicios'] ?? data['servicios'])
          .map(CatalogServiceModel.fromJson)
          .where((e) => e.id > 0)
          .toList(),
      schedules: asMaps(data['Horarios'] ?? data['horarios'])
          .map(CatalogScheduleModel.fromJson)
          .where((e) => e.id > 0)
          .toList(),
      buses: asMaps(data['Buses'] ?? data['buses'])
          .map(CatalogBusModel.fromJson)
          .where((e) => e.id > 0)
          .toList(),
      stops: asMaps(data['Paraderos'] ?? data['paraderos'])
          .map(CatalogStopModel.fromJson)
          .where((e) => e.id > 0)
          .toList(),
    );
  }

  CatalogBundle toEntity() => CatalogBundle(
        routes: routes.map((e) => e.toEntity()).toList(),
        services: services.map((e) => e.toEntity()).toList(),
        schedules: schedules.map((e) => e.toEntity()).toList(),
        buses: buses.map((e) => e.toEntity()).toList(),
        stops: stops.map((e) => e.toEntity()).toList(),
      );
}
