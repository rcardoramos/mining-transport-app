import 'package:freezed_annotation/freezed_annotation.dart';

part 'occupancy_status.freezed.dart';

@freezed
class OccupancyStatus with _$OccupancyStatus {
  const factory OccupancyStatus({
    required int currentCount,
    required int capacity,
    required bool isFull,
    required bool isExceeded,
    required int remainingSeats,
    required double percentage,
  }) = _OccupancyStatus;
}
