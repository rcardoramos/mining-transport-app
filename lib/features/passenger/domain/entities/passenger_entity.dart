import 'package:freezed_annotation/freezed_annotation.dart';

import 'collaborator_entity.dart';

part 'passenger_entity.freezed.dart';
part 'passenger_entity.g.dart';

/// Entidad de dominio que representa un pasajero registrado a bordo de un viaje.
@freezed
class PassengerEntity with _$PassengerEntity {
  const factory PassengerEntity({
    /// DNI del pasajero (8 dígitos)
    required String dni,
    /// Nombre completo (disponible cuando se resuelva contra la BD offline)
    required String fullName,
    /// Hora exacta de registro del embarque
    required DateTime boardedAt,
    /// Método de registro: 'qr_scan' | 'manual'
    required String registrationMethod,
    /// Estado laboral del colaborador al embarcar
    required CollaboratorStatus status,
    /// Número de asiento asignado (null hasta que se asigne)
    String? seatNumber,
    @Default('Miski Mayo') String category,
  }) = _PassengerEntity;

  factory PassengerEntity.fromJson(Map<String, dynamic> json) =>
      _$PassengerEntityFromJson(json);
}
