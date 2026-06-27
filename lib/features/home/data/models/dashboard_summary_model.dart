import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

part 'dashboard_summary_model.freezed.dart';
part 'dashboard_summary_model.g.dart';

@freezed
class DashboardSummaryModel with _$DashboardSummaryModel {
  const factory DashboardSummaryModel({
    required int completedTrips,
    required int passengersTransported,
    required int observationsRegistered,
  }) = _DashboardSummaryModel;

  const DashboardSummaryModel._();

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryModelFromJson(json);

  DashboardSummaryEntity toEntity() {
    return DashboardSummaryEntity(
      completedTrips: completedTrips,
      passengersTransported: passengersTransported,
      observationsRegistered: observationsRegistered,
    );
  }
}
