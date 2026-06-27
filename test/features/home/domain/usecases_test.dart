import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/driver_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/dashboard_summary_entity.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_driver_info_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_today_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_pending_trips_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:mining_transport_app/features/home/domain/usecases/update_trip_status_usecase.dart';

class MockHomeDashboardRepository extends Mock implements HomeDashboardRepository {}

void main() {
  late MockHomeDashboardRepository mockRepository;
  late GetDriverInfoUseCase getDriverInfoUseCase;
  late GetTodayTripsUseCase getTodayTripsUseCase;
  late GetPendingTripsUseCase getPendingTripsUseCase;
  late GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  late UpdateTripStatusUseCase updateTripStatusUseCase;

  setUp(() {
    mockRepository = MockHomeDashboardRepository();
    getDriverInfoUseCase = GetDriverInfoUseCase(mockRepository);
    getTodayTripsUseCase = GetTodayTripsUseCase(mockRepository);
    getPendingTripsUseCase = GetPendingTripsUseCase(mockRepository);
    getDashboardSummaryUseCase = GetDashboardSummaryUseCase(mockRepository);
    updateTripStatusUseCase = UpdateTripStatusUseCase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(TripStatus.scheduled);
  });

  final tDriver = DriverEntity(
    id: 'DRV-998',
    name: 'Ricardo Ramos',
    code: 'COD-48102',
    status: DriverStatus.active,
    todayTripsCount: 2,
  );

  final tTrips = [
    TripEntity(
      id: 'TRIP-101',
      route: 'Mina - Campamento',
      scheduledTime: DateTime.now(),
      shift: 'Día',
      unitCode: 'BUS-01',
      capacity: 45,
      passengerCount: 40,
      status: TripStatus.inProgress,
    ),
  ];

  final tSummary = const DashboardSummaryEntity(
    completedTrips: 2,
    passengersTransported: 80,
    observationsRegistered: 1,
  );

  group('GetDriverInfoUseCase', () {
    test('debe retornar DriverEntity cuando el repositorio responde Success', () async {
      when(() => mockRepository.getDriverInfo())
          .thenAnswer((_) async => Success(tDriver));

      final result = await getDriverInfoUseCase.execute();

      expect(result.isSuccess, true);
      expect(result.successOrNull, tDriver);
      verify(() => mockRepository.getDriverInfo()).called(1);
    });
  });

  group('GetTodayTripsUseCase', () {
    test('debe retornar la lista de viajes cuando el repositorio responde Success', () async {
      when(() => mockRepository.getTodayTrips())
          .thenAnswer((_) async => Success(tTrips));

      final result = await getTodayTripsUseCase.execute();

      expect(result.isSuccess, true);
      expect(result.successOrNull, tTrips);
      verify(() => mockRepository.getTodayTrips()).called(1);
    });
  });

  group('GetPendingTripsUseCase', () {
    test('debe retornar la lista de viajes pendientes cuando el repositorio responde Success', () async {
      when(() => mockRepository.getPendingTrips())
          .thenAnswer((_) async => Success(tTrips));

      final result = await getPendingTripsUseCase.execute();

      expect(result.isSuccess, true);
      expect(result.successOrNull, tTrips);
      verify(() => mockRepository.getPendingTrips()).called(1);
    });
  });

  group('GetDashboardSummaryUseCase', () {
    test('debe retornar DashboardSummaryEntity cuando el repositorio responde Success', () async {
      when(() => mockRepository.getDashboardSummary())
          .thenAnswer((_) async => Success(tSummary));

      final result = await getDashboardSummaryUseCase.execute();

      expect(result.isSuccess, true);
      expect(result.successOrNull, tSummary);
      verify(() => mockRepository.getDashboardSummary()).called(1);
    });
  });

  group('UpdateTripStatusUseCase', () {
    test('debe actualizar el viaje exitosamente y retornar el nuevo TripEntity', () async {
      final updatedTrip = tTrips.first.copyWith(status: TripStatus.completed);
      when(() => mockRepository.updateTripStatus(any(), any()))
          .thenAnswer((_) async => Success(updatedTrip));

      final result = await updateTripStatusUseCase.execute('TRIP-101', TripStatus.completed);

      expect(result.isSuccess, true);
      expect(result.successOrNull, updatedTrip);
      verify(() => mockRepository.updateTripStatus('TRIP-101', TripStatus.completed)).called(1);
    });
  });
}
