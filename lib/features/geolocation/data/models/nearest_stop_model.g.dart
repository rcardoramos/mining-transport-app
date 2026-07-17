// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearest_stop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NearestStopModelImpl _$$NearestStopModelImplFromJson(
  Map<String, dynamic> json,
) => _$NearestStopModelImpl(
  paraderoId: (json['ParaderoId'] as num).toInt(),
  nombre: json['Nombre'] as String,
  distanciaMetros: (json['DistanciaMetros'] as num).toDouble(),
);

Map<String, dynamic> _$$NearestStopModelImplToJson(
  _$NearestStopModelImpl instance,
) => <String, dynamic>{
  'ParaderoId': instance.paraderoId,
  'Nombre': instance.nombre,
  'DistanciaMetros': instance.distanciaMetros,
};
