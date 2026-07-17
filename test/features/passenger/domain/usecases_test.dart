import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/check_collaborator_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/register_passenger_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/usecases/get_passengers_on_board_usecase.dart';

class MockHomeDashboardRepository extends Mock implements HomeDashboardRepository {}

void main() {
  late MockHomeDashboardRepository mockRepository;
  late CheckCollaboratorUseCase checkCollaboratorUseCase;
  late RegisterPassengerUseCase registerPassengerUseCase;
  late GetPassengersOnBoardUseCase getPassengersOnBoardUseCase;

  setUp(() {
    mockRepository = MockHomeDashboardRepository();
    checkCollaboratorUseCase = CheckCollaboratorUseCase(mockRepository);
    registerPassengerUseCase = RegisterPassengerUseCase(mockRepository);
    getPassengersOnBoardUseCase = GetPassengersOnBoardUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(CollaboratorStatus.ok);
  });

  final tCollaborator = const CollaboratorEntity(
    dni: '48102030',
    fullName: 'Juan Perez',
    status: CollaboratorStatus.ok,
    category: 'Miski Mayo',
  );

  final tPassenger = PassengerEntity(
    dni: '48102030',
    fullName: 'Juan Perez',
    boardedAt: DateTime.now(),
    registrationMethod: 'qr_scan',
    status: CollaboratorStatus.ok,
    seatNumber: '1',
    category: 'Miski Mayo',
  );

  final tTrip = TripEntity(
    id: 'TRIP-101',
    route: 'Mina - Campamento',
    scheduledTime: DateTime.now(),
    shift: 'Día',
    unitCode: 'BUS-01',
    capacity: 45,
    passengerCount: 1,
    status: TripStatus.inProgress,
  );

  group('CheckCollaboratorUseCase', () {
    test('should return CollaboratorEntity on success', () async {
      when(() => mockRepository.checkCollaborator('48102030'))
          .thenAnswer((_) async => Success(tCollaborator));

      final result = await checkCollaboratorUseCase.execute('48102030');

      expect(result.isSuccess, true);
      expect(result.successOrNull, tCollaborator);
      verify(() => mockRepository.checkCollaborator('48102030')).called(1);
    });
  });

  group('RegisterPassengerUseCase', () {
    test('should return TripEntity on success', () async {
      when(() => mockRepository.registerPassenger('TRIP-101', '48102030', any(), any(), any(), any(), any(), any()))
          .thenAnswer((_) async => Success(tTrip));

      final result = await registerPassengerUseCase.execute('TRIP-101', '48102030');

      expect(result.isSuccess, true);
      expect(result.successOrNull, tTrip);
    });
  });

  group('GetPassengersOnBoardUseCase', () {
    test('should return List<PassengerEntity> on success', () async {
      when(() => mockRepository.getPassengersOnBoard('TRIP-101'))
          .thenAnswer((_) async => Success([tPassenger]));

      final result = await getPassengersOnBoardUseCase.call('TRIP-101');

      expect(result.isSuccess, true);
      expect(result.successOrNull, [tPassenger]);
      verify(() => mockRepository.getPassengersOnBoard('TRIP-101')).called(1);
    });
  });
}
