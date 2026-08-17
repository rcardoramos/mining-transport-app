import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/trip/domain/usecases/create_trip_usecase.dart';

/// Resuelve `choferId` desde `User.driverId` del Login.
///
/// Contrato staging confirmado:
/// `{ "driverId": "1", "id": "000000888", ... }` → `choferId = 1`.
/// No usar `User.id` como choferId.
class EnvAwareChoferIdResolver implements ChoferIdResolver {
  const EnvAwareChoferIdResolver();

  @override
  Result<int, Failure> resolve(UserEntity user) {
    final fromDriverId = tryParseChoferId(user.driverId);
    if (fromDriverId != null) {
      return Success(fromDriverId);
    }

    // Solo DEV: permitir flujo UI con mock si Login no trae driverId.
    if (EnvConfig.instance.environment == AppEnvironment.dev) {
      return const Success(1);
    }

    return const FailureResult(
      ValidationFailure(
        'No se puede crear el viaje: el Login no devolvió driverId (código de chofer). '
        'Cierre sesión e inicie nuevamente, o solicite el campo al backend.',
      ),
    );
  }

  /// `"1"` / `"0001"` → 1; rechaza vacío / 0 / no numérico.
  static int? tryParseChoferId(String? raw) {
    if (raw == null) return null;
    final cleaned = raw.trim();
    if (cleaned.isEmpty) return null;
    final parsed = int.tryParse(cleaned);
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }
}
