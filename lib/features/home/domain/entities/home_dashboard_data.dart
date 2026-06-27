import 'package:freezed_annotation/freezed_annotation.dart';
import 'driver_entity.dart';
import 'trip_entity.dart';
import 'dashboard_summary_entity.dart';

part 'home_dashboard_data.freezed.dart';
part 'home_dashboard_data.g.dart';

@freezed
class HomeDashboardData with _$HomeDashboardData {
  const factory HomeDashboardData({
    required DriverEntity driver,
    required List<TripEntity> todayTrips,
    required List<TripEntity> pendingTrips,
    required DashboardSummaryEntity summary,
  }) = _HomeDashboardData;

  factory HomeDashboardData.fromJson(Map<String, dynamic> json) => _$HomeDashboardDataFromJson(json);
}
