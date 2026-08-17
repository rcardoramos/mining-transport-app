/// Command de dominio para crear un viaje (no objetos de UI).
class CreateTripCommand {
  const CreateTripCommand({
    required this.routeId,
    required this.serviceId,
    required this.scheduleId,
    required this.busId,
    required this.capacity,
    required this.scheduledAt,
    required this.choferId,
    required this.stopDetails,
  });

  final int routeId;
  final int serviceId;
  final int scheduleId;
  final int busId;
  final int capacity;
  final DateTime scheduledAt;

  /// Debe venir de un resolver de contrato, no de asunciones UI.
  final int choferId;

  final List<CreateTripStopDetail> stopDetails;
}

class CreateTripStopDetail {
  const CreateTripStopDetail({
    required this.paraderoId,
    required this.orden,
  });

  final int paraderoId;
  final int orden;
}

/// Resultado tipado de creación (mapeado desde Data).
class CreatedTripResult {
  const CreatedTripResult({
    required this.viajeId,
    this.numero,
    this.estado,
  });

  final String viajeId;
  final String? numero;
  final String? estado;
}
