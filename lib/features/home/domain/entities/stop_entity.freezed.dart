// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StopEntity _$StopEntityFromJson(Map<String, dynamic> json) {
  return _StopEntity.fromJson(json);
}

/// @nodoc
mixin _$StopEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get allowedRadius => throw _privateConstructorUsedError;
  int get sequenceOrder => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this StopEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StopEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StopEntityCopyWith<StopEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StopEntityCopyWith<$Res> {
  factory $StopEntityCopyWith(
    StopEntity value,
    $Res Function(StopEntity) then,
  ) = _$StopEntityCopyWithImpl<$Res, StopEntity>;
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double allowedRadius,
    int sequenceOrder,
    bool isCompleted,
  });
}

/// @nodoc
class _$StopEntityCopyWithImpl<$Res, $Val extends StopEntity>
    implements $StopEntityCopyWith<$Res> {
  _$StopEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StopEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? allowedRadius = null,
    Object? sequenceOrder = null,
    Object? isCompleted = null,
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
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            allowedRadius: null == allowedRadius
                ? _value.allowedRadius
                : allowedRadius // ignore: cast_nullable_to_non_nullable
                      as double,
            sequenceOrder: null == sequenceOrder
                ? _value.sequenceOrder
                : sequenceOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StopEntityImplCopyWith<$Res>
    implements $StopEntityCopyWith<$Res> {
  factory _$$StopEntityImplCopyWith(
    _$StopEntityImpl value,
    $Res Function(_$StopEntityImpl) then,
  ) = __$$StopEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double latitude,
    double longitude,
    double allowedRadius,
    int sequenceOrder,
    bool isCompleted,
  });
}

/// @nodoc
class __$$StopEntityImplCopyWithImpl<$Res>
    extends _$StopEntityCopyWithImpl<$Res, _$StopEntityImpl>
    implements _$$StopEntityImplCopyWith<$Res> {
  __$$StopEntityImplCopyWithImpl(
    _$StopEntityImpl _value,
    $Res Function(_$StopEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StopEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? allowedRadius = null,
    Object? sequenceOrder = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _$StopEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        allowedRadius: null == allowedRadius
            ? _value.allowedRadius
            : allowedRadius // ignore: cast_nullable_to_non_nullable
                  as double,
        sequenceOrder: null == sequenceOrder
            ? _value.sequenceOrder
            : sequenceOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StopEntityImpl implements _StopEntity {
  const _$StopEntityImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.allowedRadius,
    required this.sequenceOrder,
    this.isCompleted = false,
  });

  factory _$StopEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StopEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double allowedRadius;
  @override
  final int sequenceOrder;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'StopEntity(id: $id, name: $name, latitude: $latitude, longitude: $longitude, allowedRadius: $allowedRadius, sequenceOrder: $sequenceOrder, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StopEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.allowedRadius, allowedRadius) ||
                other.allowedRadius == allowedRadius) &&
            (identical(other.sequenceOrder, sequenceOrder) ||
                other.sequenceOrder == sequenceOrder) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    allowedRadius,
    sequenceOrder,
    isCompleted,
  );

  /// Create a copy of StopEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StopEntityImplCopyWith<_$StopEntityImpl> get copyWith =>
      __$$StopEntityImplCopyWithImpl<_$StopEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StopEntityImplToJson(this);
  }
}

abstract class _StopEntity implements StopEntity {
  const factory _StopEntity({
    required final String id,
    required final String name,
    required final double latitude,
    required final double longitude,
    required final double allowedRadius,
    required final int sequenceOrder,
    final bool isCompleted,
  }) = _$StopEntityImpl;

  factory _StopEntity.fromJson(Map<String, dynamic> json) =
      _$StopEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get allowedRadius;
  @override
  int get sequenceOrder;
  @override
  bool get isCompleted;

  /// Create a copy of StopEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StopEntityImplCopyWith<_$StopEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
