// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaboratorModelImpl _$$CollaboratorModelImplFromJson(
  Map<String, dynamic> json,
) => _$CollaboratorModelImpl(
  dni: json['dni'] as String,
  fullName: json['fullName'] as String,
  status: json['status'] as String,
  category: json['category'] as String? ?? 'Miski Mayo',
);

Map<String, dynamic> _$$CollaboratorModelImplToJson(
  _$CollaboratorModelImpl instance,
) => <String, dynamic>{
  'dni': instance.dni,
  'fullName': instance.fullName,
  'status': instance.status,
  'category': instance.category,
};
