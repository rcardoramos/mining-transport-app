import 'package:mining_transport_app/core/constants/env_config.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';
import 'package:mining_transport_app/features/trip/domain/usecases/create_trip_usecase.dart';

/// En DEV permite probar el flujo completo con choferId mock (1).
/// En staging/prod permanece bloqueado hasta contrato backend.
class EnvAwareChoferIdResolver implements ChoferIdResolver {
  const EnvAwareChoferIdResolver();

  @override
  Result<int, Failure> resolve(UserEntity user) {
    if (EnvConfig.instance.environment == AppEnvironment.dev) {
      return const Success(1);
    }
    return const UnresolvedChoferIdResolver().resolve(user);
  }
}
