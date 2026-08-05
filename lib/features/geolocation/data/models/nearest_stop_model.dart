import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/geolocation/domain/entities/nearest_stop_entity.dart';

part 'nearest_stop_model.freezed.dart';

@freezed
class NearestStopModel with _$NearestStopModel {
  const factory NearestStopModel({
    @JsonKey(name: 'ParaderoId') required int paraderoId,
    @JsonKey(name: 'Nombre') required String nombre,
    @JsonKey(name: 'DistanciaMetros') required double distanciaMetros,
  }) = _NearestStopModel;

  factory NearestStopModel.fromJson(Map<String, dynamic> json) {
    final paraderoIdVal = json['ParaderoId'] ?? json['paraderoId'] ?? json['id'] ?? json['Id'] ?? 0;
    final paraderoId = int.tryParse(paraderoIdVal.toString()) ?? 0;

    final nombreVal = json['Nombre'] ?? json['nombre'] ?? 'Paradero';
    final nombre = nombreVal.toString();

    final distanciaMetrosVal = json['DistanciaMetros'] ?? json['distanciaMetros'] ?? json['distancia_metros'] ?? 0.0;
    final distanciaMetros = double.tryParse(distanciaMetrosVal.toString()) ?? 0.0;

    return NearestStopModel(
      paraderoId: paraderoId,
      nombre: nombre,
      distanciaMetros: distanciaMetros,
    );
  }

  const NearestStopModel._();

  NearestStopEntity toEntity() => NearestStopEntity(
        paraderoId: paraderoId,
        nombre: nombre,
        distanciaMetros: distanciaMetros,
      );
}
