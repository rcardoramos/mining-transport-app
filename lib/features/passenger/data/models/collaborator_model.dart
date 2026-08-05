import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';

part 'collaborator_model.freezed.dart';

@freezed
class CollaboratorModel with _$CollaboratorModel {
  const factory CollaboratorModel({
    required String dni,
    required String fullName,
    required String status,
    @Default('Miski Mayo') String category,
    String? puesto,
    String? unidad,
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

    final puestoVal = json['puesto'] ?? json['Puesto'];
    final puesto = puestoVal?.toString();

    final unidadVal = json['unidad'] ?? json['Unidad'];
    final unidad = unidadVal?.toString();

    return CollaboratorModel(
      dni: dni,
      fullName: fullName,
      status: status,
      category: category,
      puesto: puesto,
      unidad: unidad,
    );
  }
}

extension CollaboratorModelMapper on CollaboratorModel {
  CollaboratorEntity toEntity() {
    return CollaboratorEntity(
      dni: dni,
      fullName: fullName,
      status: _parseCollaboratorStatus(status),
      category: category,
      puesto: puesto,
      unidad: unidad,
    );
  }
}

CollaboratorStatus _parseCollaboratorStatus(String? statusStr) {
  if (statusStr == null) return CollaboratorStatus.ok;
  final clean = statusStr.trim().toUpperCase();
  
  if (clean == 'OK' || clean == 'ACTIVO' || clean == 'ACTIVE') {
    return CollaboratorStatus.ok;
  }
  if (clean == 'VACACIONES' || clean == 'VACATION' || clean == 'VACACIONES_ALERT') {
    return CollaboratorStatus.vacation;
  }
  if (clean == 'DESCANSO_MEDICO' || clean == 'DESCANSO' || clean == 'MEDICAL_LEAVE' || clean == 'MEDICALLEAVE') {
    return CollaboratorStatus.medicalLeave;
  }
  if (clean == 'LICENCIA' || clean == 'LICENSE' || clean == 'LIC') {
    return CollaboratorStatus.license;
  }
  if (clean == 'CESADO' || clean == 'INACTIVO' || clean == 'TERMINATED' || clean == 'CESADO_ALERT') {
    return CollaboratorStatus.terminated;
  }
  
  return CollaboratorStatus.values.firstWhere(
    (e) => e.name.toUpperCase() == clean,
    orElse: () => CollaboratorStatus.ok,
  );
}
