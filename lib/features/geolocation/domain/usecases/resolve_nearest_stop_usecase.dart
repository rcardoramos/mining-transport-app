import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/nearest_stop_entity.dart';
import 'package:mining_transport_app/features/geolocation/domain/repositories/geolocation_repository.dart';

class ResolveNearestStopUseCase {
  final GeolocationRepository _repository;

  ResolveNearestStopUseCase(this._repository);

  Future<Result<NearestStopEntity, Failure>> execute(double lat, double lng) {
    return _repository.resolveNearestStop(lat, lng);
  }
}
