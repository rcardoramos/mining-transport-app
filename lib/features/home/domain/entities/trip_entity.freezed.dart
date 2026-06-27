// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripEntity _$TripEntityFromJson(Map<String, dynamic> json) {
  return _TripEntity.fromJson(json);
}

/// @nodoc
mixin _$TripEntity {
  String get id => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;
  DateTime get scheduledTime => throw _privateConstructorUsedError;
  String get shift => throw _privateConstructorUsedError;
  String get unitCode => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get passengerCount => throw _privateConstructorUsedError;
  TripStatus get status => throw _privateConstructorUsedError;

  /// Serializes this TripEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripEntityCopyWith<TripEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripEntityCopyWith<$Res> {
  factory $TripEntityCopyWith(
    TripEntity value,
    $Res Function(TripEntity) then,
  ) = _$TripEntityCopyWithImpl<$Res, TripEntity>;
  @useResult
  $Res call({
    String id,
    String route,
    DateTime scheduledTime,
    String shift,
    String unitCode,
    int capacity,
    int passengerCount,
    TripStatus status,
  });
}

/// @nodoc
class _$TripEntityCopyWithImpl<$Res, $Val extends TripEntity>
    implements $TripEntityCopyWith<$Res> {
  _$TripEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? route = null,
    Object? scheduledTime = null,
    Object? shift = null,
    Object? unitCode = null,
    Object? capacity = null,
    Object? passengerCount = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            route: null == route
                ? _value.route
                : route // ignore: cast_nullable_to_non_nullable
                      as String,
            scheduledTime: null == scheduledTime
                ? _value.scheduledTime
                : scheduledTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            shift: null == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String,
            unitCode: null == unitCode
                ? _value.unitCode
                : unitCode // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            passengerCount: null == passengerCount
                ? _value.passengerCount
                : passengerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TripStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripEntityImplCopyWith<$Res>
    implements $TripEntityCopyWith<$Res> {
  factory _$$TripEntityImplCopyWith(
    _$TripEntityImpl value,
    $Res Function(_$TripEntityImpl) then,
  ) = __$$TripEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String route,
    DateTime scheduledTime,
    String shift,
    String unitCode,
    int capacity,
    int passengerCount,
    TripStatus status,
  });
}

/// @nodoc
class __$$TripEntityImplCopyWithImpl<$Res>
    extends _$TripEntityCopyWithImpl<$Res, _$TripEntityImpl>
    implements _$$TripEntityImplCopyWith<$Res> {
  __$$TripEntityImplCopyWithImpl(
    _$TripEntityImpl _value,
    $Res Function(_$TripEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? route = null,
    Object? scheduledTime = null,
    Object? shift = null,
    Object? unitCode = null,
    Object? capacity = null,
    Object? passengerCount = null,
    Object? status = null,
  }) {
    return _then(
      _$TripEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        route: null == route
            ? _value.route
            : route // ignore: cast_nullable_to_non_nullable
                  as String,
        scheduledTime: null == scheduledTime
            ? _value.scheduledTime
            : scheduledTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        shift: null == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String,
        unitCode: null == unitCode
            ? _value.unitCode
            : unitCode // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        passengerCount: null == passengerCount
            ? _value.passengerCount
            : passengerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TripStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripEntityImpl implements _TripEntity {
  const _$TripEntityImpl({
    required this.id,
    required this.route,
    required this.scheduledTime,
    required this.shift,
    required this.unitCode,
    required this.capacity,
    required this.passengerCount,
    required this.status,
  });

  factory _$TripEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String route;
  @override
  final DateTime scheduledTime;
  @override
  final String shift;
  @override
  final String unitCode;
  @override
  final int capacity;
  @override
  final int passengerCount;
  @override
  final TripStatus status;

  @override
  String toString() {
    return 'TripEntity(id: $id, route: $route, scheduledTime: $scheduledTime, shift: $shift, unitCode: $unitCode, capacity: $capacity, passengerCount: $passengerCount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.route, route) || other.route == route) &&
            (identical(other.scheduledTime, scheduledTime) ||
                other.scheduledTime == scheduledTime) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.unitCode, unitCode) ||
                other.unitCode == unitCode) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.passengerCount, passengerCount) ||
                other.passengerCount == passengerCount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    route,
    scheduledTime,
    shift,
    unitCode,
    capacity,
    passengerCount,
    status,
  );

  /// Create a copy of TripEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripEntityImplCopyWith<_$TripEntityImpl> get copyWith =>
      __$$TripEntityImplCopyWithImpl<_$TripEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripEntityImplToJson(this);
  }
}

abstract class _TripEntity implements TripEntity {
  const factory _TripEntity({
    required final String id,
    required final String route,
    required final DateTime scheduledTime,
    required final String shift,
    required final String unitCode,
    required final int capacity,
    required final int passengerCount,
    required final TripStatus status,
  }) = _$TripEntityImpl;

  factory _TripEntity.fromJson(Map<String, dynamic> json) =
      _$TripEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get route;
  @override
  DateTime get scheduledTime;
  @override
  String get shift;
  @override
  String get unitCode;
  @override
  int get capacity;
  @override
  int get passengerCount;
  @override
  TripStatus get status;

  /// Create a copy of TripEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripEntityImplCopyWith<_$TripEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
