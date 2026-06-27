// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverEntityImpl _$$DriverEntityImplFromJson(Map<String, dynamic> json) =>
    _$DriverEntityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      status: $enumDecode(_$DriverStatusEnumMap, json['status']),
      todayTripsCount: (json['todayTripsCount'] as num).toInt(),
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$DriverEntityImplToJson(_$DriverEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'status': _$DriverStatusEnumMap[instance.status]!,
      'todayTripsCount': instance.todayTripsCount,
      'avatarUrl': instance.avatarUrl,
    };

const _$DriverStatusEnumMap = {
  DriverStatus.active: 'active',
  DriverStatus.onBreak: 'onBreak',
  DriverStatus.inactive: 'inactive',
};
