// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PassengerEntityImpl _$$PassengerEntityImplFromJson(
  Map<String, dynamic> json,
) => _$PassengerEntityImpl(
  dni: json['dni'] as String,
  fullName: json['fullName'] as String,
  boardedAt: DateTime.parse(json['boardedAt'] as String),
  registrationMethod: json['registrationMethod'] as String,
  status: $enumDecode(_$CollaboratorStatusEnumMap, json['status']),
  seatNumber: json['seatNumber'] as String?,
);

Map<String, dynamic> _$$PassengerEntityImplToJson(
  _$PassengerEntityImpl instance,
) => <String, dynamic>{
  'dni': instance.dni,
  'fullName': instance.fullName,
  'boardedAt': instance.boardedAt.toIso8601String(),
  'registrationMethod': instance.registrationMethod,
  'status': _$CollaboratorStatusEnumMap[instance.status]!,
  'seatNumber': instance.seatNumber,
};

const _$CollaboratorStatusEnumMap = {
  CollaboratorStatus.ok: 'ok',
  CollaboratorStatus.vacation: 'vacation',
  CollaboratorStatus.medicalLeave: 'medicalLeave',
  CollaboratorStatus.license: 'license',
  CollaboratorStatus.terminated: 'terminated',
};
