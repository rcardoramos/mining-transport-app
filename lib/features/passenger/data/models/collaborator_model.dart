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
    var status = statusVal.toString();

    // Contrato staging: AptoParaAbordar=false + EstadoLaboral=SUSPENSION.
    // Si el estado no se reconoce y no es apto, no tratarlo como OK.
    final aptoRaw = json['AptoParaAbordar'] ?? json['aptoParaAbordar'];
    final apto = aptoRaw is bool
        ? aptoRaw
        : (aptoRaw?.toString().toLowerCase() == 'true'
            ? true
            : (aptoRaw?.toString().toLowerCase() == 'false' ? false : null));
    if (apto == false) {
      final normalized = status.trim().toUpperCase();
      if (normalized.isEmpty ||
          normalized == 'OK' ||
          normalized == 'ACTIVO' ||
          normalized == 'ACTIVE') {
        status = 'SUSPENSION';
      }
    }

    final categoryVal = json['category'] ?? json['Empresa'] ?? json['categoria'] ?? 'Miski Mayo';
    final category = _normalizeCategory(categoryVal.toString());

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

/// Normaliza códigos de empresa del backend (ej. "01") a categorías de UI/negocio.
String _normalizeCategory(String raw) {
  final clean = raw.trim();
  if (clean.isEmpty) return 'Miski Mayo';
  if (clean == '01' || clean == '1') return 'Miski Mayo';
  if (RegExp(r'^\d+$').hasMatch(clean)) return 'Miski Mayo';
  return clean;
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
  if (clean == 'SUSPENSION' ||
      clean == 'SUSPENDIDO' ||
      clean == 'SUSPENDED' ||
      clean == 'SUSPENDIDO_ALERT') {
    return CollaboratorStatus.suspended;
  }
  
  return CollaboratorStatus.values.firstWhere(
    (e) => e.name.toUpperCase() == clean,
    orElse: () => CollaboratorStatus.ok,
  );
}
