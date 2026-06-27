import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaborator_entity.freezed.dart';
part 'collaborator_entity.g.dart';

/// Estatus del colaborador en relación a su derecho de embarque.
enum CollaboratorStatus { ok, vacation, medicalLeave, license, terminated }

@freezed
class CollaboratorEntity with _$CollaboratorEntity {
  const factory CollaboratorEntity({
    required String dni,
    required String fullName,
    required CollaboratorStatus status,
  }) = _CollaboratorEntity;

  factory CollaboratorEntity.fromJson(Map<String, dynamic> json) =>
      _$CollaboratorEntityFromJson(json);
}
