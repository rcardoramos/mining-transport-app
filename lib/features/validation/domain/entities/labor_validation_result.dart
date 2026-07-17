import 'package:freezed_annotation/freezed_annotation.dart';

part 'labor_validation_result.freezed.dart';

/// Estatus detallado de validación laboral de un colaborador.
enum LaborValidationStatus {
  allowed,
  warningVacation,
  warningMedicalLeave,
  warningLicense,
  blockedInactive,
  blockedEmoExpired,
  blockedInductionExpired,
  blockedSecurity,
}

@freezed
class LaborValidationResult with _$LaborValidationResult {
  const factory LaborValidationResult({
    required String dni,
    required String fullName,
    required LaborValidationStatus status,
    required String category,
    required DateTime? emoExpirationDate,
    required DateTime? inductionExpirationDate,
    required bool hasSecurityBlock,
    required String? errorMessage,
  }) = _LaborValidationResult;
}

extension LaborValidationResultExtension on LaborValidationResult {
  bool get isValid =>
      status == LaborValidationStatus.allowed ||
      status == LaborValidationStatus.warningVacation ||
      status == LaborValidationStatus.warningMedicalLeave ||
      status == LaborValidationStatus.warningLicense;
}
