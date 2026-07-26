import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';
import '../../domain/entities/trip_entity.dart';
import 'stop_model.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
class TripModel with _$TripModel {
  const factory TripModel({
    required String id,
    required String route,
    required String scheduledTime,
    required String shift,
    required String unitCode,
    required int capacity,
    required int passengerCount,
    required String status,
    String? startedAt,
    String? completedAt,
    List<StopModel>? stops,
  }) = _TripModel;

  const TripModel._();

  factory TripModel.fromJson(Map<String, dynamic> json) {
    // 1. Parse ID (ViajeId or id)
    final idVal = json['id'] ?? json['Id'] ?? json['ViajeId'] ?? json['viajeId'] ?? '';
    final id = idVal.toString();

    // 2. Parse Route (Ruta or route or RutaNombre)
    final routeVal = json['route'] ?? json['Ruta'] ?? json['RutaNombre'] ?? json['ruta'] ?? 'Ruta Sin Nombre';
    final route = routeVal.toString();

    // 3. Parse Scheduled Time (scheduledTime or FechaServicio or FechaHoraProgramada or HoraSalida)
    final scheduledTimeVal = json['scheduledTime'] ?? json['FechaServicio'] ?? json['FechaHoraProgramada'] ?? json['fechaServicio'] ?? json['horaSalida'] ?? DateTime.now().toUtc().toIso8601String();
    final scheduledTime = scheduledTimeVal.toString();

    // 4. Parse Shift (shift or Turno or turno or Horario)
    final shiftVal = json['shift'] ?? json['Turno'] ?? json['turno'] ?? json['Horario'] ?? 'Día';
    final shift = shiftVal.toString();

    // 5. Parse Unit Code / Bus / Placa (unitCode or Placa or CodigoUnidad or unit_code)
    final unitCodeVal = json['unitCode'] ?? json['Placa'] ?? json['CodigoUnidad'] ?? json['unit_code'] ?? 'BUS-01';
    final unitCode = unitCodeVal.toString();

    // 6. Parse Capacity (capacity or Capacidad or CapacidadMax or capacidad)
    final capacityVal = json['capacity'] ?? json['Capacidad'] ?? json['CapacidadMax'] ?? json['capacidad'] ?? 40;
    final capacity = int.tryParse(capacityVal.toString()) ?? 40;

    // 7. Parse Passenger Count / Aforo (passengerCount or Pasajeros or AforoActual or pasajeros)
    final passengerCountVal = json['passengerCount'] ?? json['Pasajeros'] ?? json['AforoActual'] ?? json['pasajeros'] ?? 0;
    final passengerCount = int.tryParse(passengerCountVal.toString()) ?? 0;

    // 8. Parse Status (status or Estado or estado)
    final statusVal = json['status'] ?? json['Estado'] ?? json['estado'] ?? 'scheduled';
    final status = statusVal.toString();

    // 9. Parse startedAt and completedAt (startedAt / FechaInicio / FechaApertura, completedAt / FechaFin / FechaCierre)
    final startedAtVal = json['startedAt'] ?? json['FechaInicio'] ?? json['FechaApertura'] ?? json['started_at'];
    final startedAt = (startedAtVal == null || startedAtVal.toString().trim().toLowerCase() == 'null')
        ? null
        : startedAtVal.toString();

    final completedAtVal = json['completedAt'] ?? json['FechaFin'] ?? json['FechaCierre'] ?? json['completed_at'];
    final completedAt = (completedAtVal == null || completedAtVal.toString().trim().toLowerCase() == 'null')
        ? null
        : completedAtVal.toString();

    // 10. Parse stops (stops or ParaderosAutorizados or paraderos)
    final stopsJson = json['stops'] ?? json['ParaderosAutorizados'] ?? json['paraderos'];
    List<StopModel>? stops;
    if (stopsJson is List) {
      stops = stopsJson.map((e) => StopModel.fromJson(e as Map<String, dynamic>)).toList();
    }

    return TripModel(
      id: id,
      route: route,
      scheduledTime: scheduledTime,
      shift: shift,
      unitCode: unitCode,
      capacity: capacity,
      passengerCount: passengerCount,
      status: status,
      startedAt: startedAt,
      completedAt: completedAt,
      stops: stops,
    );
  }

  TripEntity toEntity() {
    final parsedStartedAt = PeruDateFormatter.parseFlexible(startedAt);
    final parsedCompletedAt = PeruDateFormatter.parseFlexible(completedAt);

    // Determine dynamic status
    TripStatus resolvedStatus = _parseTripStatus(status);
    if (resolvedStatus == TripStatus.scheduled || resolvedStatus == TripStatus.readyToStart) {
      if (parsedCompletedAt != null) {
        resolvedStatus = TripStatus.completed;
      } else if (parsedStartedAt != null) {
        resolvedStatus = TripStatus.inProgress;
      }
    }

    return TripEntity(
      id: id,
      route: route,
      scheduledTime: PeruDateFormatter.parseFlexible(scheduledTime) ?? DateTime.now(),
      shift: shift,
      unitCode: unitCode,
      capacity: capacity,
      passengerCount: passengerCount,
      status: resolvedStatus,
      startedAt: parsedStartedAt,
      completedAt: parsedCompletedAt,
      stops: stops?.map((s) => s.toEntity()).toList(),
    );
  }
}

TripStatus _parseTripStatus(String statusStr) {
  final clean = statusStr.trim().toUpperCase().replaceAll('_', '');
  if (clean == 'COMPLETED' || clean == 'FINALIZADO' || clean == 'C') {
    return TripStatus.completed;
  }
  if (clean == 'INPROGRESS' || clean == 'ENPROGRESS' || clean == 'EN_CURSO') {
    return TripStatus.inProgress;
  }
  if (clean == 'TRAVELLING' || clean == 'TRANSITO' || clean == 'ENTRANSITO') {
    return TripStatus.travelling;
  }
  if (clean == 'CANCELLED' || clean == 'CANCELADO') {
    return TripStatus.cancelled;
  }
  if (clean == 'READYTOSTART' || clean == 'PORINICIAR') {
    return TripStatus.readyToStart;
  }
  if (clean == 'SCHEDULED' || clean == 'PROGRAMADO' || clean == 'A') {
    return TripStatus.scheduled;
  }
  
  // Fallback to name match ignoring case and underscores
  return TripStatus.values.firstWhere(
    (e) => e.name.toUpperCase().replaceAll('_', '') == clean,
    orElse: () => TripStatus.scheduled,
  );
}
