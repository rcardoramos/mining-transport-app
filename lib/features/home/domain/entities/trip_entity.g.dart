// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripEntityImpl _$$TripEntityImplFromJson(Map<String, dynamic> json) =>
    _$TripEntityImpl(
      id: json['id'] as String,
      route: json['route'] as String,
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      shift: json['shift'] as String,
      unitCode: json['unitCode'] as String,
      capacity: (json['capacity'] as num).toInt(),
      passengerCount: (json['passengerCount'] as num).toInt(),
      status: $enumDecode(_$TripStatusEnumMap, json['status']),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
    );

Map<String, dynamic> _$$TripEntityImplToJson(_$TripEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'route': instance.route,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'shift': instance.shift,
      'unitCode': instance.unitCode,
      'capacity': instance.capacity,
      'passengerCount': instance.passengerCount,
      'status': _$TripStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt?.toIso8601String(),
    };

const _$TripStatusEnumMap = {
  TripStatus.scheduled: 'scheduled',
  TripStatus.readyToStart: 'readyToStart',
  TripStatus.inProgress: 'inProgress',
  TripStatus.travelling: 'travelling',
  TripStatus.completed: 'completed',
  TripStatus.cancelled: 'cancelled',
};
