// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripModelImpl _$$TripModelImplFromJson(Map<String, dynamic> json) =>
    _$TripModelImpl(
      id: json['id'] as String,
      route: json['route'] as String,
      scheduledTime: json['scheduledTime'] as String,
      shift: json['shift'] as String,
      unitCode: json['unitCode'] as String,
      capacity: (json['capacity'] as num).toInt(),
      passengerCount: (json['passengerCount'] as num).toInt(),
      status: json['status'] as String,
      startedAt: json['startedAt'] as String?,
    );

Map<String, dynamic> _$$TripModelImplToJson(_$TripModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'route': instance.route,
      'scheduledTime': instance.scheduledTime,
      'shift': instance.shift,
      'unitCode': instance.unitCode,
      'capacity': instance.capacity,
      'passengerCount': instance.passengerCount,
      'status': instance.status,
      'startedAt': instance.startedAt,
    };
