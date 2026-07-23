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

  factory StopModel.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'] ?? json['Id'] ?? '';
    final id = idVal.toString();

    final nombreVal = json['nombre'] ?? json['Nombre'] ?? 'Paradero';
    final nombre = nombreVal.toString();

    final latitudVal = json['latitud'] ?? json['Latitud'] ?? 0.0;
    final latitud = double.tryParse(latitudVal.toString()) ?? 0.0;

    final longitudVal = json['longitud'] ?? json['Longitud'] ?? 0.0;
    final longitud = double.tryParse(longitudVal.toString()) ?? 0.0;

    final radioPermitidoVal = json['radioPermitido'] ?? json['RadioPermitido'] ?? json['radio_permitido'] ?? 50.0;
    final radioPermitido = double.tryParse(radioPermitidoVal.toString()) ?? 50.0;

    final ordenVal = json['orden'] ?? json['Orden'] ?? 0;
    final orden = int.tryParse(ordenVal.toString()) ?? 0;

    final completadoVal = json['completado'] ?? json['Completado'] ?? false;
    final completado = completadoVal == true || completadoVal.toString().toLowerCase() == 'true';

    return StopModel(
      id: id,
      nombre: nombre,
      latitud: latitud,
      longitud: longitud,
      radioPermitido: radioPermitido,
      orden: orden,
      completado: completado,
    );
  }

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
