import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/trip/domain/commands/create_trip_command.dart';
import 'package:mining_transport_app/features/trip/domain/repositories/trip_repository.dart';

/// Resuelve choferId sin asumir User.id == choferId.
///
/// Ver docs/architecture/create-trip-contract-gaps.md
abstract class ChoferIdResolver {
  Result<int, Failure> resolve(UserEntity user);
}

/// Bloquea creación hasta que exista contrato explícito de mapeo.
class UnresolvedChoferIdResolver implements ChoferIdResolver {
  const UnresolvedChoferIdResolver();

  @override
  Result<int, Failure> resolve(UserEntity user) {
    return const FailureResult(
      ValidationFailure(
        'No se puede crear el viaje: falta el contrato para resolver choferId '
        'desde la sesión. Bootstrap no incluye choferes y User.id no está '
        'confirmado como choferId. Ver documentación de brechas.',
      ),
    );
  }
}

/// Construye detalles de paraderos solo si hay relación Ruta → Paradero.
class TripStopDetailsBuilder {
  const TripStopDetailsBuilder();

  Result<List<CreateTripStopDetail>, Failure> build({
    required int routeId,
    required List<CatalogStop> stops,
  }) {
    final forRoute = stops
        .where((s) => s.routeId != null && s.routeId == routeId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (forRoute.isEmpty) {
      return const FailureResult(
        ValidationFailure(
          'No se puede crear el viaje: el catálogo de paraderos no relaciona '
          'paraderos con la ruta seleccionada (falta rutaId). '
          'No se enviarán paraderos arbitrarios.',
        ),
      );
    }

    return Success(
      forRoute
          .map(
            (s) => CreateTripStopDetail(
              paraderoId: s.id,
              orden: s.order > 0 ? s.order : forRoute.indexOf(s) + 1,
            ),
          )
          .toList(),
    );
  }
}

class CreateTripUseCase {
  CreateTripUseCase(
    this._repository, {
    ChoferIdResolver? choferIdResolver,
    TripStopDetailsBuilder? stopDetailsBuilder,
  })  : _choferIdResolver = choferIdResolver ?? const UnresolvedChoferIdResolver(),
        _stopDetailsBuilder =
            stopDetailsBuilder ?? const TripStopDetailsBuilder();

  final TripRepository _repository;
  final ChoferIdResolver _choferIdResolver;
  final TripStopDetailsBuilder _stopDetailsBuilder;

  Future<Result<CreatedTripResult, Failure>> execute({
    required UserEntity user,
    required CatalogBundle catalogs,
    required int routeId,
    required int serviceId,
    required int scheduleId,
    required int busId,
    required DateTime serviceDate,
  }) async {
    if (routeId <= 0 || serviceId <= 0 || scheduleId <= 0 || busId <= 0) {
      return const FailureResult(
        ValidationFailure('Complete ruta, servicio, horario y bus.'),
      );
    }

    final bus = catalogs.buses.where((b) => b.id == busId).firstOrNull;
    if (bus == null) {
      return const FailureResult(ValidationFailure('Bus no válido.'));
    }
    if (bus.capacity <= 0) {
      return const FailureResult(
        ValidationFailure('La capacidad del bus debe ser mayor a 0.'),
      );
    }

    final schedule =
        catalogs.schedules.where((s) => s.id == scheduleId).firstOrNull;
    if (schedule == null) {
      return const FailureResult(ValidationFailure('Horario no válido.'));
    }

    final choferResult = _choferIdResolver.resolve(user);
    if (choferResult.isFailure) {
      return FailureResult(choferResult.failureOrNull!);
    }

    final stopsResult = _stopDetailsBuilder.build(
      routeId: routeId,
      stops: catalogs.stops,
    );
    if (stopsResult.isFailure) {
      return FailureResult(stopsResult.failureOrNull!);
    }

    final command = CreateTripCommand(
      routeId: routeId,
      serviceId: serviceId,
      scheduleId: scheduleId,
      busId: busId,
      capacity: bus.capacity,
      scheduledAt: schedule.scheduledDateTimeOn(serviceDate),
      choferId: choferResult.successOrNull!,
      stopDetails: stopsResult.successOrNull!,
    );

    return _repository.createTrip(command);
  }
}
