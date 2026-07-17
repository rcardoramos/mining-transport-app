// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      username: json['usuario'] as String,
      password: json['pass'] as String,
      deviceUid: json['deviceUid'] as String? ?? 'DEV-0042',
      modelo: json['modelo'] as String? ?? 'Samsung A54',
      lat: (json['lat'] as num?)?.toDouble() ?? -5.194490,
      lng: (json['lng'] as num?)?.toDouble() ?? -80.632820,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      'usuario': instance.username,
      'pass': instance.password,
      'deviceUid': instance.deviceUid,
      'modelo': instance.modelo,
      'lat': instance.lat,
      'lng': instance.lng,
    };
