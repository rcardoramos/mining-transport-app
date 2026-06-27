// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeDashboardDataImpl _$$HomeDashboardDataImplFromJson(
  Map<String, dynamic> json,
) => _$HomeDashboardDataImpl(
  driver: DriverEntity.fromJson(json['driver'] as Map<String, dynamic>),
  todayTrips: (json['todayTrips'] as List<dynamic>)
      .map((e) => TripEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  pendingTrips: (json['pendingTrips'] as List<dynamic>)
      .map((e) => TripEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  summary: DashboardSummaryEntity.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$HomeDashboardDataImplToJson(
  _$HomeDashboardDataImpl instance,
) => <String, dynamic>{
  'driver': instance.driver,
  'todayTrips': instance.todayTrips,
  'pendingTrips': instance.pendingTrips,
  'summary': instance.summary,
};
