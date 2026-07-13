import 'package:freezed_annotation/freezed_annotation.dart';
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

  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

  TripEntity toEntity() {
    return TripEntity(
      id: id,
      route: route,
      scheduledTime: DateTime.parse(scheduledTime),
      shift: shift,
      unitCode: unitCode,
      capacity: capacity,
      passengerCount: passengerCount,
      status: TripStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => TripStatus.scheduled,
      ),
      startedAt: startedAt != null ? DateTime.parse(startedAt!) : null,
      completedAt: completedAt != null ? DateTime.parse(completedAt!) : null,
      stops: stops?.map((s) => s.toEntity()).toList(),
    );
  }
}
