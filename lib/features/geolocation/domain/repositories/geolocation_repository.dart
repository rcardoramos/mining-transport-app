import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/nearest_stop_entity.dart';

abstract class GeolocationRepository {
  Future<Result<NearestStopEntity, Failure>> resolveNearestStop(double lat, double lng);
}
