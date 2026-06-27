import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/dashboard_summary_entity.dart';
import '../repositories/home_dashboard_repository.dart';

class GetDashboardSummaryUseCase {
  final HomeDashboardRepository _repository;

  GetDashboardSummaryUseCase(this._repository);

  Future<Result<DashboardSummaryEntity, Failure>> execute() {
    return _repository.getDashboardSummary();
  }
}
