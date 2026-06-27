// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DashboardSummaryEntity _$DashboardSummaryEntityFromJson(
  Map<String, dynamic> json,
) {
  return _DashboardSummaryEntity.fromJson(json);
}

/// @nodoc
mixin _$DashboardSummaryEntity {
  int get completedTrips => throw _privateConstructorUsedError;
  int get passengersTransported => throw _privateConstructorUsedError;
  int get observationsRegistered => throw _privateConstructorUsedError;

  /// Serializes this DashboardSummaryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardSummaryEntityCopyWith<DashboardSummaryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardSummaryEntityCopyWith<$Res> {
  factory $DashboardSummaryEntityCopyWith(
    DashboardSummaryEntity value,
    $Res Function(DashboardSummaryEntity) then,
  ) = _$DashboardSummaryEntityCopyWithImpl<$Res, DashboardSummaryEntity>;
  @useResult
  $Res call({
    int completedTrips,
    int passengersTransported,
    int observationsRegistered,
  });
}

/// @nodoc
class _$DashboardSummaryEntityCopyWithImpl<
  $Res,
  $Val extends DashboardSummaryEntity
>
    implements $DashboardSummaryEntityCopyWith<$Res> {
  _$DashboardSummaryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedTrips = null,
    Object? passengersTransported = null,
    Object? observationsRegistered = null,
  }) {
    return _then(
      _value.copyWith(
            completedTrips: null == completedTrips
                ? _value.completedTrips
                : completedTrips // ignore: cast_nullable_to_non_nullable
                      as int,
            passengersTransported: null == passengersTransported
                ? _value.passengersTransported
                : passengersTransported // ignore: cast_nullable_to_non_nullable
                      as int,
            observationsRegistered: null == observationsRegistered
                ? _value.observationsRegistered
                : observationsRegistered // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardSummaryEntityImplCopyWith<$Res>
    implements $DashboardSummaryEntityCopyWith<$Res> {
  factory _$$DashboardSummaryEntityImplCopyWith(
    _$DashboardSummaryEntityImpl value,
    $Res Function(_$DashboardSummaryEntityImpl) then,
  ) = __$$DashboardSummaryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int completedTrips,
    int passengersTransported,
    int observationsRegistered,
  });
}

/// @nodoc
class __$$DashboardSummaryEntityImplCopyWithImpl<$Res>
    extends
        _$DashboardSummaryEntityCopyWithImpl<$Res, _$DashboardSummaryEntityImpl>
    implements _$$DashboardSummaryEntityImplCopyWith<$Res> {
  __$$DashboardSummaryEntityImplCopyWithImpl(
    _$DashboardSummaryEntityImpl _value,
    $Res Function(_$DashboardSummaryEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedTrips = null,
    Object? passengersTransported = null,
    Object? observationsRegistered = null,
  }) {
    return _then(
      _$DashboardSummaryEntityImpl(
        completedTrips: null == completedTrips
            ? _value.completedTrips
            : completedTrips // ignore: cast_nullable_to_non_nullable
                  as int,
        passengersTransported: null == passengersTransported
            ? _value.passengersTransported
            : passengersTransported // ignore: cast_nullable_to_non_nullable
                  as int,
        observationsRegistered: null == observationsRegistered
            ? _value.observationsRegistered
            : observationsRegistered // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardSummaryEntityImpl implements _DashboardSummaryEntity {
  const _$DashboardSummaryEntityImpl({
    required this.completedTrips,
    required this.passengersTransported,
    required this.observationsRegistered,
  });

  factory _$DashboardSummaryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardSummaryEntityImplFromJson(json);

  @override
  final int completedTrips;
  @override
  final int passengersTransported;
  @override
  final int observationsRegistered;

  @override
  String toString() {
    return 'DashboardSummaryEntity(completedTrips: $completedTrips, passengersTransported: $passengersTransported, observationsRegistered: $observationsRegistered)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardSummaryEntityImpl &&
            (identical(other.completedTrips, completedTrips) ||
                other.completedTrips == completedTrips) &&
            (identical(other.passengersTransported, passengersTransported) ||
                other.passengersTransported == passengersTransported) &&
            (identical(other.observationsRegistered, observationsRegistered) ||
                other.observationsRegistered == observationsRegistered));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    completedTrips,
    passengersTransported,
    observationsRegistered,
  );

  /// Create a copy of DashboardSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardSummaryEntityImplCopyWith<_$DashboardSummaryEntityImpl>
  get copyWith =>
      __$$DashboardSummaryEntityImplCopyWithImpl<_$DashboardSummaryEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardSummaryEntityImplToJson(this);
  }
}

abstract class _DashboardSummaryEntity implements DashboardSummaryEntity {
  const factory _DashboardSummaryEntity({
    required final int completedTrips,
    required final int passengersTransported,
    required final int observationsRegistered,
  }) = _$DashboardSummaryEntityImpl;

  factory _DashboardSummaryEntity.fromJson(Map<String, dynamic> json) =
      _$DashboardSummaryEntityImpl.fromJson;

  @override
  int get completedTrips;
  @override
  int get passengersTransported;
  @override
  int get observationsRegistered;

  /// Create a copy of DashboardSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardSummaryEntityImplCopyWith<_$DashboardSummaryEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
