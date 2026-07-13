import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/stop_entity.dart';

part 'stop_model.freezed.dart';
part 'stop_model.g.dart';

@freezed
class StopModel with _$StopModel {
  const factory StopModel({
    required String id,
    required String nombre,
    required double latitud,
    required double longitud,
    required double radioPermitido,
    required int orden,
    @Default(false) bool completado,
  }) = _StopModel;

  const StopModel._();

  factory StopModel.fromJson(Map<String, dynamic> json) => _$StopModelFromJson(json);

  StopEntity toEntity() {
    return StopEntity(
      id: id,
      name: nombre,
      latitude: latitud,
      longitude: longitud,
      allowedRadius: radioPermitido,
      sequenceOrder: orden,
      isCompleted: completado,
    );
  }
}
