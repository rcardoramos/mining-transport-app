import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/features/geolocation/data/datasources/geolocation_remote_data_source.dart';
import 'package:mining_transport_app/features/geolocation/domain/usecases/validate_stop_geofencing_usecase.dart';
import 'package:mining_transport_app/features/home/domain/entities/stop_entity.dart';

class MockGpsService extends Fake implements GpsService {
  @override
  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    if (startLatitude == endLatitude && startLongitude == endLongitude) {
      return 0.0;
    }
    return ((startLatitude - endLatitude).abs() + (startLongitude - endLongitude).abs()) * 100000;
  }
}

class MockAppLogger extends Fake implements AppLogger {
  @override
  void i(String message, [dynamic error, StackTrace? stackTrace]) {}
}

void main() {
  late MockGpsService mockGpsService;

  setUpAll(() {
    final locator = GetIt.instance;
    if (!locator.isRegistered<AppLogger>()) {
      locator.registerLazySingleton<AppLogger>(() => MockAppLogger());
    }
  });

  setUp(() {
    mockGpsService = MockGpsService();
  });

  group('ValidateStopGeofencingUseCase Tests', () {
    test('should return inRange=true if distance is less than allowedRadius', () {
      final useCase = ValidateStopGeofencingUseCase(mockGpsService);
      const stop = StopEntity(
        id: 'stop-1',
        name: 'Paradero A',
        latitude: -5.19449,
        longitude: -80.63282,
        allowedRadius: 100.0,
        sequenceOrder: 1,
      );

      final result = useCase.execute(
        userLatitude: -5.19449,
        userLongitude: -80.63282,
        stop: stop,
      );

      expect(result.inRange, true);
      expect(result.distanceInMetres, 0.0);
    });

    test('should return inRange=false if distance is greater than allowedRadius', () {
      final useCase = ValidateStopGeofencingUseCase(mockGpsService);
      const stop = StopEntity(
        id: 'stop-1',
        name: 'Paradero A',
        latitude: -5.19449,
        longitude: -80.63282,
        allowedRadius: 100.0,
        sequenceOrder: 1,
      );

      final result = useCase.execute(
        userLatitude: -5.19949,
        userLongitude: -80.63782,
        stop: stop,
      );

      expect(result.inRange, false);
      expect(result.distanceInMetres, greaterThan(100.0));
    });
  });

  group('ResolveNearestStopUseCase Tests', () {
    test('should return nearest stop details from remote datasource mock', () async {
      final mockDataSource = MockGeolocationRemoteDataSource();
      final model = await mockDataSource.resolveNearestStop(-5.19449, -80.63282);
      
      expect(model.nombre, 'Catacaos (Simulado)');
      expect(model.distanciaMetros, 12.5);
    });
  });
}
