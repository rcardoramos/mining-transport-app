import 'package:mining_transport_app/features/occupancy/domain/entities/occupancy_status.dart';

class ValidateOccupancyUseCase {
  OccupancyStatus execute({required int currentCount, required int capacity}) {
    final remaining = capacity - currentCount;
    final isFull = currentCount >= capacity;
    final isExceeded = currentCount > capacity;
    final percentage = capacity > 0 ? (currentCount / capacity).clamp(0.0, 1.0) : 0.0;

    return OccupancyStatus(
      currentCount: currentCount,
      capacity: capacity,
      isFull: isFull,
      isExceeded: isExceeded,
      remainingSeats: remaining < 0 ? 0 : remaining,
      percentage: percentage,
    );
  }
}
