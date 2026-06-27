// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaborator_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CollaboratorModel _$CollaboratorModelFromJson(Map<String, dynamic> json) {
  return _CollaboratorModel.fromJson(json);
}

/// @nodoc
mixin _$CollaboratorModel {
  String get dni => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this CollaboratorModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollaboratorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollaboratorModelCopyWith<CollaboratorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaboratorModelCopyWith<$Res> {
  factory $CollaboratorModelCopyWith(
    CollaboratorModel value,
    $Res Function(CollaboratorModel) then,
  ) = _$CollaboratorModelCopyWithImpl<$Res, CollaboratorModel>;
  @useResult
  $Res call({String dni, String fullName, String status});
}

/// @nodoc
class _$CollaboratorModelCopyWithImpl<$Res, $Val extends CollaboratorModel>
    implements $CollaboratorModelCopyWith<$Res> {
  _$CollaboratorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollaboratorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            dni: null == dni
                ? _value.dni
                : dni // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CollaboratorModelImplCopyWith<$Res>
    implements $CollaboratorModelCopyWith<$Res> {
  factory _$$CollaboratorModelImplCopyWith(
    _$CollaboratorModelImpl value,
    $Res Function(_$CollaboratorModelImpl) then,
  ) = __$$CollaboratorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String dni, String fullName, String status});
}

/// @nodoc
class __$$CollaboratorModelImplCopyWithImpl<$Res>
    extends _$CollaboratorModelCopyWithImpl<$Res, _$CollaboratorModelImpl>
    implements _$$CollaboratorModelImplCopyWith<$Res> {
  __$$CollaboratorModelImplCopyWithImpl(
    _$CollaboratorModelImpl _value,
    $Res Function(_$CollaboratorModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CollaboratorModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? status = null,
  }) {
    return _then(
      _$CollaboratorModelImpl(
        dni: null == dni
            ? _value.dni
            : dni // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollaboratorModelImpl implements _CollaboratorModel {
  const _$CollaboratorModelImpl({
    required this.dni,
    required this.fullName,
    required this.status,
  });

  factory _$CollaboratorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollaboratorModelImplFromJson(json);

  @override
  final String dni;
  @override
  final String fullName;
  @override
  final String status;

  @override
  String toString() {
    return 'CollaboratorModel(dni: $dni, fullName: $fullName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaboratorModelImpl &&
            (identical(other.dni, dni) || other.dni == dni) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dni, fullName, status);

  /// Create a copy of CollaboratorModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaboratorModelImplCopyWith<_$CollaboratorModelImpl> get copyWith =>
      __$$CollaboratorModelImplCopyWithImpl<_$CollaboratorModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CollaboratorModelImplToJson(this);
  }
}

abstract class _CollaboratorModel implements CollaboratorModel {
  const factory _CollaboratorModel({
    required final String dni,
    required final String fullName,
    required final String status,
  }) = _$CollaboratorModelImpl;

  factory _CollaboratorModel.fromJson(Map<String, dynamic> json) =
      _$CollaboratorModelImpl.fromJson;

  @override
  String get dni;
  @override
  String get fullName;
  @override
  String get status;

  /// Create a copy of CollaboratorModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollaboratorModelImplCopyWith<_$CollaboratorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
