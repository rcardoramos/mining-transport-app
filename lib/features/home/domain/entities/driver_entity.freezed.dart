// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DriverEntity _$DriverEntityFromJson(Map<String, dynamic> json) {
  return _DriverEntity.fromJson(json);
}

/// @nodoc
mixin _$DriverEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  DriverStatus get status => throw _privateConstructorUsedError;
  int get todayTripsCount => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this DriverEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverEntityCopyWith<DriverEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverEntityCopyWith<$Res> {
  factory $DriverEntityCopyWith(
    DriverEntity value,
    $Res Function(DriverEntity) then,
  ) = _$DriverEntityCopyWithImpl<$Res, DriverEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    String code,
    DriverStatus status,
    int todayTripsCount,
    String? avatarUrl,
  });
}

/// @nodoc
class _$DriverEntityCopyWithImpl<$Res, $Val extends DriverEntity>
    implements $DriverEntityCopyWith<$Res> {
  _$DriverEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? status = null,
    Object? todayTripsCount = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DriverStatus,
            todayTripsCount: null == todayTripsCount
                ? _value.todayTripsCount
                : todayTripsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DriverEntityImplCopyWith<$Res>
    implements $DriverEntityCopyWith<$Res> {
  factory _$$DriverEntityImplCopyWith(
    _$DriverEntityImpl value,
    $Res Function(_$DriverEntityImpl) then,
  ) = __$$DriverEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String code,
    DriverStatus status,
    int todayTripsCount,
    String? avatarUrl,
  });
}

/// @nodoc
class __$$DriverEntityImplCopyWithImpl<$Res>
    extends _$DriverEntityCopyWithImpl<$Res, _$DriverEntityImpl>
    implements _$$DriverEntityImplCopyWith<$Res> {
  __$$DriverEntityImplCopyWithImpl(
    _$DriverEntityImpl _value,
    $Res Function(_$DriverEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DriverEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? status = null,
    Object? todayTripsCount = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(
      _$DriverEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DriverStatus,
        todayTripsCount: null == todayTripsCount
            ? _value.todayTripsCount
            : todayTripsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverEntityImpl implements _DriverEntity {
  const _$DriverEntityImpl({
    required this.id,
    required this.name,
    required this.code,
    required this.status,
    required this.todayTripsCount,
    this.avatarUrl,
  });

  factory _$DriverEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final DriverStatus status;
  @override
  final int todayTripsCount;
  @override
  final String? avatarUrl;

  @override
  String toString() {
    return 'DriverEntity(id: $id, name: $name, code: $code, status: $status, todayTripsCount: $todayTripsCount, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.todayTripsCount, todayTripsCount) ||
                other.todayTripsCount == todayTripsCount) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    code,
    status,
    todayTripsCount,
    avatarUrl,
  );

  /// Create a copy of DriverEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverEntityImplCopyWith<_$DriverEntityImpl> get copyWith =>
      __$$DriverEntityImplCopyWithImpl<_$DriverEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverEntityImplToJson(this);
  }
}

abstract class _DriverEntity implements DriverEntity {
  const factory _DriverEntity({
    required final String id,
    required final String name,
    required final String code,
    required final DriverStatus status,
    required final int todayTripsCount,
    final String? avatarUrl,
  }) = _$DriverEntityImpl;

  factory _DriverEntity.fromJson(Map<String, dynamic> json) =
      _$DriverEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code;
  @override
  DriverStatus get status;
  @override
  int get todayTripsCount;
  @override
  String? get avatarUrl;

  /// Create a copy of DriverEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverEntityImplCopyWith<_$DriverEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
