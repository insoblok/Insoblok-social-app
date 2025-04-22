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
      regdate: json['regdate'] as String?,
      status: json['status'] as String?,
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoryModelToJson(_StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'text': instance.text,
      'regdate': instance.regdate,
      'status': instance.status,
      'medias': instance.medias,
    };

_MediaStoryModel _$MediaStoryModelFromJson(Map<String, dynamic> json) =>
    _MediaStoryModel(
      id: json['id'] as String?,
      link: json['link'] as String?,
      type: json['type'] as String?,
      regdate: json['regdate'] as String?,
    );

Map<String, dynamic> _$MediaStoryModelToJson(_MediaStoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'type': instance.type,
      'regdate': instance.regdate,
    };
