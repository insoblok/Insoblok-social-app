// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      media: json['media'] == null
          ? null
          : MediaStoryModel.fromJson(json['media'] as Map<String, dynamic>),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'media': instance.media,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
