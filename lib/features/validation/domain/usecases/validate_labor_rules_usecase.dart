import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/labor_validation_result.dart';
import '../repositories/validation_repository.dart';

/// Caso de uso para verificar y validar las reglas laborales y de seguridad de un colaborador.
class ValidateLaborRulesUseCase {
  final ValidationRepository _repository;

  ValidateLaborRulesUseCase(this._repository);

  /// Ejecuta la validación laboral para un DNI dado.
  Future<Result<LaborValidationResult, Failure>> execute(String dni, bool isOnline) {
    return _repository.validateLaborRules(dni, isOnline);
  }
}
