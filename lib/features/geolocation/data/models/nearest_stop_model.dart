import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/nearest_stop_entity.dart';

part 'nearest_stop_model.freezed.dart';
part 'nearest_stop_model.g.dart';

@freezed
class NearestStopModel with _$NearestStopModel {
  const factory NearestStopModel({
    @JsonKey(name: 'ParaderoId') required int paraderoId,
    @JsonKey(name: 'Nombre') required String nombre,
    @JsonKey(name: 'DistanciaMetros') required double distanciaMetros,
  }) = _NearestStopModel;

  factory NearestStopModel.fromJson(Map<String, dynamic> json) =>
      _$NearestStopModelFromJson(json);

  const NearestStopModel._();

  NearestStopEntity toEntity() => NearestStopEntity(
        paraderoId: paraderoId,
        nombre: nombre,
        distanciaMetros: distanciaMetros,
      );
}
