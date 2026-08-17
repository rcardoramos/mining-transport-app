import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/time/clock.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';
import 'package:mining_transport_app/features/manifest/domain/repositories/manifest_repository.dart';
import 'package:mining_transport_app/features/manifest/domain/usecases/generate_manifest_usecase.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';

class MockManifestRepository extends Mock implements ManifestRepository {}

void main() {
  late MockManifestRepository repo;
  late FakeClock clock;
  late GenerateManifestUseCase useCase;

  final tripInProgress = TripEntity(
    id: '55',
    route: 'Piura / Bayovar',
    scheduledTime: DateTime(2026, 8, 16, 22),
    shift: 'Noche',
    unitCode: 'ABC-123',
    capacity: 40,
    passengerCount: 2,
    status: TripStatus.inProgress,
  );

  final tripScheduled = tripInProgress.copyWith(status: TripStatus.scheduled);

  final passengers = [
    PassengerEntity(
      dni: '11111111',
      fullName: 'A',
      boardedAt: DateTime(2026, 8, 16, 21),
      registrationMethod: 'manual',
      status: CollaboratorStatus.ok,
    ),
    PassengerEntity(
      dni: '22222222',
      fullName: 'B',
      boardedAt: DateTime(2026, 8, 16, 21, 5),
      registrationMethod: 'qr_scan',
      status: CollaboratorStatus.ok,
    ),
  ];

  setUpAll(() {
    registerFallbackValue(false);
  });

  setUp(() {
    repo = MockManifestRepository();
    clock = FakeClock(DateTime(2026, 8, 16, 10, 15));
    useCase = GenerateManifestUseCase(repo, clock);
  });

  group('GenerateManifestUseCase.canGenerateForStatus', () {
    test('permite EN CURSO y FINALIZADO', () {
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.inProgress), true);
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.travelling), true);
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.completed), true);
    });

    test('bloquea POR INICIAR / programado / cancelado', () {
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.scheduled), false);
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.readyToStart), false);
      expect(GenerateManifestUseCase.canGenerateForStatus(TripStatus.cancelled), false);
    });
  });

  group('GenerateManifestUseCase.execute', () {
    test('falla si el viaje está por iniciar', () async {
      final result = await useCase.execute(
        trip: tripScheduled,
        driverName: 'Chofer',
        isOnline: true,
      );
      expect(result.isFailure, true);
      verifyNever(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline')));
    });

    test('falla sin pasajeros', () async {
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => const Success(
          ManifestSnapshot(tripId: '55', passengers: []),
        ),
      );
      final result = await useCase.execute(
        trip: tripInProgress,
        driverName: 'Chofer',
        isOnline: true,
      );
      expect(result.isFailure, true);
      expect(
        result.failureOrNull?.message,
        contains('Aún no existen pasajeros'),
      );
    });

    test('éxito con pasajeros y no muta estado del viaje', () async {
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => Success(
          ManifestSnapshot(tripId: '55', passengers: passengers),
        ),
      );
      final result = await useCase.execute(
        trip: tripInProgress,
        driverName: 'Chofer',
        isOnline: true,
      );
      expect(result.isSuccess, true);
      final value = result.successOrNull!;
      expect(value.snapshot.passengers.length, 2);
      expect(value.trip.status, TripStatus.inProgress);
      expect(value.statusLabel, 'EN CURSO');
      expect(value.fileName, 'manifiesto_viaje_55_20260816_1015.pdf');
    });

    test('segunda generación refleja más pasajeros', () async {
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => Success(
          ManifestSnapshot(tripId: '55', passengers: passengers),
        ),
      );
      final first = await useCase.execute(
        trip: tripInProgress,
        driverName: 'C',
        isOnline: true,
      );
      expect(first.successOrNull!.snapshot.passengers.length, 2);

      final more = [
        ...passengers,
        PassengerEntity(
          dni: '33333333',
          fullName: 'C',
          boardedAt: DateTime(2026, 8, 16, 21, 10),
          registrationMethod: 'manual',
          status: CollaboratorStatus.ok,
        ),
      ];
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => Success(
          ManifestSnapshot(tripId: '55', passengers: more),
        ),
      );
      final second = await useCase.execute(
        trip: tripInProgress,
        driverName: 'C',
        isOnline: true,
      );
      expect(second.successOrNull!.snapshot.passengers.length, 3);
    });

    test('propaga error de API', () async {
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => const FailureResult(
          ServerFailure('Solo viajes cerrados'),
        ),
      );
      final result = await useCase.execute(
        trip: tripInProgress,
        driverName: 'Chofer',
        isOnline: true,
      );
      expect(result.isFailure, true);
      expect(result.failureOrNull?.message, 'Solo viajes cerrados');
    });

    test('usa fallback local si API trae lista vacía', () async {
      when(() => repo.fetchManifest(any(), isOnline: any(named: 'isOnline'))).thenAnswer(
        (_) async => const Success(
          ManifestSnapshot(tripId: '55', passengers: []),
        ),
      );
      final result = await useCase.execute(
        trip: tripInProgress,
        driverName: 'Chofer',
        isOnline: false,
        localPassengersFallback: passengers,
      );
      expect(result.isSuccess, true);
      expect(result.successOrNull!.snapshot.passengers.length, 2);
    });
  });
}
