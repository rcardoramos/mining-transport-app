// Entidades de catálogo alineadas a Bootstrap / Catalogo/* (Postman).

class CatalogRoute {
  const CatalogRoute({
    required this.id,
    required this.name,
    this.distanceKm,
    this.origin,
    this.destination,
  });

  final int id;
  final String name;
  final double? distanceKm;
  final String? origin;
  final String? destination;

  /// Visual: "Piura → Bayóvar" a partir de "Piura / Bayovar".
  String get displayLabel {
    if (origin != null &&
        origin!.isNotEmpty &&
        destination != null &&
        destination!.isNotEmpty) {
      return '$origin → $destination';
    }
    final parts = name.split(RegExp(r'\s*/\s*'));
    if (parts.length >= 2) {
      return '${parts.first.trim()} → ${parts.sublist(1).join(' / ').trim()}';
    }
    return name;
  }
}

class CatalogService {
  const CatalogService({required this.id, required this.name});

  final int id;
  final String name;
}

class CatalogSchedule {
  const CatalogSchedule({required this.id, required this.departureTime});

  final int id;

  /// Hora cruda del API, p. ej. "06:00:00".
  final String departureTime;

  String get timeHhMm {
    final parts = departureTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return departureTime;
  }

  String get displayLabel {
    final hh = int.tryParse(departureTime.split(':').first) ?? -1;
    String shift;
    if (hh >= 5 && hh < 12) {
      shift = 'Mañana';
    } else if (hh >= 12 && hh < 18) {
      shift = 'Tarde';
    } else if (hh >= 0) {
      shift = 'Noche';
    } else {
      shift = 'Horario';
    }
    return '$shift · $timeHhMm';
  }

  /// Combina fecha de servicio (día calendario) con horaSalida.
  DateTime scheduledDateTimeOn(DateTime serviceDay) {
    final parts = departureTime.split(':');
    final h = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final s = parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0;
    return DateTime(serviceDay.year, serviceDay.month, serviceDay.day, h, m, s);
  }
}

class CatalogBus {
  const CatalogBus({
    required this.id,
    required this.plate,
    required this.capacity,
    required this.model,
  });

  final int id;
  final String plate;
  final int capacity;
  final String model;
}

class CatalogStop {
  const CatalogStop({
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
}

class CatalogBundle {
  const CatalogBundle({
    required this.routes,
    required this.services,
    required this.schedules,
    required this.buses,
    required this.stops,
  });

  final List<CatalogRoute> routes;
  final List<CatalogService> services;
  final List<CatalogSchedule> schedules;
  final List<CatalogBus> buses;
  final List<CatalogStop> stops;

  bool get isEmpty =>
      routes.isEmpty &&
      services.isEmpty &&
      schedules.isEmpty &&
      buses.isEmpty;
}
