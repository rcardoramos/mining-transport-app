// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearest_stop_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NearestStopEntity {
  int get paraderoId => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  double get distanciaMetros => throw _privateConstructorUsedError;

  /// Create a copy of NearestStopEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearestStopEntityCopyWith<NearestStopEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearestStopEntityCopyWith<$Res> {
  factory $NearestStopEntityCopyWith(
    NearestStopEntity value,
    $Res Function(NearestStopEntity) then,
  ) = _$NearestStopEntityCopyWithImpl<$Res, NearestStopEntity>;
  @useResult
  $Res call({int paraderoId, String nombre, double distanciaMetros});
}

/// @nodoc
class _$NearestStopEntityCopyWithImpl<$Res, $Val extends NearestStopEntity>
    implements $NearestStopEntityCopyWith<$Res> {
  _$NearestStopEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearestStopEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paraderoId = null,
    Object? nombre = null,
    Object? distanciaMetros = null,
  }) {
    return _then(
      _value.copyWith(
            paraderoId: null == paraderoId
                ? _value.paraderoId
                : paraderoId // ignore: cast_nullable_to_non_nullable
                      as int,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            distanciaMetros: null == distanciaMetros
                ? _value.distanciaMetros
                : distanciaMetros // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NearestStopEntityImplCopyWith<$Res>
    implements $NearestStopEntityCopyWith<$Res> {
  factory _$$NearestStopEntityImplCopyWith(
    _$NearestStopEntityImpl value,
    $Res Function(_$NearestStopEntityImpl) then,
  ) = __$$NearestStopEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int paraderoId, String nombre, double distanciaMetros});
}

/// @nodoc
class __$$NearestStopEntityImplCopyWithImpl<$Res>
    extends _$NearestStopEntityCopyWithImpl<$Res, _$NearestStopEntityImpl>
    implements _$$NearestStopEntityImplCopyWith<$Res> {
  __$$NearestStopEntityImplCopyWithImpl(
    _$NearestStopEntityImpl _value,
    $Res Function(_$NearestStopEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NearestStopEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paraderoId = null,
    Object? nombre = null,
    Object? distanciaMetros = null,
  }) {
    return _then(
      _$NearestStopEntityImpl(
        paraderoId: null == paraderoId
            ? _value.paraderoId
            : paraderoId // ignore: cast_nullable_to_non_nullable
                  as int,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        distanciaMetros: null == distanciaMetros
            ? _value.distanciaMetros
            : distanciaMetros // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$NearestStopEntityImpl implements _NearestStopEntity {
  const _$NearestStopEntityImpl({
    required this.paraderoId,
    required this.nombre,
    required this.distanciaMetros,
  });

  @override
  final int paraderoId;
  @override
  final String nombre;
  @override
  final double distanciaMetros;

  @override
  String toString() {
    return 'NearestStopEntity(paraderoId: $paraderoId, nombre: $nombre, distanciaMetros: $distanciaMetros)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearestStopEntityImpl &&
            (identical(other.paraderoId, paraderoId) ||
                other.paraderoId == paraderoId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.distanciaMetros, distanciaMetros) ||
                other.distanciaMetros == distanciaMetros));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, paraderoId, nombre, distanciaMetros);

  /// Create a copy of NearestStopEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearestStopEntityImplCopyWith<_$NearestStopEntityImpl> get copyWith =>
      __$$NearestStopEntityImplCopyWithImpl<_$NearestStopEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _NearestStopEntity implements NearestStopEntity {
  const factory _NearestStopEntity({
    required final int paraderoId,
    required final String nombre,
    required final double distanciaMetros,
  }) = _$NearestStopEntityImpl;

  @override
  int get paraderoId;
  @override
  String get nombre;
  @override
  double get distanciaMetros;

  /// Create a copy of NearestStopEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearestStopEntityImplCopyWith<_$NearestStopEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
