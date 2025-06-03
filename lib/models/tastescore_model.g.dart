// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tastescore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TastescoreModel _$TastescoreModelFromJson(Map<String, dynamic> json) =>
    _TastescoreModel(
      id: json['id'] as String?,
      key: json['key'] as String?,
      postId: json['post_id'] as String?,
      userUid: json['user_uid'] as String?,
      connects: (json['connects'] as List<dynamic>?)
          ?.map((e) => ConnectedStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      updateDate: json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TastescoreModelToJson(_TastescoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'post_id': instance.postId,
      'user_uid': instance.userUid,
      'connects': instance.connects,
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
    };

_ConnectedStoryModel _$ConnectedStoryModelFromJson(Map<String, dynamic> json) =>
    _ConnectedStoryModel(
      postId: json['post_id'] as String?,
      userUid: json['user_uid'] as String?,
    );

Map<String, dynamic> _$ConnectedStoryModelToJson(
        _ConnectedStoryModel instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'user_uid': instance.userUid,
    };
