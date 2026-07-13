// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StopModelImpl _$$StopModelImplFromJson(Map<String, dynamic> json) =>
    _$StopModelImpl(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      radioPermitido: (json['radioPermitido'] as num).toDouble(),
      orden: (json['orden'] as num).toInt(),
      completado: json['completado'] as bool? ?? false,
    );

Map<String, dynamic> _$$StopModelImplToJson(_$StopModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'radioPermitido': instance.radioPermitido,
      'orden': instance.orden,
      'completado': instance.completado,
    };
