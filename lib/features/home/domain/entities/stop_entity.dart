import 'package:freezed_annotation/freezed_annotation.dart';

part 'stop_entity.freezed.dart';
part 'stop_entity.g.dart';

@freezed
class StopEntity with _$StopEntity {
  const factory StopEntity({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required double allowedRadius,
    required int sequenceOrder,
    @Default(false) bool isCompleted,
  }) = _StopEntity;

  factory StopEntity.fromJson(Map<String, dynamic> json) => _$StopEntityFromJson(json);
}
