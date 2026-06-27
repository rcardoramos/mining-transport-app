// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passenger_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PassengerModelImpl _$$PassengerModelImplFromJson(Map<String, dynamic> json) =>
    _$PassengerModelImpl(
      dni: json['dni'] as String,
      fullName: json['fullName'] as String,
      boardedAt: json['boardedAt'] as String,
      registrationMethod: json['registrationMethod'] as String,
      status: json['status'] as String,
      seatNumber: json['seatNumber'] as String?,
    );

Map<String, dynamic> _$$PassengerModelImplToJson(
  _$PassengerModelImpl instance,
) => <String, dynamic>{
  'dni': instance.dni,
  'fullName': instance.fullName,
  'boardedAt': instance.boardedAt,
  'registrationMethod': instance.registrationMethod,
  'status': instance.status,
  'seatNumber': instance.seatNumber,
};
