// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardSummaryEntityImpl _$$DashboardSummaryEntityImplFromJson(
  Map<String, dynamic> json,
) => _$DashboardSummaryEntityImpl(
  completedTrips: (json['completedTrips'] as num).toInt(),
  passengersTransported: (json['passengersTransported'] as num).toInt(),
  observationsRegistered: (json['observationsRegistered'] as num).toInt(),
);

Map<String, dynamic> _$$DashboardSummaryEntityImplToJson(
  _$DashboardSummaryEntityImpl instance,
) => <String, dynamic>{
  'completedTrips': instance.completedTrips,
  'passengersTransported': instance.passengersTransported,
  'observationsRegistered': instance.observationsRegistered,
};
