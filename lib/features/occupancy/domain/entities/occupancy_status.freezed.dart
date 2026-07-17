// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'occupancy_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OccupancyStatus {
  int get currentCount => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  bool get isFull => throw _privateConstructorUsedError;
  bool get isExceeded => throw _privateConstructorUsedError;
  int get remainingSeats => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Create a copy of OccupancyStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OccupancyStatusCopyWith<OccupancyStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OccupancyStatusCopyWith<$Res> {
  factory $OccupancyStatusCopyWith(
    OccupancyStatus value,
    $Res Function(OccupancyStatus) then,
  ) = _$OccupancyStatusCopyWithImpl<$Res, OccupancyStatus>;
  @useResult
  $Res call({
    int currentCount,
    int capacity,
    bool isFull,
    bool isExceeded,
    int remainingSeats,
    double percentage,
  });
}

/// @nodoc
class _$OccupancyStatusCopyWithImpl<$Res, $Val extends OccupancyStatus>
    implements $OccupancyStatusCopyWith<$Res> {
  _$OccupancyStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OccupancyStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentCount = null,
    Object? capacity = null,
    Object? isFull = null,
    Object? isExceeded = null,
    Object? remainingSeats = null,
    Object? percentage = null,
  }) {
    return _then(
      _value.copyWith(
            currentCount: null == currentCount
                ? _value.currentCount
                : currentCount // ignore: cast_nullable_to_non_nullable
                      as int,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            isFull: null == isFull
                ? _value.isFull
                : isFull // ignore: cast_nullable_to_non_nullable
                      as bool,
            isExceeded: null == isExceeded
                ? _value.isExceeded
                : isExceeded // ignore: cast_nullable_to_non_nullable
                      as bool,
            remainingSeats: null == remainingSeats
                ? _value.remainingSeats
                : remainingSeats // ignore: cast_nullable_to_non_nullable
                      as int,
            percentage: null == percentage
                ? _value.percentage
                : percentage // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OccupancyStatusImplCopyWith<$Res>
    implements $OccupancyStatusCopyWith<$Res> {
  factory _$$OccupancyStatusImplCopyWith(
    _$OccupancyStatusImpl value,
    $Res Function(_$OccupancyStatusImpl) then,
  ) = __$$OccupancyStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentCount,
    int capacity,
    bool isFull,
    bool isExceeded,
    int remainingSeats,
    double percentage,
  });
}

/// @nodoc
class __$$OccupancyStatusImplCopyWithImpl<$Res>
    extends _$OccupancyStatusCopyWithImpl<$Res, _$OccupancyStatusImpl>
    implements _$$OccupancyStatusImplCopyWith<$Res> {
  __$$OccupancyStatusImplCopyWithImpl(
    _$OccupancyStatusImpl _value,
    $Res Function(_$OccupancyStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OccupancyStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentCount = null,
    Object? capacity = null,
    Object? isFull = null,
    Object? isExceeded = null,
    Object? remainingSeats = null,
    Object? percentage = null,
  }) {
    return _then(
      _$OccupancyStatusImpl(
        currentCount: null == currentCount
            ? _value.currentCount
            : currentCount // ignore: cast_nullable_to_non_nullable
                  as int,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        isFull: null == isFull
            ? _value.isFull
            : isFull // ignore: cast_nullable_to_non_nullable
                  as bool,
        isExceeded: null == isExceeded
            ? _value.isExceeded
            : isExceeded // ignore: cast_nullable_to_non_nullable
                  as bool,
        remainingSeats: null == remainingSeats
            ? _value.remainingSeats
            : remainingSeats // ignore: cast_nullable_to_non_nullable
                  as int,
        percentage: null == percentage
            ? _value.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$OccupancyStatusImpl implements _OccupancyStatus {
  const _$OccupancyStatusImpl({
    required this.currentCount,
    required this.capacity,
    required this.isFull,
    required this.isExceeded,
    required this.remainingSeats,
    required this.percentage,
  });

  @override
  final int currentCount;
  @override
  final int capacity;
  @override
  final bool isFull;
  @override
  final bool isExceeded;
  @override
  final int remainingSeats;
  @override
  final double percentage;

  @override
  String toString() {
    return 'OccupancyStatus(currentCount: $currentCount, capacity: $capacity, isFull: $isFull, isExceeded: $isExceeded, remainingSeats: $remainingSeats, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OccupancyStatusImpl &&
            (identical(other.currentCount, currentCount) ||
                other.currentCount == currentCount) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.isFull, isFull) || other.isFull == isFull) &&
            (identical(other.isExceeded, isExceeded) ||
                other.isExceeded == isExceeded) &&
            (identical(other.remainingSeats, remainingSeats) ||
                other.remainingSeats == remainingSeats) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentCount,
    capacity,
    isFull,
    isExceeded,
    remainingSeats,
    percentage,
  );

  /// Create a copy of OccupancyStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OccupancyStatusImplCopyWith<_$OccupancyStatusImpl> get copyWith =>
      __$$OccupancyStatusImplCopyWithImpl<_$OccupancyStatusImpl>(
        this,
        _$identity,
      );
}

abstract class _OccupancyStatus implements OccupancyStatus {
  const factory _OccupancyStatus({
    required final int currentCount,
    required final int capacity,
    required final bool isFull,
    required final bool isExceeded,
    required final int remainingSeats,
    required final double percentage,
  }) = _$OccupancyStatusImpl;

  @override
  int get currentCount;
  @override
  int get capacity;
  @override
  bool get isFull;
  @override
  bool get isExceeded;
  @override
  int get remainingSeats;
  @override
  double get percentage;

  /// Create a copy of OccupancyStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OccupancyStatusImplCopyWith<_$OccupancyStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
