import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/geolocation/data/datasources/geolocation_remote_data_source.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/nearest_stop_entity.dart';
import 'package:mining_transport_app/features/geolocation/domain/repositories/geolocation_repository.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final GeolocationRemoteDataSource _remoteDataSource;

  GeolocationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<NearestStopEntity, Failure>> resolveNearestStop(double lat, double lng) async {
    try {
      final model = await _remoteDataSource.resolveNearestStop(lat, lng);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
