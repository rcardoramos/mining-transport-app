import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';

part 'passenger_model.freezed.dart';
part 'passenger_model.g.dart';

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
    final statusEnum = CollaboratorStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => CollaboratorStatus.ok,
    );
    return PassengerEntity(
      dni: dni,
      fullName: fullName,
      boardedAt: DateTime.parse(boardedAt),
      registrationMethod: registrationMethod,
      status: statusEnum,
      seatNumber: seatNumber,
      category: category,
    );
  }
}
