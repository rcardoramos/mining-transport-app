import 'package:freezed_annotation/freezed_annotation.dart';

part 'geofencing_result.freezed.dart';

@freezed
class GeofencingResult with _$GeofencingResult {
  const factory GeofencingResult({
    required double distanceInMetres,
    required bool inRange,
    required double allowedRadius,
  }) = _GeofencingResult;
}
