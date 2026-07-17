import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:get_it/get_it.dart';

class MockAppLogger extends Fake implements AppLogger {
  @override
  void i(String message, [dynamic error, StackTrace? stackTrace]) {}
  @override
  void w(String message, [dynamic error, StackTrace? stackTrace]) {}
  @override
  void e(String message, [dynamic error, StackTrace? stackTrace]) {}
}

void main() {
  setUpAll(() {
    final locator = GetIt.instance;
    if (!locator.isRegistered<AppLogger>()) {
      locator.registerLazySingleton<AppLogger>(() => MockAppLogger());
    }
  });

  group('GpsService Tests', () {
    test('setSimulatedPosition should update accuracy and current position', () async {
      final gpsService = GpsService();
      
      // Initial default coordinates
      expect(gpsService.currentPosition.latitude, -12.046374);
      expect(gpsService.currentPosition.longitude, -77.042793);
      expect(gpsService.currentPosition.accuracy, 5.0);

      // Set new coordinates with specific accuracy
      gpsService.setSimulatedPosition(-5.19449, -80.63282, 50.0);

      expect(gpsService.currentPosition.latitude, -5.19449);
      expect(gpsService.currentPosition.longitude, -80.63282);
      expect(gpsService.currentPosition.accuracy, 50.0);
    });

    test('calculateDistance should correctly compute distance', () {
      final gpsService = GpsService();
      
      // Calculate distance between two near points
      final distance = gpsService.calculateDistance(-5.19449, -80.63282, -5.19449, -80.63282);
      expect(distance, 0.0);
    });
  });
}
