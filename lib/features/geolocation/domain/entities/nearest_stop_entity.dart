import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearest_stop_entity.freezed.dart';

@freezed
class NearestStopEntity with _$NearestStopEntity {
  const factory NearestStopEntity({
    required int paraderoId,
    required String nombre,
    required double distanciaMetros,
  }) = _NearestStopEntity;
}
