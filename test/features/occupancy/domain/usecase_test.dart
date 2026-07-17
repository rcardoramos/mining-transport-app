import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/features/occupancy/domain/usecases/validate_occupancy_usecase.dart';

void main() {
  group('ValidateOccupancyUseCase Tests', () {
    test('should calculate occupancy percentage and remaining seats correctly when partially full', () {
      final useCase = ValidateOccupancyUseCase();
      final status = useCase.execute(currentCount: 15, capacity: 40);

      expect(status.currentCount, 15);
      expect(status.capacity, 40);
      expect(status.isFull, false);
      expect(status.isExceeded, false);
      expect(status.remainingSeats, 25);
      expect(status.percentage, 0.375);
    });

    test('should calculate correct values when capacity is reached', () {
      final useCase = ValidateOccupancyUseCase();
      final status = useCase.execute(currentCount: 40, capacity: 40);

      expect(status.isFull, true);
      expect(status.isExceeded, false);
      expect(status.remainingSeats, 0);
      expect(status.percentage, 1.0);
    });

    test('should calculate correct values when capacity is exceeded', () {
      final useCase = ValidateOccupancyUseCase();
      final status = useCase.execute(currentCount: 41, capacity: 40);

      expect(status.isFull, true);
      expect(status.isExceeded, true);
      expect(status.remainingSeats, 0);
      expect(status.percentage, 1.0);
    });
  });
}
