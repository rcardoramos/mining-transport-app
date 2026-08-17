import 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart';

export 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart'
    show CreatedTripResult, CreateTripCommand, CreateTripStopDetail;

/// Request DTO para POST /api/Viaje/Crear (Postman).
///
/// No incluye `estado` ni `fechaApertura` a propósito
/// (ver docs/architecture/create-trip-contract-gaps.md).
class CreateTripRequestDto {
  CreateTripRequestDto({
    required this.usuario,
    required this.token,
    required this.choferId,
    required this.busId,
    required this.rutaId,
    required this.servicioId,
    required this.horarioId,
    required this.fechaProgramado,
    required this.capacidad,
    required this.detalles,
  });

  final String usuario;
  final String token;
  final int choferId;
  final int busId;
  final int rutaId;
  final int servicioId;
  final int horarioId;
  final String fechaProgramado;
  final int capacidad;
  final List<Map<String, int>> detalles;

  factory CreateTripRequestDto.fromCommand({
    required String usuario,
    required String token,
    required CreateTripCommand command,
  }) {
    final scheduled = command.scheduledAt;
    final fechaProgramado =
        '${scheduled.year.toString().padLeft(4, '0')}-'
        '${scheduled.month.toString().padLeft(2, '0')}-'
        '${scheduled.day.toString().padLeft(2, '0')}T'
        '${scheduled.hour.toString().padLeft(2, '0')}:'
        '${scheduled.minute.toString().padLeft(2, '0')}:'
        '${scheduled.second.toString().padLeft(2, '0')}';

    return CreateTripRequestDto(
      usuario: usuario,
      token: token,
      choferId: command.choferId,
      busId: command.busId,
      rutaId: command.routeId,
      servicioId: command.serviceId,
      horarioId: command.scheduleId,
      fechaProgramado: fechaProgramado,
      capacidad: command.capacity,
      detalles: command.stopDetails
          .map((d) => {'paraderoId': d.paraderoId, 'orden': d.orden})
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'token': token,
        'choferId': choferId,
        'busId': busId,
        'rutaId': rutaId,
        'servicioId': servicioId,
        'horarioId': horarioId,
        'fechaProgramado': fechaProgramado,
        'capacidad': capacidad,
        'detalles': detalles,
        // estado / fechaApertura omitidos deliberadamente.
      };
}

class CreateTripResponseDto {
  CreateTripResponseDto({
    required this.viajeId,
    this.numero,
    this.estado,
  });

  final int viajeId;
  final String? numero;
  final String? estado;

  factory CreateTripResponseDto.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(
          '${json['ViajeId'] ?? json['viajeId'] ?? json['Id'] ?? ''}',
        ) ??
        0;
    return CreateTripResponseDto(
      viajeId: id,
      numero: json['Numero']?.toString() ?? json['numero']?.toString(),
      estado: json['Estado']?.toString() ?? json['estado']?.toString(),
    );
  }

  CreatedTripResult toDomain() => CreatedTripResult(
        viajeId: '$viajeId',
        numero: numero,
        estado: estado,
      );
}
