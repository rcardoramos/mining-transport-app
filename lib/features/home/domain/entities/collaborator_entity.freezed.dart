// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collaborator_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CollaboratorEntity _$CollaboratorEntityFromJson(Map<String, dynamic> json) {
  return _CollaboratorEntity.fromJson(json);
}

/// @nodoc
mixin _$CollaboratorEntity {
  String get dni => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  CollaboratorStatus get status => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this CollaboratorEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CollaboratorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollaboratorEntityCopyWith<CollaboratorEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollaboratorEntityCopyWith<$Res> {
  factory $CollaboratorEntityCopyWith(
    CollaboratorEntity value,
    $Res Function(CollaboratorEntity) then,
  ) = _$CollaboratorEntityCopyWithImpl<$Res, CollaboratorEntity>;
  @useResult
  $Res call({
    String dni,
    String fullName,
    CollaboratorStatus status,
    String category,
  });
}

/// @nodoc
class _$CollaboratorEntityCopyWithImpl<$Res, $Val extends CollaboratorEntity>
    implements $CollaboratorEntityCopyWith<$Res> {
  _$CollaboratorEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CollaboratorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? status = null,
    Object? category = null,
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
                      as CollaboratorStatus,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CollaboratorEntityImplCopyWith<$Res>
    implements $CollaboratorEntityCopyWith<$Res> {
  factory _$$CollaboratorEntityImplCopyWith(
    _$CollaboratorEntityImpl value,
    $Res Function(_$CollaboratorEntityImpl) then,
  ) = __$$CollaboratorEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dni,
    String fullName,
    CollaboratorStatus status,
    String category,
  });
}

/// @nodoc
class __$$CollaboratorEntityImplCopyWithImpl<$Res>
    extends _$CollaboratorEntityCopyWithImpl<$Res, _$CollaboratorEntityImpl>
    implements _$$CollaboratorEntityImplCopyWith<$Res> {
  __$$CollaboratorEntityImplCopyWithImpl(
    _$CollaboratorEntityImpl _value,
    $Res Function(_$CollaboratorEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CollaboratorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? status = null,
    Object? category = null,
  }) {
    return _then(
      _$CollaboratorEntityImpl(
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
                  as CollaboratorStatus,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollaboratorEntityImpl implements _CollaboratorEntity {
  const _$CollaboratorEntityImpl({
    required this.dni,
    required this.fullName,
    required this.status,
    this.category = 'Miski Mayo',
  });

  factory _$CollaboratorEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollaboratorEntityImplFromJson(json);

  @override
  final String dni;
  @override
  final String fullName;
  @override
  final CollaboratorStatus status;
  @override
  @JsonKey()
  final String category;

  @override
  String toString() {
    return 'CollaboratorEntity(dni: $dni, fullName: $fullName, status: $status, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollaboratorEntityImpl &&
            (identical(other.dni, dni) || other.dni == dni) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dni, fullName, status, category);

  /// Create a copy of CollaboratorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollaboratorEntityImplCopyWith<_$CollaboratorEntityImpl> get copyWith =>
      __$$CollaboratorEntityImplCopyWithImpl<_$CollaboratorEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CollaboratorEntityImplToJson(this);
  }
}

abstract class _CollaboratorEntity implements CollaboratorEntity {
  const factory _CollaboratorEntity({
    required final String dni,
    required final String fullName,
    required final CollaboratorStatus status,
    final String category,
  }) = _$CollaboratorEntityImpl;

  factory _CollaboratorEntity.fromJson(Map<String, dynamic> json) =
      _$CollaboratorEntityImpl.fromJson;

  @override
  String get dni;
  @override
  String get fullName;
  @override
  CollaboratorStatus get status;
  @override
  String get category;

  /// Create a copy of CollaboratorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollaboratorEntityImplCopyWith<_$CollaboratorEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
