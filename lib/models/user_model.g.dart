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
  updateDate:
      json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String),
  timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
  status: json['status'] as String?,
  hasVotePost: json['has_vote_post'] as bool?,
  freeStyle: json['free_style'] as bool?,
  isPremium: json['is_premium'] as bool?,
  rewardDate: (json['reward_date'] as num?)?.toInt(),
  transferedXP: (json['transfered_x_p'] as num?)?.toInt(),
  transferedInSo: (json['transfered_in_so'] as num?)?.toInt(),
  likes: (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  follows:
      (json['follows'] as List<dynamic>?)?.map((e) => e as String).toList(),
  views: (json['views'] as List<dynamic>?)?.map((e) => e as String).toList(),
  userActions:
      (json['user_actions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  galleries:
      (json['galleries'] as List<dynamic>?)?.map((e) => e as String).toList(),
  actions:
      (json['actions'] as List<dynamic>?)
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
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'status': instance.status,
      'has_vote_post': instance.hasVotePost,
      'free_style': instance.freeStyle,
      'is_premium': instance.isPremium,
      'reward_date': instance.rewardDate,
      'transfered_x_p': instance.transferedXP,
      'transfered_in_so': instance.transferedInSo,
      'likes': instance.likes,
      'follows': instance.follows,
      'views': instance.views,
      'user_actions': instance.userActions,
      'galleries': instance.galleries,
      'actions': instance.actions,
    };

_UserActionModel _$UserActionModelFromJson(Map<String, dynamic> json) =>
    _UserActionModel(
      postId: json['post_id'] as String?,
      postUserId: json['post_user_id'] as String?,
      value: json['value'] as bool?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UserActionModelToJson(_UserActionModel instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'post_user_id': instance.postUserId,
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
    <String, dynamic>{'name': instance.name, 'code': instance.code};
