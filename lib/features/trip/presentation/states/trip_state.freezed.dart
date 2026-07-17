// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TripState {
  /// Carga inicial de la lista de viajes.
  bool get isLoading => throw _privateConstructorUsedError;

  /// Indicador de una acción en curso (apertura/cierre de viaje).
  bool get isActionLoading => throw _privateConstructorUsedError;

  /// Mensaje de error a mostrar al usuario, si aplica.
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Lista de viajes del día en curso.
  List<TripEntity> get todayTrips => throw _privateConstructorUsedError;

  /// Lista de viajes pendientes de días futuros.
  List<TripEntity> get pendingTrips => throw _privateConstructorUsedError;

  /// Viaje actualmente seleccionado para ver su detalle.
  TripEntity? get selectedTrip => throw _privateConstructorUsedError;

  /// Kilometraje de apertura del viaje activo (para validación de cierre).
  int? get activeStartKm => throw _privateConstructorUsedError;

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripStateCopyWith<TripState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripStateCopyWith<$Res> {
  factory $TripStateCopyWith(TripState value, $Res Function(TripState) then) =
      _$TripStateCopyWithImpl<$Res, TripState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isActionLoading,
    String? errorMessage,
    List<TripEntity> todayTrips,
    List<TripEntity> pendingTrips,
    TripEntity? selectedTrip,
    int? activeStartKm,
  });

  $TripEntityCopyWith<$Res>? get selectedTrip;
}

/// @nodoc
class _$TripStateCopyWithImpl<$Res, $Val extends TripState>
    implements $TripStateCopyWith<$Res> {
  _$TripStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isActionLoading = null,
    Object? errorMessage = freezed,
    Object? todayTrips = null,
    Object? pendingTrips = null,
    Object? selectedTrip = freezed,
    Object? activeStartKm = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActionLoading: null == isActionLoading
                ? _value.isActionLoading
                : isActionLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            todayTrips: null == todayTrips
                ? _value.todayTrips
                : todayTrips // ignore: cast_nullable_to_non_nullable
                      as List<TripEntity>,
            pendingTrips: null == pendingTrips
                ? _value.pendingTrips
                : pendingTrips // ignore: cast_nullable_to_non_nullable
                      as List<TripEntity>,
            selectedTrip: freezed == selectedTrip
                ? _value.selectedTrip
                : selectedTrip // ignore: cast_nullable_to_non_nullable
                      as TripEntity?,
            activeStartKm: freezed == activeStartKm
                ? _value.activeStartKm
                : activeStartKm // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TripEntityCopyWith<$Res>? get selectedTrip {
    if (_value.selectedTrip == null) {
      return null;
    }

    return $TripEntityCopyWith<$Res>(_value.selectedTrip!, (value) {
      return _then(_value.copyWith(selectedTrip: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TripStateImplCopyWith<$Res>
    implements $TripStateCopyWith<$Res> {
  factory _$$TripStateImplCopyWith(
    _$TripStateImpl value,
    $Res Function(_$TripStateImpl) then,
  ) = __$$TripStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isActionLoading,
    String? errorMessage,
    List<TripEntity> todayTrips,
    List<TripEntity> pendingTrips,
    TripEntity? selectedTrip,
    int? activeStartKm,
  });

  @override
  $TripEntityCopyWith<$Res>? get selectedTrip;
}

/// @nodoc
class __$$TripStateImplCopyWithImpl<$Res>
    extends _$TripStateCopyWithImpl<$Res, _$TripStateImpl>
    implements _$$TripStateImplCopyWith<$Res> {
  __$$TripStateImplCopyWithImpl(
    _$TripStateImpl _value,
    $Res Function(_$TripStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isActionLoading = null,
    Object? errorMessage = freezed,
    Object? todayTrips = null,
    Object? pendingTrips = null,
    Object? selectedTrip = freezed,
    Object? activeStartKm = freezed,
  }) {
    return _then(
      _$TripStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActionLoading: null == isActionLoading
            ? _value.isActionLoading
            : isActionLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        todayTrips: null == todayTrips
            ? _value._todayTrips
            : todayTrips // ignore: cast_nullable_to_non_nullable
                  as List<TripEntity>,
        pendingTrips: null == pendingTrips
            ? _value._pendingTrips
            : pendingTrips // ignore: cast_nullable_to_non_nullable
                  as List<TripEntity>,
        selectedTrip: freezed == selectedTrip
            ? _value.selectedTrip
            : selectedTrip // ignore: cast_nullable_to_non_nullable
                  as TripEntity?,
        activeStartKm: freezed == activeStartKm
            ? _value.activeStartKm
            : activeStartKm // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$TripStateImpl extends _TripState {
  const _$TripStateImpl({
    this.isLoading = true,
    this.isActionLoading = false,
    this.errorMessage,
    final List<TripEntity> todayTrips = const [],
    final List<TripEntity> pendingTrips = const [],
    this.selectedTrip,
    this.activeStartKm,
  }) : _todayTrips = todayTrips,
       _pendingTrips = pendingTrips,
       super._();

  /// Carga inicial de la lista de viajes.
  @override
  @JsonKey()
  final bool isLoading;

  /// Indicador de una acción en curso (apertura/cierre de viaje).
  @override
  @JsonKey()
  final bool isActionLoading;

  /// Mensaje de error a mostrar al usuario, si aplica.
  @override
  final String? errorMessage;

  /// Lista de viajes del día en curso.
  final List<TripEntity> _todayTrips;

  /// Lista de viajes del día en curso.
  @override
  @JsonKey()
  List<TripEntity> get todayTrips {
    if (_todayTrips is EqualUnmodifiableListView) return _todayTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todayTrips);
  }

  /// Lista de viajes pendientes de días futuros.
  final List<TripEntity> _pendingTrips;

  /// Lista de viajes pendientes de días futuros.
  @override
  @JsonKey()
  List<TripEntity> get pendingTrips {
    if (_pendingTrips is EqualUnmodifiableListView) return _pendingTrips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingTrips);
  }

  /// Viaje actualmente seleccionado para ver su detalle.
  @override
  final TripEntity? selectedTrip;

  /// Kilometraje de apertura del viaje activo (para validación de cierre).
  @override
  final int? activeStartKm;

  @override
  String toString() {
    return 'TripState(isLoading: $isLoading, isActionLoading: $isActionLoading, errorMessage: $errorMessage, todayTrips: $todayTrips, pendingTrips: $pendingTrips, selectedTrip: $selectedTrip, activeStartKm: $activeStartKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isActionLoading, isActionLoading) ||
                other.isActionLoading == isActionLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality().equals(
              other._todayTrips,
              _todayTrips,
            ) &&
            const DeepCollectionEquality().equals(
              other._pendingTrips,
              _pendingTrips,
            ) &&
            (identical(other.selectedTrip, selectedTrip) ||
                other.selectedTrip == selectedTrip) &&
            (identical(other.activeStartKm, activeStartKm) ||
                other.activeStartKm == activeStartKm));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isActionLoading,
    errorMessage,
    const DeepCollectionEquality().hash(_todayTrips),
    const DeepCollectionEquality().hash(_pendingTrips),
    selectedTrip,
    activeStartKm,
  );

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripStateImplCopyWith<_$TripStateImpl> get copyWith =>
      __$$TripStateImplCopyWithImpl<_$TripStateImpl>(this, _$identity);
}

abstract class _TripState extends TripState {
  const factory _TripState({
    final bool isLoading,
    final bool isActionLoading,
    final String? errorMessage,
    final List<TripEntity> todayTrips,
    final List<TripEntity> pendingTrips,
    final TripEntity? selectedTrip,
    final int? activeStartKm,
  }) = _$TripStateImpl;
  const _TripState._() : super._();

  /// Carga inicial de la lista de viajes.
  @override
  bool get isLoading;

  /// Indicador de una acción en curso (apertura/cierre de viaje).
  @override
  bool get isActionLoading;

  /// Mensaje de error a mostrar al usuario, si aplica.
  @override
  String? get errorMessage;

  /// Lista de viajes del día en curso.
  @override
  List<TripEntity> get todayTrips;

  /// Lista de viajes pendientes de días futuros.
  @override
  List<TripEntity> get pendingTrips;

  /// Viaje actualmente seleccionado para ver su detalle.
  @override
  TripEntity? get selectedTrip;

  /// Kilometraje de apertura del viaje activo (para validación de cierre).
  @override
  int? get activeStartKm;

  /// Create a copy of TripState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripStateImplCopyWith<_$TripStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
