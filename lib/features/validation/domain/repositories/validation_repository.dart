import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/labor_validation_result.dart';

/// Interfaz de contrato para el repositorio del módulo de validación laboral.
abstract class ValidationRepository {
  /// Realiza la validación de las reglas laborales (EMO, inducción, bloqueos)
  /// para un colaborador por su DNI, considerando si está online u offline.
  Future<Result<LaborValidationResult, Failure>> validateLaborRules(String dni, bool isOnline);
}
