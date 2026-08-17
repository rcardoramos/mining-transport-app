import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/core/database/app_database.dart' as db;
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String fullName,
    required String role,
    String? token,
    String? driverId,
  }) = _UserModel;

  const UserModel._();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'role': role,
      'token': token,
      'driverId': driverId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final idVal = json['id'] ?? json['Id'] ?? '';
    final id = idVal.toString();

    final usernameVal = json['username'] ?? json['Username'] ?? '';
    final username = usernameVal.toString();

    final fullNameVal =
        json['fullName'] ?? json['FullName'] ?? json['NombreCompleto'] ?? '';
    final fullName = fullNameVal.toString();

    final roleVal = json['role'] ?? json['Role'] ?? 'DRIVER';
    final role = roleVal.toString();

    final tokenVal = json['token'] ?? json['Token'];
    final token = tokenVal?.toString();

    final driverRaw = json['driverId'] ??
        json['DriverId'] ??
        json['choferId'] ??
        json['ChoferId'];
    final driverId = driverRaw?.toString().trim();
    final normalizedDriverId =
        (driverId == null || driverId.isEmpty) ? null : driverId;

    return UserModel(
      id: id,
      username: username,
      fullName: fullName,
      role: role,
      token: token,
      driverId: normalizedDriverId,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        username: entity.username,
        fullName: entity.fullName,
        role: entity.role,
        token: entity.token,
        driverId: entity.driverId,
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        fullName: fullName,
        role: role,
        token: token,
        driverId: driverId,
      );

  factory UserModel.fromDrift(db.User user) => UserModel(
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        role: user.role,
        token: user.token,
        driverId: user.driverId,
      );

  db.User toDrift() => db.User(
        id: id,
        username: username,
        fullName: fullName,
        role: role,
        token: token,
        driverId: driverId,
      );
}
