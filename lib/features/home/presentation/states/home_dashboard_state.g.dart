// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeDashboardStateImpl _$$HomeDashboardStateImplFromJson(
  Map<String, dynamic> json,
) => _$HomeDashboardStateImpl(
  isLoading: json['isLoading'] as bool? ?? true,
  isRefreshing: json['isRefreshing'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
  data: json['data'] == null
      ? null
      : HomeDashboardData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$HomeDashboardStateImplToJson(
  _$HomeDashboardStateImpl instance,
) => <String, dynamic>{
  'isLoading': instance.isLoading,
  'isRefreshing': instance.isRefreshing,
  'errorMessage': instance.errorMessage,
  'data': instance.data,
};
