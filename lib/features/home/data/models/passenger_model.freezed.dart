// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'passenger_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PassengerModel _$PassengerModelFromJson(Map<String, dynamic> json) {
  return _PassengerModel.fromJson(json);
}

/// @nodoc
mixin _$PassengerModel {
  String get dni => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get boardedAt => throw _privateConstructorUsedError;
  String get registrationMethod => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get seatNumber => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;

  /// Serializes this PassengerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PassengerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PassengerModelCopyWith<PassengerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PassengerModelCopyWith<$Res> {
  factory $PassengerModelCopyWith(
    PassengerModel value,
    $Res Function(PassengerModel) then,
  ) = _$PassengerModelCopyWithImpl<$Res, PassengerModel>;
  @useResult
  $Res call({
    String dni,
    String fullName,
    String boardedAt,
    String registrationMethod,
    String status,
    String? seatNumber,
    String category,
  });
}

/// @nodoc
class _$PassengerModelCopyWithImpl<$Res, $Val extends PassengerModel>
    implements $PassengerModelCopyWith<$Res> {
  _$PassengerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PassengerModel
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
                      as String,
            registrationMethod: null == registrationMethod
                ? _value.registrationMethod
                : registrationMethod // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$PassengerModelImplCopyWith<$Res>
    implements $PassengerModelCopyWith<$Res> {
  factory _$$PassengerModelImplCopyWith(
    _$PassengerModelImpl value,
    $Res Function(_$PassengerModelImpl) then,
  ) = __$$PassengerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dni,
    String fullName,
    String boardedAt,
    String registrationMethod,
    String status,
    String? seatNumber,
    String category,
  });
}

/// @nodoc
class __$$PassengerModelImplCopyWithImpl<$Res>
    extends _$PassengerModelCopyWithImpl<$Res, _$PassengerModelImpl>
    implements _$$PassengerModelImplCopyWith<$Res> {
  __$$PassengerModelImplCopyWithImpl(
    _$PassengerModelImpl _value,
    $Res Function(_$PassengerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PassengerModel
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
      _$PassengerModelImpl(
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
                  as String,
        registrationMethod: null == registrationMethod
            ? _value.registrationMethod
            : registrationMethod // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$PassengerModelImpl implements _PassengerModel {
  const _$PassengerModelImpl({
    required this.dni,
    required this.fullName,
    required this.boardedAt,
    required this.registrationMethod,
    required this.status,
    this.seatNumber,
    this.category = 'Miski Mayo',
  });

  factory _$PassengerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PassengerModelImplFromJson(json);

  @override
  final String dni;
  @override
  final String fullName;
  @override
  final String boardedAt;
  @override
  final String registrationMethod;
  @override
  final String status;
  @override
  final String? seatNumber;
  @override
  @JsonKey()
  final String category;

  @override
  String toString() {
    return 'PassengerModel(dni: $dni, fullName: $fullName, boardedAt: $boardedAt, registrationMethod: $registrationMethod, status: $status, seatNumber: $seatNumber, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PassengerModelImpl &&
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

  /// Create a copy of PassengerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PassengerModelImplCopyWith<_$PassengerModelImpl> get copyWith =>
      __$$PassengerModelImplCopyWithImpl<_$PassengerModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PassengerModelImplToJson(this);
  }
}

abstract class _PassengerModel implements PassengerModel {
  const factory _PassengerModel({
    required final String dni,
    required final String fullName,
    required final String boardedAt,
    required final String registrationMethod,
    required final String status,
    final String? seatNumber,
    final String category,
  }) = _$PassengerModelImpl;

  factory _PassengerModel.fromJson(Map<String, dynamic> json) =
      _$PassengerModelImpl.fromJson;

  @override
  String get dni;
  @override
  String get fullName;
  @override
  String get boardedAt;
  @override
  String get registrationMethod;
  @override
  String get status;
  @override
  String? get seatNumber;
  @override
  String get category;

  /// Create a copy of PassengerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PassengerModelImplCopyWith<_$PassengerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
