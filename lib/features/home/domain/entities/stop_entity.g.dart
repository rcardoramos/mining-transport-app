// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StopEntityImpl _$$StopEntityImplFromJson(Map<String, dynamic> json) =>
    _$StopEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      allowedRadius: (json['allowedRadius'] as num).toDouble(),
      sequenceOrder: (json['sequenceOrder'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$StopEntityImplToJson(_$StopEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'allowedRadius': instance.allowedRadius,
      'sequenceOrder': instance.sequenceOrder,
      'isCompleted': instance.isCompleted,
    };
