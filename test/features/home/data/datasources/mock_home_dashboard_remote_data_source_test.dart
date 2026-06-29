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
    test('checkCollaborator should throw Exception when DNI starts with 9', () async {
      expect(
        () => dataSource.checkCollaborator('90001234'),
        throwsException,
      );
    });

    test('checkCollaborator should resolve categories correctly based on DNI suffixes', () async {
      // Ends with 7 -> Contratista
      final c7 = await dataSource.checkCollaborator('12345677');
      expect(c7.category, 'Contratista');

      // Ends with 8 -> Terceros
      final c8 = await dataSource.checkCollaborator('12345678');
      expect(c8.category, 'Terceros');

      // Ends with 9 -> Visita
      final c9 = await dataSource.checkCollaborator('12345679');
      expect(c9.category, 'Visita');

      // Ends with other (e.g. 0) -> Miski Mayo
      final c0 = await dataSource.checkCollaborator('12345670');
      expect(c0.category, 'Miski Mayo');
    });

    test('registerPassenger with custom category should use that category and set name gen', () async {
      final trip = await dataSource.registerPassenger('TRIP-101', '90001234', 'ok', 'Visita');
      final passengers = await dataSource.getPassengersOnBoard('TRIP-101');
      final registered = passengers.firstWhere((p) => p.dni == '90001234');
      expect(registered.category, 'Visita');
      expect(registered.fullName, 'Externo (Visita)');
    });
  });
}
