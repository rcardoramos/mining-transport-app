import 'package:freezed_annotation/freezed_annotation.dart';
import 'stop_entity.dart';

part 'trip_entity.freezed.dart';
part 'trip_entity.g.dart';

/// Estatus del viaje alineado a las reglas del negocio de transporte minero.
/// Estados del viaje alineados al flujo de negocio de transporte minero.
/// scheduled    → Programado (aún no es hora)
/// readyToStart → Por iniciar (listo para aperturar)
/// inProgress   → Embarque en curso (pasajeros abordando)
/// travelling   → Viaje iniciado (bus en tránsito, embarque cerrado)
/// completed    → Finalizado
/// cancelled    → Cancelado
enum TripStatus { scheduled, readyToStart, inProgress, travelling, completed, cancelled }

@freezed
class TripEntity with _$TripEntity {
  const factory TripEntity({
    required String id,
    required String route,
    required DateTime scheduledTime,
    required String shift,
    required String unitCode,
    required int capacity,
    required int passengerCount,
    required TripStatus status,
    DateTime? startedAt,
    DateTime? completedAt,
    List<StopEntity>? stops,
  }) = _TripEntity;

  factory TripEntity.fromJson(Map<String, dynamic> json) => _$TripEntityFromJson(json);
}

/// Orden operativo en Home: abiertos → pendientes → cerrados.
/// Dentro de cada grupo, por hora programada ascendente.
List<TripEntity> sortTripsByOperationalStatus(List<TripEntity> trips) {
  int priority(TripStatus status) {
    switch (status) {
      case TripStatus.inProgress:
      case TripStatus.travelling:
        return 0;
      case TripStatus.scheduled:
      case TripStatus.readyToStart:
        return 1;
      case TripStatus.completed:
      case TripStatus.cancelled:
        return 2;
    }
  }

  final sorted = [...trips];
  sorted.sort((a, b) {
    final byStatus = priority(a.status).compareTo(priority(b.status));
    if (byStatus != 0) return byStatus;
    return a.scheduledTime.compareTo(b.scheduledTime);
  });
  return sorted;
}
