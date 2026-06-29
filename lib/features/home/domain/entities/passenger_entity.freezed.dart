// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passenger_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PassengerEntity _$PassengerEntityFromJson(Map<String, dynamic> json) {
  return _PassengerEntity.fromJson(json);
}

/// @nodoc
mixin _$PassengerEntity {
  /// DNI del pasajero (8 dígitos)
  String get dni => throw _privateConstructorUsedError;

  /// Nombre completo (disponible cuando se resuelva contra la BD offline)
  String get fullName => throw _privateConstructorUsedError;

  /// Hora exacta de registro del embarque
  DateTime get boardedAt => throw _privateConstructorUsedError;

  /// Método de registro: 'qr_scan' | 'manual'
  String get registrationMethod => throw _privateConstructorUsedError;

  /// Estado laboral del colaborador al embarcar
  CollaboratorStatus get status => throw _privateConstructorUsedError;

  /// Número de asiento asignado (null hasta que se asigne)
  String? get seatNumber => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this PassengerEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PassengerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PassengerEntityCopyWith<PassengerEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerEntityCopyWith<$Res> {
  factory $PassengerEntityCopyWith(
    PassengerEntity value,
    $Res Function(PassengerEntity) then,
  ) = _$PassengerEntityCopyWithImpl<$Res, PassengerEntity>;
  @useResult
  $Res call({
    String dni,
    String fullName,
    DateTime boardedAt,
    String registrationMethod,
    CollaboratorStatus status,
    String? seatNumber,
    String category,
  });
}

/// @nodoc
class _$PassengerEntityCopyWithImpl<$Res, $Val extends PassengerEntity>
    implements $PassengerEntityCopyWith<$Res> {
  _$PassengerEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PassengerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? boardedAt = null,
    Object? registrationMethod = null,
    Object? status = null,
    Object? seatNumber = freezed,
    Object? category = null,
  }) {
    return _then(
      _value.copyWith(
            dni: null == dni
                ? _value.dni
                : dni // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            boardedAt: null == boardedAt
                ? _value.boardedAt
                : boardedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            registrationMethod: null == registrationMethod
                ? _value.registrationMethod
                : registrationMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as CollaboratorStatus,
            seatNumber: freezed == seatNumber
                ? _value.seatNumber
                : seatNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PassengerEntityImplCopyWith<$Res>
    implements $PassengerEntityCopyWith<$Res> {
  factory _$$PassengerEntityImplCopyWith(
    _$PassengerEntityImpl value,
    $Res Function(_$PassengerEntityImpl) then,
  ) = __$$PassengerEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dni,
    String fullName,
    DateTime boardedAt,
    String registrationMethod,
    CollaboratorStatus status,
    String? seatNumber,
    String category,
  });
}

/// @nodoc
class __$$PassengerEntityImplCopyWithImpl<$Res>
    extends _$PassengerEntityCopyWithImpl<$Res, _$PassengerEntityImpl>
    implements _$$PassengerEntityImplCopyWith<$Res> {
  __$$PassengerEntityImplCopyWithImpl(
    _$PassengerEntityImpl _value,
    $Res Function(_$PassengerEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PassengerEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dni = null,
    Object? fullName = null,
    Object? boardedAt = null,
    Object? registrationMethod = null,
    Object? status = null,
    Object? seatNumber = freezed,
    Object? category = null,
  }) {
    return _then(
      _$PassengerEntityImpl(
        dni: null == dni
            ? _value.dni
            : dni // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        boardedAt: null == boardedAt
            ? _value.boardedAt
            : boardedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        registrationMethod: null == registrationMethod
            ? _value.registrationMethod
            : registrationMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as CollaboratorStatus,
        seatNumber: freezed == seatNumber
            ? _value.seatNumber
            : seatNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PassengerEntityImpl implements _PassengerEntity {
  const _$PassengerEntityImpl({
    required this.dni,
    required this.fullName,
    required this.boardedAt,
    required this.registrationMethod,
    required this.status,
    this.seatNumber,
    this.category = 'Miski Mayo',
  });

  factory _$PassengerEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassengerEntityImplFromJson(json);

  /// DNI del pasajero (8 dígitos)
  @override
  final String dni;

  /// Nombre completo (disponible cuando se resuelva contra la BD offline)
  @override
  final String fullName;

  /// Hora exacta de registro del embarque
  @override
  final DateTime boardedAt;

  /// Método de registro: 'qr_scan' | 'manual'
  @override
  final String registrationMethod;

  /// Estado laboral del colaborador al embarcar
  @override
  final CollaboratorStatus status;

  /// Número de asiento asignado (null hasta que se asigne)
  @override
  final String? seatNumber;
  @override
  @JsonKey()
  final String category;

  @override
  String toString() {
    return 'PassengerEntity(dni: $dni, fullName: $fullName, boardedAt: $boardedAt, registrationMethod: $registrationMethod, status: $status, seatNumber: $seatNumber, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassengerEntityImpl &&
            (identical(other.dni, dni) || other.dni == dni) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.boardedAt, boardedAt) ||
                other.boardedAt == boardedAt) &&
            (identical(other.registrationMethod, registrationMethod) ||
                other.registrationMethod == registrationMethod) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.seatNumber, seatNumber) ||
                other.seatNumber == seatNumber) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dni,
    fullName,
    boardedAt,
    registrationMethod,
    status,
    seatNumber,
    category,
  );

  /// Create a copy of PassengerEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassengerEntityImplCopyWith<_$PassengerEntityImpl> get copyWith =>
      __$$PassengerEntityImplCopyWithImpl<_$PassengerEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PassengerEntityImplToJson(this);
  }
}

abstract class _PassengerEntity implements PassengerEntity {
  const factory _PassengerEntity({
    required final String dni,
    required final String fullName,
    required final DateTime boardedAt,
    required final String registrationMethod,
    required final CollaboratorStatus status,
    final String? seatNumber,
    final String category,
  }) = _$PassengerEntityImpl;

  factory _PassengerEntity.fromJson(Map<String, dynamic> json) =
      _$PassengerEntityImpl.fromJson;

  /// DNI del pasajero (8 dígitos)
  @override
  String get dni;

  /// Nombre completo (disponible cuando se resuelva contra la BD offline)
  @override
  String get fullName;

  /// Hora exacta de registro del embarque
  @override
  DateTime get boardedAt;

  /// Método de registro: 'qr_scan' | 'manual'
  @override
  String get registrationMethod;

  /// Estado laboral del colaborador al embarcar
  @override
  CollaboratorStatus get status;

  /// Número de asiento asignado (null hasta que se asigne)
  @override
  String? get seatNumber;
  @override
  String get category;

  /// Create a copy of PassengerEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassengerEntityImplCopyWith<_$PassengerEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
