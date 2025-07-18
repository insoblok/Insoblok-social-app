// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tastescore_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TastescoreModel _$TastescoreModelFromJson(Map<String, dynamic> json) =>
    _TastescoreModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      postId: json['post_id'] as String?,
      postUserId: json['post_user_id'] as String?,
      type: json['type'] as String?,
      bonus: (json['bonus'] as num?)?.toInt(),
      desc: json['desc'] as String?,
      updateDate:
          json['update_date'] == null
              ? null
              : DateTime.parse(json['update_date'] as String),
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$TastescoreModelToJson(_TastescoreModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'post_id': instance.postId,
      'post_user_id': instance.postUserId,
      'type': instance.type,
      'bonus': instance.bonus,
      'desc': instance.desc,
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
    };
