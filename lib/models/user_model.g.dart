// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      walletAddress: json['wallet_address'] as String?,
      avatar: json['avatar'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      website: json['website'] as String?,
      desc: json['desc'] as String?,
      discovery: json['discovery'] as String?,
      nickId: json['nick_id'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
      ipAddress: json['ip_address'] as String?,
      regdate: json['regdate'] as String?,
      updateDate: json['update_date'] as String?,
      status: json['status'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      follows:
          (json['follows'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'wallet_address': instance.walletAddress,
      'avatar': instance.avatar,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'password': instance.password,
      'city': instance.city,
      'country': instance.country,
      'website': instance.website,
      'desc': instance.desc,
      'discovery': instance.discovery,
      'nick_id': instance.nickId,
      'lat': instance.lat,
      'lon': instance.lon,
      'ip_address': instance.ipAddress,
      'regdate': instance.regdate,
      'update_date': instance.updateDate,
      'status': instance.status,
      'likes': instance.likes,
      'follows': instance.follows,
    };

_UserCountryModel _$UserCountryModelFromJson(Map<String, dynamic> json) =>
    _UserCountryModel(
      name: json['name'] as String?,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$UserCountryModelToJson(_UserCountryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
    };
