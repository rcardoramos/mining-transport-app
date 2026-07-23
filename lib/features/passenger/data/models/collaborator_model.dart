import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';

part 'collaborator_model.freezed.dart';
part 'collaborator_model.g.dart';

@freezed
class CollaboratorModel with _$CollaboratorModel {
  const factory CollaboratorModel({
    required String dni,
    required String fullName,
    required String status,
    @Default('Miski Mayo') String category,
  }) = _CollaboratorModel;

  factory CollaboratorModel.fromJson(Map<String, dynamic> json) {
    final dniVal = json['dni'] ?? json['Dni'] ?? '';
    final dni = dniVal.toString();

    final fullNameVal = json['fullName'] ?? json['NombreCompleto'] ?? '';
    final fullName = fullNameVal.toString();

    final statusVal = json['status'] ?? json['EstadoLaboral'] ?? 'OK';
    final status = statusVal.toString();

    final categoryVal = json['category'] ?? json['Empresa'] ?? json['categoria'] ?? 'Miski Mayo';
    final category = categoryVal.toString();

    return CollaboratorModel(
      dni: dni,
      fullName: fullName,
      status: status,
      category: category,
    );
  }
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
      category: category,
    );
  }
}
