import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/validation/domain/entities/labor_validation_result.dart';
import 'package:mining_transport_app/features/validation/data/datasources/validation_local_data_source.dart';
import 'package:mining_transport_app/features/validation/data/repositories/validation_repository_impl.dart';

class MockValidationLocalDataSource extends Mock implements ValidationLocalDataSource {}
class MockHomeDashboardRepository extends Mock implements HomeDashboardRepository {}

void main() {
  late MockValidationLocalDataSource mockLocalDataSource;
  late MockHomeDashboardRepository mockHomeRepository;
  late ValidationRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockValidationLocalDataSource();
    mockHomeRepository = MockHomeDashboardRepository();
    repository = ValidationRepositoryImpl(mockLocalDataSource, mockHomeRepository);
  });

  setUpAll(() {
    registerFallbackValue(CollaboratorStatus.ok);
    registerFallbackValue(
      Passenger(
        id: '',
        docNumber: '',
        code: '',
        firstName: '',
        lastName: '',
        companyName: '',
        status: '',
        emoExpirationDate: DateTime(0),
        inductionExpirationDate: DateTime(0),
        hasSecurityBlock: false,
      ),
    );
  });

  final String tDni = '48102030';
  final today = DateTime.now();
  final futureDate = DateTime(today.year + 1, today.month, today.day);
  final pastDate = DateTime(today.year - 1, today.month, today.day);

  Passenger buildPassenger({
    required String status,
    required DateTime emoDate,
    required DateTime inductionDate,
    required bool hasSecurityBlock,
  }) {
    return Passenger(
      id: tDni,
      docNumber: tDni,
      code: 'COD-$tDni',
      firstName: 'Juan',
      lastName: 'Pérez',
      companyName: 'Miski Mayo',
      status: status,
      emoExpirationDate: emoDate,
      inductionExpirationDate: inductionDate,
      hasSecurityBlock: hasSecurityBlock,
    );
  }

  group('ValidationRepositoryImpl - Local validation rules', () {
    test('should return allowed for a regular active collaborator', () async {
      final passenger = buildPassenger(
        status: 'ok',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.allowed);
      expect(validation.isValid, true);
      expect(validation.errorMessage, isNull);
    });

    test('should return blockedSecurity if hasSecurityBlock is true', () async {
      final passenger = buildPassenger(
        status: 'ok',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: true,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.blockedSecurity);
      expect(validation.isValid, false);
      expect(validation.errorMessage, contains('bloqueo'));
    });

    test('should return blockedInactive if status is terminated/Inactive', () async {
      final passenger = buildPassenger(
        status: 'terminated',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.blockedInactive);
      expect(validation.isValid, false);
    });

    test('should return blockedEmoExpired if EMO date is past', () async {
      final passenger = buildPassenger(
        status: 'ok',
        emoDate: pastDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.blockedEmoExpired);
      expect(validation.isValid, false);
    });

    test('should return blockedInductionExpired if safety induction date is past', () async {
      final passenger = buildPassenger(
        status: 'ok',
        emoDate: futureDate,
        inductionDate: pastDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.blockedInductionExpired);
      expect(validation.isValid, false);
    });

    test('should return warningVacation if status is vacation', () async {
      final passenger = buildPassenger(
        status: 'vacation',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.warningVacation);
      expect(validation.isValid, true);
    });

    test('should return warningMedicalLeave if status is medicalLeave', () async {
      final passenger = buildPassenger(
        status: 'medicalLeave',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.warningMedicalLeave);
      expect(validation.isValid, true);
    });

    test('should return warningLicense if status is license', () async {
      final passenger = buildPassenger(
        status: 'license',
        emoDate: futureDate,
        inductionDate: futureDate,
        hasSecurityBlock: false,
      );

      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => passenger);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.warningLicense);
      expect(validation.isValid, true);
    });
  });

  group('ValidationRepositoryImpl - Remote lookup and cache', () {
    test('should return CollaboratorNotFoundFailure if offline and passenger not found locally', () async {
      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => null);

      final result = await repository.validateLaborRules(tDni, false);

      expect(result.isFailure, true);
      expect(result.failureOrNull, isA<CollaboratorNotFoundFailure>());
    });

    test('should consult remote API, cache data locally and return validation result if online', () async {
      when(() => mockLocalDataSource.getPassengerByDni(tDni))
          .thenAnswer((_) async => null);

      final remoteCollaborator = const CollaboratorEntity(
        dni: '48102030',
        fullName: 'Juan Pérez Remoto',
        status: CollaboratorStatus.ok,
        category: 'Miski Mayo',
      );

      when(() => mockHomeRepository.checkCollaborator(tDni))
          .thenAnswer((_) async => Success(remoteCollaborator));

      when(() => mockLocalDataSource.savePassenger(any()))
          .thenAnswer((_) async => {});

      final result = await repository.validateLaborRules(tDni, true);

      expect(result.isSuccess, true);
      final validation = result.successOrNull!;
      expect(validation.status, LaborValidationStatus.allowed);
      expect(validation.fullName, 'Juan Pérez Remoto');
      
      verify(() => mockHomeRepository.checkCollaborator(tDni)).called(1);
      verify(() => mockLocalDataSource.savePassenger(any())).called(1);
    });
  });
}
