import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_entity.freezed.dart';
part 'trip_entity.g.dart';

enum TripStatus { pending, active, paused, completed }

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
  }) = _TripEntity;

  factory TripEntity.fromJson(Map<String, dynamic> json) => _$TripEntityFromJson(json);
}
