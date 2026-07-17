// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geofencing_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GeofencingResult {
  double get distanceInMetres => throw _privateConstructorUsedError;
  bool get inRange => throw _privateConstructorUsedError;
  double get allowedRadius => throw _privateConstructorUsedError;

  /// Create a copy of GeofencingResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeofencingResultCopyWith<GeofencingResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeofencingResultCopyWith<$Res> {
  factory $GeofencingResultCopyWith(
    GeofencingResult value,
    $Res Function(GeofencingResult) then,
  ) = _$GeofencingResultCopyWithImpl<$Res, GeofencingResult>;
  @useResult
  $Res call({double distanceInMetres, bool inRange, double allowedRadius});
}

/// @nodoc
class _$GeofencingResultCopyWithImpl<$Res, $Val extends GeofencingResult>
    implements $GeofencingResultCopyWith<$Res> {
  _$GeofencingResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeofencingResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceInMetres = null,
    Object? inRange = null,
    Object? allowedRadius = null,
  }) {
    return _then(
      _value.copyWith(
            distanceInMetres: null == distanceInMetres
                ? _value.distanceInMetres
                : distanceInMetres // ignore: cast_nullable_to_non_nullable
                      as double,
            inRange: null == inRange
                ? _value.inRange
                : inRange // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowedRadius: null == allowedRadius
                ? _value.allowedRadius
                : allowedRadius // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GeofencingResultImplCopyWith<$Res>
    implements $GeofencingResultCopyWith<$Res> {
  factory _$$GeofencingResultImplCopyWith(
    _$GeofencingResultImpl value,
    $Res Function(_$GeofencingResultImpl) then,
  ) = __$$GeofencingResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double distanceInMetres, bool inRange, double allowedRadius});
}

/// @nodoc
class __$$GeofencingResultImplCopyWithImpl<$Res>
    extends _$GeofencingResultCopyWithImpl<$Res, _$GeofencingResultImpl>
    implements _$$GeofencingResultImplCopyWith<$Res> {
  __$$GeofencingResultImplCopyWithImpl(
    _$GeofencingResultImpl _value,
    $Res Function(_$GeofencingResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GeofencingResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? distanceInMetres = null,
    Object? inRange = null,
    Object? allowedRadius = null,
  }) {
    return _then(
      _$GeofencingResultImpl(
        distanceInMetres: null == distanceInMetres
            ? _value.distanceInMetres
            : distanceInMetres // ignore: cast_nullable_to_non_nullable
                  as double,
        inRange: null == inRange
            ? _value.inRange
            : inRange // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowedRadius: null == allowedRadius
            ? _value.allowedRadius
            : allowedRadius // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$GeofencingResultImpl implements _GeofencingResult {
  const _$GeofencingResultImpl({
    required this.distanceInMetres,
    required this.inRange,
    required this.allowedRadius,
  });

  @override
  final double distanceInMetres;
  @override
  final bool inRange;
  @override
  final double allowedRadius;

  @override
  String toString() {
    return 'GeofencingResult(distanceInMetres: $distanceInMetres, inRange: $inRange, allowedRadius: $allowedRadius)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeofencingResultImpl &&
            (identical(other.distanceInMetres, distanceInMetres) ||
                other.distanceInMetres == distanceInMetres) &&
            (identical(other.inRange, inRange) || other.inRange == inRange) &&
            (identical(other.allowedRadius, allowedRadius) ||
                other.allowedRadius == allowedRadius));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, distanceInMetres, inRange, allowedRadius);

  /// Create a copy of GeofencingResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeofencingResultImplCopyWith<_$GeofencingResultImpl> get copyWith =>
      __$$GeofencingResultImplCopyWithImpl<_$GeofencingResultImpl>(
        this,
        _$identity,
      );
}

abstract class _GeofencingResult implements GeofencingResult {
  const factory _GeofencingResult({
    required final double distanceInMetres,
    required final bool inRange,
    required final double allowedRadius,
  }) = _$GeofencingResultImpl;

  @override
  double get distanceInMetres;
  @override
  bool get inRange;
  @override
  double get allowedRadius;

  /// Create a copy of GeofencingResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeofencingResultImplCopyWith<_$GeofencingResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
