// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stop_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StopModel _$StopModelFromJson(Map<String, dynamic> json) {
  return _StopModel.fromJson(json);
}

/// @nodoc
mixin _$StopModel {
  String get id => throw _privateConstructorUsedError;
  String get nombre => throw _privateConstructorUsedError;
  double get latitud => throw _privateConstructorUsedError;
  double get longitud => throw _privateConstructorUsedError;
  double get radioPermitido => throw _privateConstructorUsedError;
  int get orden => throw _privateConstructorUsedError;
  bool get completado => throw _privateConstructorUsedError;

  /// Serializes this StopModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StopModelCopyWith<StopModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StopModelCopyWith<$Res> {
  factory $StopModelCopyWith(StopModel value, $Res Function(StopModel) then) =
      _$StopModelCopyWithImpl<$Res, StopModel>;
  @useResult
  $Res call({
    String id,
    String nombre,
    double latitud,
    double longitud,
    double radioPermitido,
    int orden,
    bool completado,
  });
}

/// @nodoc
class _$StopModelCopyWithImpl<$Res, $Val extends StopModel>
    implements $StopModelCopyWith<$Res> {
  _$StopModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? latitud = null,
    Object? longitud = null,
    Object? radioPermitido = null,
    Object? orden = null,
    Object? completado = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nombre: null == nombre
                ? _value.nombre
                : nombre // ignore: cast_nullable_to_non_nullable
                      as String,
            latitud: null == latitud
                ? _value.latitud
                : latitud // ignore: cast_nullable_to_non_nullable
                      as double,
            longitud: null == longitud
                ? _value.longitud
                : longitud // ignore: cast_nullable_to_non_nullable
                      as double,
            radioPermitido: null == radioPermitido
                ? _value.radioPermitido
                : radioPermitido // ignore: cast_nullable_to_non_nullable
                      as double,
            orden: null == orden
                ? _value.orden
                : orden // ignore: cast_nullable_to_non_nullable
                      as int,
            completado: null == completado
                ? _value.completado
                : completado // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StopModelImplCopyWith<$Res>
    implements $StopModelCopyWith<$Res> {
  factory _$$StopModelImplCopyWith(
    _$StopModelImpl value,
    $Res Function(_$StopModelImpl) then,
  ) = __$$StopModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nombre,
    double latitud,
    double longitud,
    double radioPermitido,
    int orden,
    bool completado,
  });
}

/// @nodoc
class __$$StopModelImplCopyWithImpl<$Res>
    extends _$StopModelCopyWithImpl<$Res, _$StopModelImpl>
    implements _$$StopModelImplCopyWith<$Res> {
  __$$StopModelImplCopyWithImpl(
    _$StopModelImpl _value,
    $Res Function(_$StopModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StopModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nombre = null,
    Object? latitud = null,
    Object? longitud = null,
    Object? radioPermitido = null,
    Object? orden = null,
    Object? completado = null,
  }) {
    return _then(
      _$StopModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nombre: null == nombre
            ? _value.nombre
            : nombre // ignore: cast_nullable_to_non_nullable
                  as String,
        latitud: null == latitud
            ? _value.latitud
            : latitud // ignore: cast_nullable_to_non_nullable
                  as double,
        longitud: null == longitud
            ? _value.longitud
            : longitud // ignore: cast_nullable_to_non_nullable
                  as double,
        radioPermitido: null == radioPermitido
            ? _value.radioPermitido
            : radioPermitido // ignore: cast_nullable_to_non_nullable
                  as double,
        orden: null == orden
            ? _value.orden
            : orden // ignore: cast_nullable_to_non_nullable
                  as int,
        completado: null == completado
            ? _value.completado
            : completado // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StopModelImpl extends _StopModel {
  const _$StopModelImpl({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.radioPermitido,
    required this.orden,
    this.completado = false,
  }) : super._();

  factory _$StopModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StopModelImplFromJson(json);

  @override
  final String id;
  @override
  final String nombre;
  @override
  final double latitud;
  @override
  final double longitud;
  @override
  final double radioPermitido;
  @override
  final int orden;
  @override
  @JsonKey()
  final bool completado;

  @override
  String toString() {
    return 'StopModel(id: $id, nombre: $nombre, latitud: $latitud, longitud: $longitud, radioPermitido: $radioPermitido, orden: $orden, completado: $completado)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StopModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nombre, nombre) || other.nombre == nombre) &&
            (identical(other.latitud, latitud) || other.latitud == latitud) &&
            (identical(other.longitud, longitud) ||
                other.longitud == longitud) &&
            (identical(other.radioPermitido, radioPermitido) ||
                other.radioPermitido == radioPermitido) &&
            (identical(other.orden, orden) || other.orden == orden) &&
            (identical(other.completado, completado) ||
                other.completado == completado));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nombre,
    latitud,
    longitud,
    radioPermitido,
    orden,
    completado,
  );

  /// Create a copy of StopModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StopModelImplCopyWith<_$StopModelImpl> get copyWith =>
      __$$StopModelImplCopyWithImpl<_$StopModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StopModelImplToJson(this);
  }
}

abstract class _StopModel extends StopModel {
  const factory _StopModel({
    required final String id,
    required final String nombre,
    required final double latitud,
    required final double longitud,
    required final double radioPermitido,
    required final int orden,
    final bool completado,
  }) = _$StopModelImpl;
  const _StopModel._() : super._();

  factory _StopModel.fromJson(Map<String, dynamic> json) =
      _$StopModelImpl.fromJson;

  @override
  String get id;
  @override
  String get nombre;
  @override
  double get latitud;
  @override
  double get longitud;
  @override
  double get radioPermitido;
  @override
  int get orden;
  @override
  bool get completado;

  /// Create a copy of StopModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StopModelImplCopyWith<_$StopModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
