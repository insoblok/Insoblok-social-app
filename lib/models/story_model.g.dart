// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => _StoryModel(
  id: json['id'] as String?,
  userId: json['user_id'] as String?,
  title: json['title'] as String?,
  text: json['text'] as String?,
  status: json['status'] as String?,
  category: json['category'] as String?,
  likes: (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  follows:
      (json['follows'] as List<dynamic>?)?.map((e) => e as String).toList(),
  views: (json['views'] as List<dynamic>?)?.map((e) => e as String).toList(),
  placeId: json['place_id'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  deletedAt:
      json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
  connects:
      (json['connects'] as List<dynamic>?)
          ?.map((e) => ConnectedStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  comments:
      (json['comments'] as List<dynamic>?)?.map((e) => e as String).toList(),
  allowUsers:
      (json['allow_users'] as List<dynamic>?)?.map((e) => e as String).toList(),
  reactions:
      (json['reactions'] as List<dynamic>?)?.map((e) => e as String).toList(),
  votes:
      (json['votes'] as List<dynamic>?)
          ?.map((e) => StoryVoteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  medias:
      (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$StoryModelToJson(_StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'text': instance.text,
      'status': instance.status,
      'category': instance.category,
      'likes': instance.likes,
      'follows': instance.follows,
      'views': instance.views,
      'place_id': instance.placeId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'connects': instance.connects,
      'comments': instance.comments,
      'allow_users': instance.allowUsers,
      'reactions': instance.reactions,
      'votes': instance.votes,
      'medias': instance.medias,
    };

_StoryVoteModel _$StoryVoteModelFromJson(Map<String, dynamic> json) =>
    _StoryVoteModel(
      userId: json['user_id'] as String?,
      vote: json['vote'] as bool?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$StoryVoteModelToJson(_StoryVoteModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'vote': instance.vote,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

_MediaStoryModel _$MediaStoryModelFromJson(Map<String, dynamic> json) =>
    _MediaStoryModel(
      link: json['link'] as String?,
      thumb: json['thumb'] as String?,
      type: json['type'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      publicId: json['public_id'] as String?,
    );

Map<String, dynamic> _$MediaStoryModelToJson(_MediaStoryModel instance) =>
    <String, dynamic>{
      'link': instance.link,
      'thumb': instance.thumb,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'public_id': instance.publicId,
    };

_StoryCommentModel _$StoryCommentModelFromJson(Map<String, dynamic> json) =>
    _StoryCommentModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      storyId: json['story_id'] as String?,
      commentId: json['comment_id'] as String?,
      content: json['content'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
      medias:
          (json['medias'] as List<dynamic>?)
              ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$StoryCommentModelToJson(_StoryCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'story_id': instance.storyId,
      'comment_id': instance.commentId,
      'content': instance.content,
      'likes': instance.likes,
      'timestamp': instance.timestamp?.toIso8601String(),
      'medias': instance.medias,
    };

_UpdatedStoryModel _$UpdatedStoryModelFromJson(Map<String, dynamic> json) =>
    _UpdatedStoryModel(
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$UpdatedStoryModelToJson(_UpdatedStoryModel instance) =>
    <String, dynamic>{'timestamp': instance.timestamp?.toIso8601String()};

_ConnectedStoryModel _$ConnectedStoryModelFromJson(Map<String, dynamic> json) =>
    _ConnectedStoryModel(
      postId: json['post_id'] as String?,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$ConnectedStoryModelToJson(
  _ConnectedStoryModel instance,
) => <String, dynamic>{'post_id': instance.postId, 'user_id': instance.userId};
