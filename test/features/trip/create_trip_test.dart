import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/catalog/data/models/catalog_models.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/home/presentation/viewmodels/create_trip_viewmodel.dart';
import 'package:mining_transport_app/features/trip/data/models/create_trip_dto.dart';
import 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart';
import 'package:mining_transport_app/features/trip/domain/repositories/trip_repository.dart';
import 'package:mining_transport_app/features/trip/domain/usecases/create_trip_usecase.dart';

class MockTripRepository extends Mock implements TripRepository {}

class _FixedChoferResolver implements ChoferIdResolver {
  _FixedChoferResolver(this.id);
  final int id;

  @override
  Result<int, Failure> resolve(UserEntity user) => Success(id);
}

void main() {
  group('CatalogBootstrapModel', () {
    test('parsea Bootstrap exitoso', () {
      final model = CatalogBootstrapModel.fromJson({
        'Rutas': [
          {'id': 1, 'nombre': 'Piura / Bayovar', 'distanciaKm': 120}
        ],
        'Servicios': [
          {'id': 1, 'nombre': 'Administrativo'}
        ],
        'Horarios': [
          {'id': 1, 'horaSalida': '06:00:00'}
        ],
        'Buses': [
          {'id': 1, 'placa': 'ABC-123', 'capacidad': 40, 'modelo': 'Mercedes'}
        ],
        'Paraderos': [
          {
            'id': 5,
            'nombre': 'Óvalo',
            'latitud': -5.1,
            'longitud': -80.6,
            'radioPermitido': 50,
            'orden': 1,
            'rutaId': 1,
          }
        ],
      });

      final entity = model.toEntity();
      expect(entity.routes.first.displayLabel, 'Piura → Bayovar');
      expect(entity.services.first.name, 'Administrativo');
      expect(entity.schedules.first.displayLabel, 'Mañana · 06:00');
      expect(entity.buses.first.plate, 'ABC-123');
      expect(entity.buses.first.model, 'Mercedes');
      expect(entity.buses.first.capacity, 40);
      expect(entity.stops.first.routeId, 1);
    });
    test('parsea Marca de staging como modelo', () {
      final bus = CatalogBusModel.fromJson({
        'BusId': 1,
        'Placa': 'ABC-123',
        'Marca': 'Mercedes Benz',
        'Capacidad': 40,
        'Estado': 'A',
      });
      expect(bus.model, 'Mercedes Benz');
      expect(bus.plate, 'ABC-123');
      expect(bus.capacity, 40);
    });
  });

  group('CreateTripRequestDto', () {
    test('omite estado y fechaApertura', () {
      final dto = CreateTripRequestDto.fromCommand(
        usuario: 'cealvarez',
        token: 'tok',
        command: CreateTripCommand(
          routeId: 2,
          serviceId: 1,
          scheduleId: 2,
          busId: 1,
          capacity: 40,
          scheduledAt: DateTime(2026, 8, 15, 14),
          choferId: 1,
          stopDetails: const [
            CreateTripStopDetail(paraderoId: 5, orden: 1),
          ],
        ),
      );
      final json = dto.toJson();
      expect(json.containsKey('estado'), false);
      expect(json.containsKey('fechaApertura'), false);
      expect(json['fechaProgramado'], '2026-08-15T14:00:00');
      expect(json['rutaId'], 2);
      expect(json['detalles'], [
        {'paraderoId': 5, 'orden': 1}
      ]);
    });
  });

  group('CreateTripResponseDto', () {
    test('mapea respuesta a dominio', () {
      final dto = CreateTripResponseDto.fromJson({
        'ViajeId': 55,
        'Numero': '000055',
        'Estado': 'P',
      });
      final domain = dto.toDomain();
      expect(domain.viajeId, '55');
      expect(domain.numero, '000055');
      expect(domain.estado, 'P');
    });
  });

  group('TripStopDetailsBuilder', () {
    const builder = TripStopDetailsBuilder();

    test('falla si no hay paraderos con rutaId', () {
      final result = builder.build(
        routeId: 1,
        stops: const [
          CatalogStop(
            id: 5,
            name: 'X',
            latitude: 0,
            longitude: 0,
            allowedRadiusMeters: 50,
            order: 1,
          ),
        ],
      );
      expect(result.isFailure, true);
    });

    test('filtra paraderos de la ruta', () {
      final result = builder.build(
        routeId: 1,
        stops: const [
          CatalogStop(
            id: 5,
            name: 'A',
            latitude: 0,
            longitude: 0,
            allowedRadiusMeters: 50,
            order: 2,
            routeId: 1,
          ),
          CatalogStop(
            id: 6,
            name: 'B',
            latitude: 0,
            longitude: 0,
            allowedRadiusMeters: 50,
            order: 1,
            routeId: 1,
          ),
          CatalogStop(
            id: 7,
            name: 'C',
            latitude: 0,
            longitude: 0,
            allowedRadiusMeters: 50,
            order: 1,
            routeId: 2,
          ),
        ],
      );
      expect(result.isSuccess, true);
      final details = result.successOrNull!;
      expect(details.length, 2);
      expect(details.first.paraderoId, 6);
      expect(details.last.paraderoId, 5);
    });
  });

  group('UnresolvedChoferIdResolver', () {
    test('no asume User.id como choferId', () {
      const resolver = UnresolvedChoferIdResolver();
      final result = resolver.resolve(
        const UserEntity(
          id: '1',
          username: 'cealvarez',
          fullName: 'Carlos',
          role: 'DRIVER',
        ),
      );
      expect(result.isFailure, true);
    });
  });

  group('CreateTripUseCase', () {
    late MockTripRepository repo;
    late CreateTripUseCase useCase;

    setUp(() {
      repo = MockTripRepository();
      useCase = CreateTripUseCase(
        repo,
        choferIdResolver: const UnresolvedChoferIdResolver(),
      );
      registerFallbackValue(
        CreateTripCommand(
          routeId: 1,
          serviceId: 1,
          scheduleId: 1,
          busId: 1,
          capacity: 40,
          scheduledAt: DateTime(2026, 1, 1),
          choferId: 1,
          stopDetails: const [],
        ),
      );
    });

    final catalogs = CatalogBundle(
      routes: const [CatalogRoute(id: 1, name: 'Piura / Bayovar')],
      services: const [CatalogService(id: 1, name: 'Operativo')],
      schedules: const [CatalogSchedule(id: 1, departureTime: '06:00:00')],
      buses: const [
        CatalogBus(id: 1, plate: 'ABC-123', capacity: 40, model: 'MB'),
      ],
      stops: const [
        CatalogStop(
          id: 5,
          name: 'A',
          latitude: 0,
          longitude: 0,
          allowedRadiusMeters: 50,
          order: 1,
          routeId: 1,
        ),
      ],
    );

    test('bloquea por choferId sin contrato', () async {
      final result = await useCase.execute(
        user: const UserEntity(
          id: 'DRV-1',
          username: 'u',
          fullName: 'U',
          role: 'DRIVER',
        ),
        catalogs: catalogs,
        routeId: 1,
        serviceId: 1,
        scheduleId: 1,
        busId: 1,
        serviceDate: DateTime(2026, 8, 16),
      );
      expect(result.isFailure, true);
      verifyNever(() => repo.createTrip(any()));
    });

    test('crea cuando resolver y paraderos OK', () async {
      useCase = CreateTripUseCase(
        repo,
        choferIdResolver: _FixedChoferResolver(9),
      );
      when(() => repo.createTrip(any())).thenAnswer(
        (_) async => const Success(
          CreatedTripResult(viajeId: '99', estado: 'P'),
        ),
      );

      final result = await useCase.execute(
        user: const UserEntity(
          id: 'DRV-1',
          username: 'u',
          fullName: 'U',
          role: 'DRIVER',
        ),
        catalogs: catalogs,
        routeId: 1,
        serviceId: 1,
        scheduleId: 1,
        busId: 1,
        serviceDate: DateTime(2026, 8, 16),
      );
      expect(result.isSuccess, true);
      expect(result.successOrNull?.viajeId, '99');
      verify(() => repo.createTrip(any())).called(1);
    });

    test('formulario inválido sin bus', () async {
      final result = await useCase.execute(
        user: const UserEntity(
          id: '1',
          username: 'u',
          fullName: 'U',
          role: 'DRIVER',
        ),
        catalogs: catalogs,
        routeId: 1,
        serviceId: 1,
        scheduleId: 1,
        busId: 999,
        serviceDate: DateTime(2026, 8, 16),
      );
      expect(result.isFailure, true);
    });
  });

  group('CreateTripState form', () {
    test('autocompleta marca y capacidad desde bus', () {
      const catalogs = CatalogBundle(
        routes: [],
        services: [],
        schedules: [],
        buses: [
          CatalogBus(id: 3, plate: 'XYZ', capacity: 44, model: 'Volvo'),
        ],
        stops: [],
      );
      final state = CreateTripState(
        phase: CreateTripPhase.ready,
        catalogs: catalogs,
        selectedBusId: 3,
        selectedRouteId: 1,
        selectedServiceId: 1,
        selectedScheduleId: 1,
        user: const UserEntity(
          id: '1',
          username: 'u',
          fullName: 'U',
          role: 'DRIVER',
        ),
      );
      expect(state.selectedBus?.model, 'Volvo');
      expect(state.selectedBus?.capacity, 44);
      expect(state.isFormValid, true);
    });
  });
}
