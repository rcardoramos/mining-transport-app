import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/home_dashboard_data.dart';

part 'home_dashboard_state.freezed.dart';
part 'home_dashboard_state.g.dart';

@freezed
class HomeDashboardState with _$HomeDashboardState {
  const factory HomeDashboardState({
    @Default(true) bool isLoading,
    @Default(false) bool isRefreshing,
    String? errorMessage,
    HomeDashboardData? data,
  }) = _HomeDashboardState;

  factory HomeDashboardState.fromJson(Map<String, dynamic> json) =>
      _$HomeDashboardStateFromJson(json);
}
