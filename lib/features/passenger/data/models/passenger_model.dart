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

  factory PassengerModel.fromJson(Map<String, dynamic> json) =>
      _$PassengerModelFromJson(json);
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
