// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearest_stop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NearestStopModel _$NearestStopModelFromJson(Map<String, dynamic> json) {
  return _NearestStopModel.fromJson(json);
}

/// @nodoc
mixin _$NearestStopModel {
  @JsonKey(name: 'ParaderoId')
  int get paraderoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'Nombre')
  String get nombre => throw _privateConstructorUsedError;
  @JsonKey(name: 'DistanciaMetros')
  double get distanciaMetros => throw _privateConstructorUsedError;

  /// Serializes this NearestStopModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearestStopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearestStopModelCopyWith<NearestStopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearestStopModelCopyWith<$Res> {
  factory $NearestStopModelCopyWith(
    NearestStopModel value,
    $Res Function(NearestStopModel) then,
  ) = _$NearestStopModelCopyWithImpl<$Res, NearestStopModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'ParaderoId') int paraderoId,
    @JsonKey(name: 'Nombre') String nombre,
    @JsonKey(name: 'DistanciaMetros') double distanciaMetros,
  });
}

/// @nodoc
class _$NearestStopModelCopyWithImpl<$Res, $Val extends NearestStopModel>
    implements $NearestStopModelCopyWith<$Res> {
  _$NearestStopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearestStopModel
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
abstract class _$$NearestStopModelImplCopyWith<$Res>
    implements $NearestStopModelCopyWith<$Res> {
  factory _$$NearestStopModelImplCopyWith(
    _$NearestStopModelImpl value,
    $Res Function(_$NearestStopModelImpl) then,
  ) = __$$NearestStopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'ParaderoId') int paraderoId,
    @JsonKey(name: 'Nombre') String nombre,
    @JsonKey(name: 'DistanciaMetros') double distanciaMetros,
  });
}

/// @nodoc
class __$$NearestStopModelImplCopyWithImpl<$Res>
    extends _$NearestStopModelCopyWithImpl<$Res, _$NearestStopModelImpl>
    implements _$$NearestStopModelImplCopyWith<$Res> {
  __$$NearestStopModelImplCopyWithImpl(
    _$NearestStopModelImpl _value,
    $Res Function(_$NearestStopModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NearestStopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paraderoId = null,
    Object? nombre = null,
    Object? distanciaMetros = null,
  }) {
    return _then(
      _$NearestStopModelImpl(
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
@JsonSerializable()
class _$NearestStopModelImpl extends _NearestStopModel {
  const _$NearestStopModelImpl({
    @JsonKey(name: 'ParaderoId') required this.paraderoId,
    @JsonKey(name: 'Nombre') required this.nombre,
    @JsonKey(name: 'DistanciaMetros') required this.distanciaMetros,
  }) : super._();

  factory _$NearestStopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearestStopModelImplFromJson(json);

  @override
  @JsonKey(name: 'ParaderoId')
  final int paraderoId;
  @override
  @JsonKey(name: 'Nombre')
  final String nombre;
  @override
  @JsonKey(name: 'DistanciaMetros')
  final double distanciaMetros;

  @override
  String toString() {
    return 'NearestStopModel(paraderoId: $paraderoId, nombre: $nombre, distanciaMetros: $distanciaMetros)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearestStopModelImpl &&
            (identical(other.paraderoId, paraderoId) ||
                other.paraderoId == paraderoId) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.distanciaMetros, distanciaMetros) ||
                other.distanciaMetros == distanciaMetros));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, paraderoId, nombre, distanciaMetros);

  /// Create a copy of NearestStopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearestStopModelImplCopyWith<_$NearestStopModelImpl> get copyWith =>
      __$$NearestStopModelImplCopyWithImpl<_$NearestStopModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NearestStopModelImplToJson(this);
  }
}

abstract class _NearestStopModel extends NearestStopModel {
  const factory _NearestStopModel({
    @JsonKey(name: 'ParaderoId') required final int paraderoId,
    @JsonKey(name: 'Nombre') required final String nombre,
    @JsonKey(name: 'DistanciaMetros') required final double distanciaMetros,
  }) = _$NearestStopModelImpl;
  const _NearestStopModel._() : super._();

  factory _NearestStopModel.fromJson(Map<String, dynamic> json) =
      _$NearestStopModelImpl.fromJson;

  @override
  @JsonKey(name: 'ParaderoId')
  int get paraderoId;
  @override
  @JsonKey(name: 'Nombre')
  String get nombre;
  @override
  @JsonKey(name: 'DistanciaMetros')
  double get distanciaMetros;

  /// Create a copy of NearestStopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearestStopModelImplCopyWith<_$NearestStopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
