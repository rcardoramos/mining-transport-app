// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaboratorEntityImpl _$$CollaboratorEntityImplFromJson(
  Map<String, dynamic> json,
) => _$CollaboratorEntityImpl(
  dni: json['dni'] as String,
  fullName: json['fullName'] as String,
  status: $enumDecode(_$CollaboratorStatusEnumMap, json['status']),
  category: json['category'] as String? ?? 'Miski Mayo',
);

Map<String, dynamic> _$$CollaboratorEntityImplToJson(
  _$CollaboratorEntityImpl instance,
) => <String, dynamic>{
  'dni': instance.dni,
  'fullName': instance.fullName,
  'status': _$CollaboratorStatusEnumMap[instance.status]!,
  'category': instance.category,
};

const _$CollaboratorStatusEnumMap = {
  CollaboratorStatus.ok: 'ok',
  CollaboratorStatus.vacation: 'vacation',
  CollaboratorStatus.medicalLeave: 'medicalLeave',
  CollaboratorStatus.license: 'license',
  CollaboratorStatus.terminated: 'terminated',
};
