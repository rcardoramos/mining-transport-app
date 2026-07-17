import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/validation/domain/entities/labor_validation_result.dart';
import 'package:mining_transport_app/features/validation/domain/repositories/validation_repository.dart';
import 'package:mining_transport_app/features/validation/data/datasources/validation_local_data_source.dart';

/// Implementación concreta del repositorio de validación de reglas de negocio laboral.
class ValidationRepositoryImpl implements ValidationRepository {
  final ValidationLocalDataSource _localDataSource;
  final HomeDashboardRepository _homeRepository;

  ValidationRepositoryImpl(this._localDataSource, this._homeRepository);

  @override
  Future<Result<LaborValidationResult, Failure>> validateLaborRules(String dni, bool isOnline) async {
    try {
      // 1. Intentar cargar el colaborador del padrón local (Offline-First)
      final localPassenger = await _localDataSource.getPassengerByDni(dni);

      if (localPassenger != null) {
        final result = _evaluateLocalRules(localPassenger);
        return Success(result);
      }

      // 2. Si no está en el local y está online, consultar al backend
      if (isOnline) {
        final remoteResult = await _homeRepository.checkCollaborator(dni);

        if (remoteResult.isSuccess) {
          final collaborator = remoteResult.successOrNull!;
          
          // Crear un registro local para el cache/sincronización offline futura
          final today = DateTime.now();
          final futureDate = DateTime(today.year + 1, today.month, today.day);

          final passengerRow = Passenger(
            id: collaborator.dni,
            docNumber: collaborator.dni,
            code: 'EMP-${collaborator.dni}',
            firstName: collaborator.fullName,
            lastName: '',
            companyName: collaborator.category,
            status: collaborator.status.name,
            emoExpirationDate: futureDate,
            inductionExpirationDate: futureDate,
            hasSecurityBlock: false,
          );

          await _localDataSource.savePassenger(passengerRow);

          // Evaluar las reglas sobre la entidad remota convertida
          final mappedStatus = _mapCollaboratorStatusToValidation(collaborator.status);
          final validationResult = LaborValidationResult(
            dni: collaborator.dni,
            fullName: collaborator.fullName,
            status: mappedStatus,
            category: collaborator.category,
            emoExpirationDate: futureDate,
            inductionExpirationDate: futureDate,
            hasSecurityBlock: false,
            errorMessage: _getErrorMessage(mappedStatus),
          );

          return Success(validationResult);
        } else {
          return FailureResult(remoteResult.failureOrNull ?? const CollaboratorNotFoundFailure('Colaborador no encontrado'));
        }
      }

      // 3. Si no está local y está offline, retornar error
      return const FailureResult(CollaboratorNotFoundFailure('Colaborador no encontrado en el padrón local (Modo Offline)'));

    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  LaborValidationResult _evaluateLocalRules(Passenger passenger) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final emoDate = DateTime(
      passenger.emoExpirationDate.year,
      passenger.emoExpirationDate.month,
      passenger.emoExpirationDate.day,
    );

    final inductionDate = DateTime(
      passenger.inductionExpirationDate.year,
      passenger.inductionExpirationDate.month,
      passenger.inductionExpirationDate.day,
    );

    final String fullName = '${passenger.firstName} ${passenger.lastName}'.trim();

    // Regla 4: Bloqueos de seguridad
    if (passenger.hasSecurityBlock) {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.blockedSecurity,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: true,
        errorMessage: 'Acceso Denegado: Colaborador con bloqueo administrativo o de seguridad activo.',
      );
    }

    // Regla 1: Estado del trabajador
    final normalizedStatus = passenger.status.toLowerCase();
    if (normalizedStatus == 'inactive' || normalizedStatus == 'terminated') {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.blockedInactive,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Acceso Denegado: Estado del trabajador cesado o inactivo.',
      );
    }

    // Regla 2: Examen médico ocupacional
    if (emoDate.isBefore(todayDate)) {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.blockedEmoExpired,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Acceso Denegado: Examen Médico Ocupacional (EMO) vencido.',
      );
    }

    // Regla 3: Inducción de seguridad anual
    if (inductionDate.isBefore(todayDate)) {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.blockedInductionExpired,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Acceso Denegado: Inducción de Seguridad Anual aprobada vencida.',
      );
    }

    // Alertas excepcionales pero válidas (vacaciones, descanso médico, licencias)
    if (normalizedStatus == 'vacation') {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.warningVacation,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Alerta: Colaborador en vacaciones.',
      );
    }

    if (normalizedStatus == 'medicalleave') {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.warningMedicalLeave,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Alerta: Colaborador con descanso médico (DM) activo.',
      );
    }

    if (normalizedStatus == 'license') {
      return LaborValidationResult(
        dni: passenger.docNumber,
        fullName: fullName,
        status: LaborValidationStatus.warningLicense,
        category: passenger.companyName,
        emoExpirationDate: passenger.emoExpirationDate,
        inductionExpirationDate: passenger.inductionExpirationDate,
        hasSecurityBlock: false,
        errorMessage: 'Alerta: Colaborador con licencia aprobada.',
      );
    }

    // Colaborador regular y aprobado
    return LaborValidationResult(
      dni: passenger.docNumber,
      fullName: fullName,
      status: LaborValidationStatus.allowed,
      category: passenger.companyName,
      emoExpirationDate: passenger.emoExpirationDate,
      inductionExpirationDate: passenger.inductionExpirationDate,
      hasSecurityBlock: false,
      errorMessage: null,
    );
  }

  LaborValidationStatus _mapCollaboratorStatusToValidation(CollaboratorStatus remoteStatus) {
    switch (remoteStatus) {
      case CollaboratorStatus.ok:
        return LaborValidationStatus.allowed;
      case CollaboratorStatus.vacation:
        return LaborValidationStatus.warningVacation;
      case CollaboratorStatus.medicalLeave:
        return LaborValidationStatus.warningMedicalLeave;
      case CollaboratorStatus.license:
        return LaborValidationStatus.warningLicense;
      case CollaboratorStatus.terminated:
        return LaborValidationStatus.blockedInactive;
    }
  }

  String? _getErrorMessage(LaborValidationStatus validationStatus) {
    switch (validationStatus) {
      case LaborValidationStatus.blockedInactive:
        return 'Acceso Denegado: Estado del trabajador cesado o inactivo.';
      case LaborValidationStatus.blockedSecurity:
        return 'Acceso Denegado: Colaborador con bloqueo administrativo o de seguridad activo.';
      case LaborValidationStatus.blockedEmoExpired:
        return 'Acceso Denegado: Examen Médico Ocupacional (EMO) vencido.';
      case LaborValidationStatus.blockedInductionExpired:
        return 'Acceso Denegado: Inducción de Seguridad Anual aprobada vencida.';
      case LaborValidationStatus.warningVacation:
        return 'Alerta: Colaborador en vacaciones.';
      case LaborValidationStatus.warningMedicalLeave:
        return 'Alerta: Colaborador con descanso médico (DM) activo.';
      case LaborValidationStatus.warningLicense:
        return 'Alerta: Colaborador con licencia aprobada.';
      case LaborValidationStatus.allowed:
        return null;
    }
  }
}
