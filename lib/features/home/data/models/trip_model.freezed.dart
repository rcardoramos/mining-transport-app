// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripModel _$TripModelFromJson(Map<String, dynamic> json) {
  return _TripModel.fromJson(json);
}

/// @nodoc
mixin _$TripModel {
  String get id => throw _privateConstructorUsedError;
  String get route => throw _privateConstructorUsedError;
  String get scheduledTime => throw _privateConstructorUsedError;
  String get shift => throw _privateConstructorUsedError;
  String get unitCode => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get passengerCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get startedAt => throw _privateConstructorUsedError;
  String? get completedAt => throw _privateConstructorUsedError;
  List<StopModel>? get stops => throw _privateConstructorUsedError;

  /// Serializes this TripModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripModelCopyWith<TripModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripModelCopyWith<$Res> {
  factory $TripModelCopyWith(TripModel value, $Res Function(TripModel) then) =
      _$TripModelCopyWithImpl<$Res, TripModel>;
  @useResult
  $Res call({
    String id,
    String route,
    String scheduledTime,
    String shift,
    String unitCode,
    int capacity,
    int passengerCount,
    String status,
    String? startedAt,
    String? completedAt,
    List<StopModel>? stops,
  });
}

/// @nodoc
class _$TripModelCopyWithImpl<$Res, $Val extends TripModel>
    implements $TripModelCopyWith<$Res> {
  _$TripModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripModel
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
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? stops = freezed,
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
                      as String,
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
                      as String,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            stops: freezed == stops
                ? _value.stops
                : stops // ignore: cast_nullable_to_non_nullable
                      as List<StopModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripModelImplCopyWith<$Res>
    implements $TripModelCopyWith<$Res> {
  factory _$$TripModelImplCopyWith(
    _$TripModelImpl value,
    $Res Function(_$TripModelImpl) then,
  ) = __$$TripModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String route,
    String scheduledTime,
    String shift,
    String unitCode,
    int capacity,
    int passengerCount,
    String status,
    String? startedAt,
    String? completedAt,
    List<StopModel>? stops,
  });
}

/// @nodoc
class __$$TripModelImplCopyWithImpl<$Res>
    extends _$TripModelCopyWithImpl<$Res, _$TripModelImpl>
    implements _$$TripModelImplCopyWith<$Res> {
  __$$TripModelImplCopyWithImpl(
    _$TripModelImpl _value,
    $Res Function(_$TripModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripModel
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
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? stops = freezed,
  }) {
    return _then(
      _$TripModelImpl(
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
                  as String,
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
                  as String,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        stops: freezed == stops
            ? _value._stops
            : stops // ignore: cast_nullable_to_non_nullable
                  as List<StopModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripModelImpl extends _TripModel {
  const _$TripModelImpl({
    required this.id,
    required this.route,
    required this.scheduledTime,
    required this.shift,
    required this.unitCode,
    required this.capacity,
    required this.passengerCount,
    required this.status,
    this.startedAt,
    this.completedAt,
    final List<StopModel>? stops,
  }) : _stops = stops,
       super._();

  factory _$TripModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripModelImplFromJson(json);

  @override
  final String id;
  @override
  final String route;
  @override
  final String scheduledTime;
  @override
  final String shift;
  @override
  final String unitCode;
  @override
  final int capacity;
  @override
  final int passengerCount;
  @override
  final String status;
  @override
  final String? startedAt;
  @override
  final String? completedAt;
  final List<StopModel>? _stops;
  @override
  List<StopModel>? get stops {
    final value = _stops;
    if (value == null) return null;
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TripModel(id: $id, route: $route, scheduledTime: $scheduledTime, shift: $shift, unitCode: $unitCode, capacity: $capacity, passengerCount: $passengerCount, status: $status, startedAt: $startedAt, completedAt: $completedAt, stops: $stops)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripModelImpl &&
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
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._stops, _stops));
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
    startedAt,
    completedAt,
    const DeepCollectionEquality().hash(_stops),
  );

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      __$$TripModelImplCopyWithImpl<_$TripModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripModelImplToJson(this);
  }
}

abstract class _TripModel extends TripModel {
  const factory _TripModel({
    required final String id,
    required final String route,
    required final String scheduledTime,
    required final String shift,
    required final String unitCode,
    required final int capacity,
    required final int passengerCount,
    required final String status,
    final String? startedAt,
    final String? completedAt,
    final List<StopModel>? stops,
  }) = _$TripModelImpl;
  const _TripModel._() : super._();

  factory _TripModel.fromJson(Map<String, dynamic> json) =
      _$TripModelImpl.fromJson;

  @override
  String get id;
  @override
  String get route;
  @override
  String get scheduledTime;
  @override
  String get shift;
  @override
  String get unitCode;
  @override
  int get capacity;
  @override
  int get passengerCount;
  @override
  String get status;
  @override
  String? get startedAt;
  @override
  String? get completedAt;
  @override
  List<StopModel>? get stops;

  /// Create a copy of TripModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripModelImplCopyWith<_$TripModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
