import 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart';

export 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart'
    show CreatedTripResult, CreateTripCommand, CreateTripStopDetail;

/// Request DTO para POST /api/Viaje/Crear (Postman).
///
/// Staging exige `estado` y `fechaApertura` ("campos obligatorios").
/// Se envía `estado: P` (programado / por iniciar) para mantener Aperturar aparte.
/// Postman documentaba `A` + apertura inmediata; eso se evita a propósito.
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
    required this.estado,
    required this.fechaApertura,
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
  final String estado;
  final String fechaApertura;

  factory CreateTripRequestDto.fromCommand({
    required String usuario,
    required String token,
    required CreateTripCommand command,
  }) {
    final scheduled = command.scheduledAt;
    final fechaProgramado = _formatDateTime(scheduled);

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
      // P = programado (Historial). Campo obligatorio en staging.
      estado: 'P',
      // El SP exige el campo; con estado P no implica viaje aperturado.
      fechaApertura: fechaProgramado,
    );
  }

  static String _formatDateTime(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}T'
        '${value.hour.toString().padLeft(2, '0')}:'
        '${value.minute.toString().padLeft(2, '0')}:'
        '${value.second.toString().padLeft(2, '0')}';
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
        'estado': estado,
        'fechaApertura': fechaApertura,
        'detalles': detalles,
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
