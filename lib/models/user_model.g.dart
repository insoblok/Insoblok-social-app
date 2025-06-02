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
      regdate: json['regdate'] == null
          ? null
          : DateTime.parse(json['regdate'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      follows:
          (json['follows'] as List<dynamic>?)?.map((e) => e as String).toList(),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => UserActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'regdate': instance.regdate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'status': instance.status,
      'likes': instance.likes,
      'follows': instance.follows,
      'actions': instance.actions,
    };

_UserActionModel _$UserActionModelFromJson(Map<String, dynamic> json) =>
    _UserActionModel(
      postUid: json['post_uid'] as String?,
      userUid: json['user_uid'] as String?,
      value: json['value'] as bool?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserActionModelToJson(_UserActionModel instance) =>
    <String, dynamic>{
      'post_uid': instance.postUid,
      'user_uid': instance.userUid,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
      'timestamp': instance.timestamp?.toIso8601String(),
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
