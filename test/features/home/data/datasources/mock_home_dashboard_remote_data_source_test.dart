import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/features/home/data/datasources/mock_home_dashboard_remote_data_source.dart';

void main() {
  late MockHomeDashboardRemoteDataSource dataSource;

  setUp(() {
    dataSource = MockHomeDashboardRemoteDataSource();
  });

  group('MockHomeDashboardRemoteDataSource', () {
    test('registerPassenger should throw Exception when DNI is duplicate', () async {
      final tripId = 'TRIP-101';
      final dni = '48102030';

      // First registration should succeed
      final trip = await dataSource.registerPassenger(tripId, dni);
      expect(trip.passengerCount, 16);

      // Second registration of same DNI should fail with Exception
      expect(
        () => dataSource.registerPassenger(tripId, dni),
        throwsException,
      );
    });

    test('registerPassenger should throw Exception when capacity is exceeded', () async {
      final tripId = 'TRIP-101';
      
      // Capacity of TRIP-101 is 40. Initial passengerCount is 15.
      // We fill the remaining 25 spots.
      for (int i = 0; i < 25; i++) {
        final uniqueDni = '900000${i.toString().padLeft(2, '0')}';
        await dataSource.registerPassenger(tripId, uniqueDni);
      }

      // 41st passenger should fail
      expect(
        () => dataSource.registerPassenger(tripId, '90000099'),
        throwsException,
      );
    });
  });
}
