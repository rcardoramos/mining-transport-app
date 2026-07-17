import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @JsonKey(name: 'usuario') required String username,
    @JsonKey(name: 'pass') required String password,
    @JsonKey(name: 'deviceUid') @Default('DEV-0042') String deviceUid,
    @JsonKey(name: 'modelo') @Default('Samsung A54') String modelo,
    @JsonKey(name: 'lat') @Default(-5.194490) double lat,
    @JsonKey(name: 'lng') @Default(-80.632820) double lng,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}
