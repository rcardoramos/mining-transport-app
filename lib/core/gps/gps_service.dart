import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mining_transport_app/core/utils/logger.dart';

class GpsService {
  final _locationController = StreamController<Position>.broadcast();
  Position? _currentSimulatedPosition;
  bool _isSimulationMode = true; // Default to simulation mode to prevent crashes in windows emulator
  StreamSubscription<Position>? _realGpsSubscription;
  final _logger = GetIt.I<AppLogger>();

  GpsService() {
    // Start with a default mock position (near Paradero 1)
    _currentSimulatedPosition = _createMockPosition(-12.046374, -77.042793);
    _locationController.add(_currentSimulatedPosition!);
  }

  Stream<Position> get positionStream => _locationController.stream;

  Position get currentPosition => _currentSimulatedPosition ?? _createMockPosition(-12.046374, -77.042793);

  void setSimulatedPosition(double latitude, double longitude) {
    _isSimulationMode = true;
    _currentSimulatedPosition = _createMockPosition(latitude, longitude);
    _locationController.add(_currentSimulatedPosition!);
    _logger.i('GPS Simulation: Location set to $latitude, $longitude');
  }

  Future<bool> requestPermissions() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return false;
      }
      return true;
    } catch (e) {
      _logger.w('GPS: Error checking/requesting permission: $e. Falling back to simulation.');
      return false;
    }
  }

  Future<void> startTrackingRealGps() async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      _logger.w('GPS: Permission denied. Using simulated GPS.');
      return;
    }

    _isSimulationMode = false;
    await _realGpsSubscription?.cancel();
    try {
      _realGpsSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen(
        (Position position) {
          if (!_isSimulationMode) {
            _currentSimulatedPosition = position;
            _locationController.add(position);
          }
        },
        onError: (err) {
          _logger.e('GPS Error: $err. Falling back to simulation.');
          _isSimulationMode = true;
        },
      );
    } catch (e) {
      _logger.e('GPS: Exception starting geolocator: $e. Falling back to simulation.');
      _isSimulationMode = true;
    }
  }

  Future<void> stopTrackingRealGps() async {
    _isSimulationMode = true;
    await _realGpsSubscription?.cancel();
    _realGpsSubscription = null;
  }

  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    try {
      return Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    } catch (e) {
      return _fallbackDistance(startLatitude, startLongitude, endLatitude, endLongitude);
    }
  }

  double _fallbackDistance(double lat1, double lon1, double lat2, double lon2) {
    // Haversine calculation to calculate distance in meters
    final p = 0.017453292519943295; // math.pi / 180
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) * math.cos(lat2 * p) * (1 - math.cos((lon2 - lon1) * p)) / 2;
    return 12742000 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km = 6371000 m
  }

  Position _createMockPosition(double lat, double lng) {
    return Position(
      longitude: lng,
      latitude: lat,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }
}
