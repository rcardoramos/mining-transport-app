import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary_entity.freezed.dart';
part 'dashboard_summary_entity.g.dart';

@freezed
class DashboardSummaryEntity with _$DashboardSummaryEntity {
  const factory DashboardSummaryEntity({
    required int completedTrips,
    required int passengersTransported,
    required int observationsRegistered,
  }) = _DashboardSummaryEntity;

  factory DashboardSummaryEntity.fromJson(Map<String, dynamic> json) => _$DashboardSummaryEntityFromJson(json);
}
