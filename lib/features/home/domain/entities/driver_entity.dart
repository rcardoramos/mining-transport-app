import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_entity.freezed.dart';
part 'driver_entity.g.dart';

enum DriverStatus { active, onBreak, inactive }

@freezed
class DriverEntity with _$DriverEntity {
  const factory DriverEntity({
    required String id,
    required String name,
    required String code,
    required DriverStatus status,
    required int todayTripsCount,
    String? avatarUrl,
  }) = _DriverEntity;

  factory DriverEntity.fromJson(Map<String, dynamic> json) => _$DriverEntityFromJson(json);
}
