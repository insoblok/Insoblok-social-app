// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String?,
      walletAddress: json['wallet_address'] as String?,
      avatar: json['avatar'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      ipAddress: json['ip_address'] as String?,
      regdate: json['regdate'] as String?,
      updateDate: json['update_date'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'wallet_address': instance.walletAddress,
      'avatar': instance.avatar,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'lat': instance.lat,
      'lon': instance.lon,
      'ip_address': instance.ipAddress,
      'regdate': instance.regdate,
      'update_date': instance.updateDate,
    };
