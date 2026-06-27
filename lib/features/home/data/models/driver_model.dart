import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/driver_entity.dart';

part 'driver_model.freezed.dart';
part 'driver_model.g.dart';

@freezed
class DriverModel with _$DriverModel {
  const factory DriverModel({
    required String id,
    required String name,
    required String code,
    required String status,
    required int todayTripsCount,
    String? avatarUrl,
  }) = _DriverModel;

  const DriverModel._();

  factory DriverModel.fromJson(Map<String, dynamic> json) => _$DriverModelFromJson(json);

  DriverEntity toEntity() {
    return DriverEntity(
      id: id,
      name: name,
      code: code,
      status: DriverStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => DriverStatus.inactive,
      ),
      todayTripsCount: todayTripsCount,
      avatarUrl: avatarUrl,
    );
  }
}
