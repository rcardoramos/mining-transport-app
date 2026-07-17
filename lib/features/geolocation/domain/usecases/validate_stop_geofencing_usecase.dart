import 'package:mining_transport_app/core/gps/gps_service.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/geofencing_result.dart';
import 'package:mining_transport_app/features/home/domain/entities/stop_entity.dart';

class ValidateStopGeofencingUseCase {
  final GpsService _gpsService;

  ValidateStopGeofencingUseCase(this._gpsService);

  GeofencingResult execute({
    required double userLatitude,
    required double userLongitude,
    required StopEntity stop,
  }) {
    final distance = _gpsService.calculateDistance(
      userLatitude,
      userLongitude,
      stop.latitude,
      stop.longitude,
    );

    final inRange = distance <= stop.allowedRadius;

    return GeofencingResult(
      distanceInMetres: distance,
      inRange: inRange,
      allowedRadius: stop.allowedRadius,
    );
  }
}
