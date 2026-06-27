import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/core/database/app_database.dart' as db;
import 'package:mining_transport_app/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String fullName,
    required String role,
    String? token,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Convierte un [UserEntity] de dominio a este [UserModel] de datos.
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        username: entity.username,
        fullName: entity.fullName,
        role: entity.role,
        token: entity.token,
      );

  /// Convierte este [UserModel] de datos a la entidad inmutable [UserEntity].
  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        fullName: fullName,
        role: role,
        token: token,
      );

  /// Convierte la clase de datos generada por Drift ([db.User]) a este [UserModel].
  factory UserModel.fromDrift(db.User user) => UserModel(
        id: user.id,
        username: user.username,
        fullName: user.fullName,
        role: user.role,
        token: user.token,
      );

  /// Convierte este [UserModel] a la clase de datos de base de datos relacional ([db.User]).
  db.User toDrift() => db.User(
        id: id,
        username: username,
        fullName: fullName,
        role: role,
        token: token,
      );
}
