import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';

part 'passenger_model.freezed.dart';

/// Modelo de datos para [PassengerEntity], compatible con JSON y Freezed.
@freezed
class PassengerModel with _$PassengerModel {
  const factory PassengerModel({
    required String dni,
    required String fullName,
    required String boardedAt,
    required String registrationMethod,
    required String status,
    String? seatNumber,
    @Default('Miski Mayo') String category,
  }) = _PassengerModel;

  factory PassengerModel.fromJson(Map<String, dynamic> json) {
    final dniVal = json['dni'] ?? json['Dni'] ?? '';
    final dni = dniVal.toString();

    final fullNameVal = json['fullName'] ?? json['NombreCompleto'] ?? '';
    final fullName = fullNameVal.toString();

    final boardedAtVal = json['boardedAt'] ?? json['FechaEmbarque'] ?? json['boarded_at'] ?? DateTime.now().toUtc().toIso8601String();
    final boardedAt = boardedAtVal.toString();

    final registrationMethodVal = json['registrationMethod'] ?? json['MetodoRegistro'] ?? json['registration_method'] ?? 'qr';
    final registrationMethod = registrationMethodVal.toString();

    final statusVal = json['status'] ?? json['EstadoLaboral'] ?? json['estado'] ?? 'OK';
    final status = statusVal.toString();

    final seatNumberVal = json['seatNumber'] ?? json['NumeroAsiento'] ?? json['seat_number'];
    final seatNumber = seatNumberVal?.toString();

    final categoryVal = json['category'] ?? json['Empresa'] ?? json['categoria'] ?? 'Miski Mayo';
    final category = categoryVal.toString();

    return PassengerModel(
      dni: dni,
      fullName: fullName,
      boardedAt: boardedAt,
      registrationMethod: registrationMethod,
      status: status,
      seatNumber: seatNumber,
      category: category,
    );
  }
}

/// Extensión para convertir [PassengerModel] → [PassengerEntity]
extension PassengerModelMapper on PassengerModel {
  PassengerEntity toEntity() {
    return PassengerEntity(
      dni: dni,
      fullName: fullName,
      boardedAt: PeruDateFormatter.parseFlexible(boardedAt) ?? DateTime.now(),
      registrationMethod: registrationMethod,
      status: _parseCollaboratorStatus(status),
      seatNumber: seatNumber,
      category: category,
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
