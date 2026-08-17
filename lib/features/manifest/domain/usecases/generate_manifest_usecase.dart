import 'package:mining_transport_app/core/time/clock.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';
import 'package:mining_transport_app/features/manifest/domain/repositories/manifest_repository.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';

/// Genera/consulta el manifiesto vigente sin cambiar el estado del viaje.
class GenerateManifestUseCase {
  GenerateManifestUseCase(this._repository, this._clock);

  final ManifestRepository _repository;
  final Clock _clock;

  /// Estados en los que se permite generar manifiesto.
  static bool canGenerateForStatus(TripStatus status) {
    return status == TripStatus.inProgress ||
        status == TripStatus.travelling ||
        status == TripStatus.completed;
  }

  Future<Result<ManifestGenerationResult, Failure>> execute({
    required TripEntity trip,
    required String driverName,
    required bool isOnline,
    List<PassengerEntity>? localPassengersFallback,
  }) async {
    if (!canGenerateForStatus(trip.status)) {
      return const FailureResult(
        ValidationFailure(
          'El manifiesto solo está disponible con el viaje en curso o finalizado.',
        ),
      );
    }

    final fetch = await _repository.fetchManifest(
      trip.id,
      isOnline: isOnline,
    );
    if (fetch.isFailure) {
      return FailureResult(fetch.failureOrNull!);
    }

    var snapshot = fetch.successOrNull!;
    if (!snapshot.hasPassengers &&
        localPassengersFallback != null &&
        localPassengersFallback.isNotEmpty) {
      snapshot = ManifestSnapshot(
        tripId: trip.id,
        passengers: localPassengersFallback,
        source: ManifestDataSource.passengersList,
      );
    }

    if (!snapshot.hasPassengers) {
      return const FailureResult(
        ValidationFailure(
          'Aún no existen pasajeros registrados para generar el manifiesto.',
        ),
      );
    }

    return Success(
      ManifestGenerationResult(
        snapshot: snapshot,
        trip: trip,
        driverName: snapshot.headerDriverName?.isNotEmpty == true
            ? snapshot.headerDriverName!
            : driverName,
        generatedAt: _clock.now(),
      ),
    );
  }
}
