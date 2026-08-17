import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';

abstract class ManifestRepository {
  /// Consulta manifiesto vigente vía API (o fallback offline) sin alterar el viaje.
  Future<Result<ManifestSnapshot, Failure>> fetchManifest(
    String tripId, {
    required bool isOnline,
  });
}
