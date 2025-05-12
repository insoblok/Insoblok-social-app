// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => _StoryModel(
      id: json['id'] as String?,
      uid: json['uid'] as String?,
      title: json['title'] as String?,
      text: json['text'] as String?,
      regdate: json['regdate'] == null
          ? null
          : DateTime.parse(json['regdate'] as String),
      status: json['status'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      follows:
          (json['follows'] as List<dynamic>?)?.map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => StoryCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryModelToJson(_StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'text': instance.text,
      'regdate': instance.regdate?.toIso8601String(),
      'status': instance.status,
      'timestamp': instance.timestamp?.toIso8601String(),
      'medias': instance.medias,
      'likes': instance.likes,
      'follows': instance.follows,
      'comments': instance.comments,
    };

_MediaStoryModel _$MediaStoryModelFromJson(Map<String, dynamic> json) =>
    _MediaStoryModel(
      link: json['link'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MediaStoryModelToJson(_MediaStoryModel instance) =>
    <String, dynamic>{
      'link': instance.link,
      'type': instance.type,
    };

_StoryCommentModel _$StoryCommentModelFromJson(Map<String, dynamic> json) =>
    _StoryCommentModel(
      uid: json['uid'] as String?,
      content: json['content'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryCommentModelToJson(_StoryCommentModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'content': instance.content,
      'timestamp': instance.timestamp?.toIso8601String(),
      'medias': instance.medias,
    };

_UpdatedStoryModel _$UpdatedStoryModelFromJson(Map<String, dynamic> json) =>
    _UpdatedStoryModel(
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UpdatedStoryModelToJson(_UpdatedStoryModel instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp?.toIso8601String(),
    };
