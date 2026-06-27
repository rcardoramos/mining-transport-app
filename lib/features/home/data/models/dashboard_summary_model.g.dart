// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryModelImpl _$$DashboardSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryModelImpl(
  completedTrips: (json['completedTrips'] as num).toInt(),
  passengersTransported: (json['passengersTransported'] as num).toInt(),
  observationsRegistered: (json['observationsRegistered'] as num).toInt(),
);

Map<String, dynamic> _$$DashboardSummaryModelImplToJson(
  _$DashboardSummaryModelImpl instance,
) => <String, dynamic>{
  'completedTrips': instance.completedTrips,
  'passengersTransported': instance.passengersTransported,
  'observationsRegistered': instance.observationsRegistered,
};
