import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/collaborator_entity.dart';

part 'collaborator_model.freezed.dart';
part 'collaborator_model.g.dart';

@freezed
class CollaboratorModel with _$CollaboratorModel {
  const factory CollaboratorModel({
    required String dni,
    required String fullName,
    required String status,
  }) = _CollaboratorModel;

  factory CollaboratorModel.fromJson(Map<String, dynamic> json) =>
      _$CollaboratorModelFromJson(json);
}

extension CollaboratorModelMapper on CollaboratorModel {
  CollaboratorEntity toEntity() {
    final statusEnum = CollaboratorStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => CollaboratorStatus.ok,
    );
    return CollaboratorEntity(
      dni: dni,
      fullName: fullName,
      status: statusEnum,
    );
  }
}
