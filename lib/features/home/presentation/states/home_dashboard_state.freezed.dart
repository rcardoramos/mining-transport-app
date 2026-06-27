// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_dashboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HomeDashboardState _$HomeDashboardStateFromJson(Map<String, dynamic> json) {
  return _HomeDashboardState.fromJson(json);
}

/// @nodoc
mixin _$HomeDashboardState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  HomeDashboardData? get data => throw _privateConstructorUsedError;

  /// Serializes this HomeDashboardState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDashboardStateCopyWith<HomeDashboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDashboardStateCopyWith<$Res> {
  factory $HomeDashboardStateCopyWith(
    HomeDashboardState value,
    $Res Function(HomeDashboardState) then,
  ) = _$HomeDashboardStateCopyWithImpl<$Res, HomeDashboardState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isRefreshing,
    String? errorMessage,
    HomeDashboardData? data,
  });

  $HomeDashboardDataCopyWith<$Res>? get data;
}

/// @nodoc
class _$HomeDashboardStateCopyWithImpl<$Res, $Val extends HomeDashboardState>
    implements $HomeDashboardStateCopyWith<$Res> {
  _$HomeDashboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRefreshing: null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as HomeDashboardData?,
          )
          as $Val,
    );
  }

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HomeDashboardDataCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $HomeDashboardDataCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeDashboardStateImplCopyWith<$Res>
    implements $HomeDashboardStateCopyWith<$Res> {
  factory _$$HomeDashboardStateImplCopyWith(
    _$HomeDashboardStateImpl value,
    $Res Function(_$HomeDashboardStateImpl) then,
  ) = __$$HomeDashboardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isRefreshing,
    String? errorMessage,
    HomeDashboardData? data,
  });

  @override
  $HomeDashboardDataCopyWith<$Res>? get data;
}

/// @nodoc
class __$$HomeDashboardStateImplCopyWithImpl<$Res>
    extends _$HomeDashboardStateCopyWithImpl<$Res, _$HomeDashboardStateImpl>
    implements _$$HomeDashboardStateImplCopyWith<$Res> {
  __$$HomeDashboardStateImplCopyWithImpl(
    _$HomeDashboardStateImpl _value,
    $Res Function(_$HomeDashboardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? errorMessage = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$HomeDashboardStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as HomeDashboardData?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeDashboardStateImpl implements _HomeDashboardState {
  const _$HomeDashboardStateImpl({
    this.isLoading = true,
    this.isRefreshing = false,
    this.errorMessage,
    this.data,
  });

  factory _$HomeDashboardStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeDashboardStateImplFromJson(json);

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final String? errorMessage;
  @override
  final HomeDashboardData? data;

  @override
  String toString() {
    return 'HomeDashboardState(isLoading: $isLoading, isRefreshing: $isRefreshing, errorMessage: $errorMessage, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDashboardStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, isRefreshing, errorMessage, data);

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDashboardStateImplCopyWith<_$HomeDashboardStateImpl> get copyWith =>
      __$$HomeDashboardStateImplCopyWithImpl<_$HomeDashboardStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeDashboardStateImplToJson(this);
  }
}

abstract class _HomeDashboardState implements HomeDashboardState {
  const factory _HomeDashboardState({
    final bool isLoading,
    final bool isRefreshing,
    final String? errorMessage,
    final HomeDashboardData? data,
  }) = _$HomeDashboardStateImpl;

  factory _HomeDashboardState.fromJson(Map<String, dynamic> json) =
      _$HomeDashboardStateImpl.fromJson;

  @override
  bool get isLoading;
  @override
  bool get isRefreshing;
  @override
  String? get errorMessage;
  @override
  HomeDashboardData? get data;

  /// Create a copy of HomeDashboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDashboardStateImplCopyWith<_$HomeDashboardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
