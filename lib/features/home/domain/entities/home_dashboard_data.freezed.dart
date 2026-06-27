// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HomeDashboardData _$HomeDashboardDataFromJson(Map<String, dynamic> json) {
  return _HomeDashboardData.fromJson(json);
}

/// @nodoc
mixin _$HomeDashboardData {
  DriverEntity get driver => throw _privateConstructorUsedError;
  List<TripEntity> get todayTrips => throw _privateConstructorUsedError;
  List<TripEntity> get pendingTrips => throw _privateConstructorUsedError;
  DashboardSummaryEntity get summary => throw _privateConstructorUsedError;

  /// Serializes this HomeDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDashboardDataCopyWith<HomeDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDashboardDataCopyWith<$Res> {
  factory $HomeDashboardDataCopyWith(
    HomeDashboardData value,
    $Res Function(HomeDashboardData) then,
  ) = _$HomeDashboardDataCopyWithImpl<$Res, HomeDashboardData>;
  @useResult
  $Res call({
    DriverEntity driver,
    List<TripEntity> todayTrips,
    List<TripEntity> pendingTrips,
    DashboardSummaryEntity summary,
  });

  $DriverEntityCopyWith<$Res> get driver;
  $DashboardSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class _$HomeDashboardDataCopyWithImpl<$Res, $Val extends HomeDashboardData>
    implements $HomeDashboardDataCopyWith<$Res> {
  _$HomeDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driver = null,
    Object? todayTrips = null,
    Object? pendingTrips = null,
    Object? summary = null,
  }) {
    return _then(
      _value.copyWith(
            driver: null == driver
                ? _value.driver
                : driver // ignore: cast_nullable_to_non_nullable
                      as DriverEntity,
            todayTrips: null == todayTrips
                ? _value.todayTrips
                : todayTrips // ignore: cast_nullable_to_non_nullable
                      as List<TripEntity>,
            pendingTrips: null == pendingTrips
                ? _value.pendingTrips
                : pendingTrips // ignore: cast_nullable_to_non_nullable
                      as List<TripEntity>,
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as DashboardSummaryEntity,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DriverEntityCopyWith<$Res> get driver {
    return $DriverEntityCopyWith<$Res>(_value.driver, (value) {
      return _then(_value.copyWith(driver: value) as $Val);
    });
  }

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DashboardSummaryEntityCopyWith<$Res> get summary {
    return $DashboardSummaryEntityCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeDashboardDataImplCopyWith<$Res>
    implements $HomeDashboardDataCopyWith<$Res> {
  factory _$$HomeDashboardDataImplCopyWith(
    _$HomeDashboardDataImpl value,
    $Res Function(_$HomeDashboardDataImpl) then,
  ) = __$$HomeDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DriverEntity driver,
    List<TripEntity> todayTrips,
    List<TripEntity> pendingTrips,
    DashboardSummaryEntity summary,
  });

  @override
  $DriverEntityCopyWith<$Res> get driver;
  @override
  $DashboardSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class __$$HomeDashboardDataImplCopyWithImpl<$Res>
    extends _$HomeDashboardDataCopyWithImpl<$Res, _$HomeDashboardDataImpl>
    implements _$$HomeDashboardDataImplCopyWith<$Res> {
  __$$HomeDashboardDataImplCopyWithImpl(
    _$HomeDashboardDataImpl _value,
    $Res Function(_$HomeDashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driver = null,
    Object? todayTrips = null,
    Object? pendingTrips = null,
    Object? summary = null,
  }) {
    return _then(
      _$HomeDashboardDataImpl(
        driver: null == driver
            ? _value.driver
            : driver // ignore: cast_nullable_to_non_nullable
                  as DriverEntity,
        todayTrips: null == todayTrips
            ? _value._todayTrips
            : todayTrips // ignore: cast_nullable_to_non_nullable
                  as List<TripEntity>,
        pendingTrips: null == pendingTrips
            ? _value._pendingTrips
            : pendingTrips // ignore: cast_nullable_to_non_nullable
                  as List<TripEntity>,
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as DashboardSummaryEntity,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeDashboardDataImpl implements _HomeDashboardData {
  const _$HomeDashboardDataImpl({
    required this.driver,
    required final List<TripEntity> todayTrips,
    required final List<TripEntity> pendingTrips,
    required this.summary,
  }) : _todayTrips = todayTrips,
       _pendingTrips = pendingTrips;

  factory _$HomeDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeDashboardDataImplFromJson(json);

  @override
  final DriverEntity driver;
  final List<TripEntity> _todayTrips;
  @override
  List<TripEntity> get todayTrips {
    if (_todayTrips is EqualUnmodifiableListView) return _todayTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todayTrips);
  }

  final List<TripEntity> _pendingTrips;
  @override
  List<TripEntity> get pendingTrips {
    if (_pendingTrips is EqualUnmodifiableListView) return _pendingTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingTrips);
  }

  @override
  final DashboardSummaryEntity summary;

  @override
  String toString() {
    return 'HomeDashboardData(driver: $driver, todayTrips: $todayTrips, pendingTrips: $pendingTrips, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDashboardDataImpl &&
            (identical(other.driver, driver) || other.driver == driver) &&
            const DeepCollectionEquality().equals(
              other._todayTrips,
              _todayTrips,
            ) &&
            const DeepCollectionEquality().equals(
              other._pendingTrips,
              _pendingTrips,
            ) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    driver,
    const DeepCollectionEquality().hash(_todayTrips),
    const DeepCollectionEquality().hash(_pendingTrips),
    summary,
  );

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDashboardDataImplCopyWith<_$HomeDashboardDataImpl> get copyWith =>
      __$$HomeDashboardDataImplCopyWithImpl<_$HomeDashboardDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeDashboardDataImplToJson(this);
  }
}

abstract class _HomeDashboardData implements HomeDashboardData {
  const factory _HomeDashboardData({
    required final DriverEntity driver,
    required final List<TripEntity> todayTrips,
    required final List<TripEntity> pendingTrips,
    required final DashboardSummaryEntity summary,
  }) = _$HomeDashboardDataImpl;

  factory _HomeDashboardData.fromJson(Map<String, dynamic> json) =
      _$HomeDashboardDataImpl.fromJson;

  @override
  DriverEntity get driver;
  @override
  List<TripEntity> get todayTrips;
  @override
  List<TripEntity> get pendingTrips;
  @override
  DashboardSummaryEntity get summary;

  /// Create a copy of HomeDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDashboardDataImplCopyWith<_$HomeDashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
