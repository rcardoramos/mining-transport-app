import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/driver_entity.dart';
import '../repositories/home_dashboard_repository.dart';

class GetDriverInfoUseCase {
  final HomeDashboardRepository _repository;

  GetDriverInfoUseCase(this._repository);

  Future<Result<DriverEntity, Failure>> execute() {
    return _repository.getDriverInfo();
  }
}
