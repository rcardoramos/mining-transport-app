import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/manifest/data/datasources/manifest_remote_data_source.dart';
import 'package:mining_transport_app/features/manifest/data/models/manifest_dto.dart';
import 'package:mining_transport_app/features/manifest/data/repositories/manifest_repository_impl.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/collaborator_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';

class MockRemote extends Mock implements ManifestRemoteDataSource {}

class MockHomeRepo extends Mock implements HomeDashboardRepository {}

class MockLogger extends Mock implements AppLogger {}

void main() {
  late MockRemote remote;
  late MockHomeRepo home;
  late MockLogger logger;
  late ManifestRepositoryImpl repo;

  final passengers = [
    PassengerEntity(
      dni: '11111111',
      fullName: 'A',
      boardedAt: DateTime(2026, 8, 16, 21),
      registrationMethod: 'manual',
      status: CollaboratorStatus.ok,
    ),
  ];

  setUp(() {
    remote = MockRemote();
    home = MockHomeRepo();
    logger = MockLogger();
    repo = ManifestRepositoryImpl(remote, home, logger);
  });

  test('online usa Viaje/Manifiesto', () async {
    when(() => remote.fetchViajeManifiesto('55')).thenAnswer(
      (_) async => ManifestDto(passengers: passengers, estado: 'A'),
    );
    final result = await repo.fetchManifest('55', isOnline: true);
    expect(result.isSuccess, true);
    expect(result.successOrNull!.passengers.length, 1);
    verifyNever(() => home.getPassengersOnBoard(any()));
  });

  test('offline usa lista local', () async {
    when(() => home.getPassengersOnBoard('55')).thenAnswer(
      (_) async => Success(passengers),
    );
    final result = await repo.fetchManifest('55', isOnline: false);
    expect(result.isSuccess, true);
    verifyNever(() => remote.fetchViajeManifiesto(any()));
  });

  test('restricción solo viajes cerrados NO hace fallback silencioso', () async {
    when(() => remote.fetchViajeManifiesto('55')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: 'api/Viaje/Manifiesto'),
        response: Response(
          requestOptions: RequestOptions(path: 'api/Viaje/Manifiesto'),
          statusCode: 400,
          data: {
            'Success': false,
            'Message': 'Solo se permite manifiesto de viajes cerrados',
          },
        ),
        type: DioExceptionType.badResponse,
        message: 'Solo se permite manifiesto de viajes cerrados',
      ),
    );

    final result = await repo.fetchManifest('55', isOnline: true);
    expect(result.isFailure, true);
    expect(result.failureOrNull?.message, contains('cerrados'));
    verifyNever(() => home.getPassengersOnBoard(any()));
  });

  test('error de red sí hace fallback a lista local', () async {
    when(() => remote.fetchViajeManifiesto('55')).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: 'api/Viaje/Manifiesto'),
        type: DioExceptionType.connectionTimeout,
        message: 'timeout',
      ),
    );
    when(() => home.getPassengersOnBoard('55')).thenAnswer(
      (_) async => Success(passengers),
    );

    final result = await repo.fetchManifest('55', isOnline: true);
    expect(result.isSuccess, true);
    expect(result.successOrNull!.passengers.length, 1);
  });
}
