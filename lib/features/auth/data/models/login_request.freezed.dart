// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  @JsonKey(name: 'usuario')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'pass')
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'deviceUid')
  String get deviceUid => throw _privateConstructorUsedError;
  @JsonKey(name: 'modelo')
  String get modelo => throw _privateConstructorUsedError;
  @JsonKey(name: 'lat')
  double get lat => throw _privateConstructorUsedError;
  @JsonKey(name: 'lng')
  double get lng => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'usuario') String username,
    @JsonKey(name: 'pass') String password,
    @JsonKey(name: 'deviceUid') String deviceUid,
    @JsonKey(name: 'modelo') String modelo,
    @JsonKey(name: 'lat') double lat,
    @JsonKey(name: 'lng') double lng,
  });
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? deviceUid = null,
    Object? modelo = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(
      _value.copyWith(
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            deviceUid: null == deviceUid
                ? _value.deviceUid
                : deviceUid // ignore: cast_nullable_to_non_nullable
                      as String,
            modelo: null == modelo
                ? _value.modelo
                : modelo // ignore: cast_nullable_to_non_nullable
                      as String,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'usuario') String username,
    @JsonKey(name: 'pass') String password,
    @JsonKey(name: 'deviceUid') String deviceUid,
    @JsonKey(name: 'modelo') String modelo,
    @JsonKey(name: 'lat') double lat,
    @JsonKey(name: 'lng') double lng,
  });
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? deviceUid = null,
    Object? modelo = null,
    Object? lat = null,
    Object? lng = null,
  }) {
    return _then(
      _$LoginRequestImpl(
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        deviceUid: null == deviceUid
            ? _value.deviceUid
            : deviceUid // ignore: cast_nullable_to_non_nullable
                  as String,
        modelo: null == modelo
            ? _value.modelo
            : modelo // ignore: cast_nullable_to_non_nullable
                  as String,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({
    @JsonKey(name: 'usuario') required this.username,
    @JsonKey(name: 'pass') required this.password,
    @JsonKey(name: 'deviceUid') this.deviceUid = 'DEV-0042',
    @JsonKey(name: 'modelo') this.modelo = 'Samsung A54',
    @JsonKey(name: 'lat') this.lat = -5.194490,
    @JsonKey(name: 'lng') this.lng = -80.632820,
  });

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  @JsonKey(name: 'usuario')
  final String username;
  @override
  @JsonKey(name: 'pass')
  final String password;
  @override
  @JsonKey(name: 'deviceUid')
  final String deviceUid;
  @override
  @JsonKey(name: 'modelo')
  final String modelo;
  @override
  @JsonKey(name: 'lat')
  final double lat;
  @override
  @JsonKey(name: 'lng')
  final double lng;

  @override
  String toString() {
    return 'LoginRequest(username: $username, password: $password, deviceUid: $deviceUid, modelo: $modelo, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.deviceUid, deviceUid) ||
                other.deviceUid == deviceUid) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, username, password, deviceUid, modelo, lat, lng);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(this);
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({
    @JsonKey(name: 'usuario') required final String username,
    @JsonKey(name: 'pass') required final String password,
    @JsonKey(name: 'deviceUid') final String deviceUid,
    @JsonKey(name: 'modelo') final String modelo,
    @JsonKey(name: 'lat') final double lat,
    @JsonKey(name: 'lng') final double lng,
  }) = _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  @JsonKey(name: 'usuario')
  String get username;
  @override
  @JsonKey(name: 'pass')
  String get password;
  @override
  @JsonKey(name: 'deviceUid')
  String get deviceUid;
  @override
  @JsonKey(name: 'modelo')
  String get modelo;
  @override
  @JsonKey(name: 'lat')
  double get lat;
  @override
  @JsonKey(name: 'lng')
  double get lng;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
