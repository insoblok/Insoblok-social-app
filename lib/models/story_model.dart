import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryModel({
    String? id,
    String? userId,
    String? title,
    String? text,
    String? status,
    String? category,
    List<String>? likes,
    List<String>? follows,
    List<String>? views,
    DateTime? updateDate,
    DateTime? timestamp,
    List<ConnectedStoryModel>? connects,
    List<String>? comments,
    List<String>? allowUsers,
    List<StoryVoteModel>? votes,
    List<MediaStoryModel>? medias,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class StoryVoteModel with _$StoryVoteModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryVoteModel({String? userId, bool? vote, DateTime? timestamp}) =
      _StoryVoteModel;

  factory StoryVoteModel.fromJson(Map<String, dynamic> json) =>
      _$StoryVoteModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class MediaStoryModel with _$MediaStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MediaStoryModel({
    String? link,
    String? thumb,
    String? type,
    double? width,
    double? height,
  }) = _MediaStoryModel;

  factory MediaStoryModel.fromJson(Map<String, dynamic> json) =>
      _$MediaStoryModelFromJson(json);
}

@freezed
abstract class StoryCommentModel with _$StoryCommentModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryCommentModel({
    String? id,
    String? userId,
    String? storyId,
    String? commentId,
    String? content,
    List<String>? likes,
    DateTime? timestamp,
    List<MediaStoryModel>? medias,
  }) = _StoryCommentModel;

  factory StoryCommentModel.fromJson(Map<String, dynamic> json) =>
      _$StoryCommentModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class UpdatedStoryModel with _$UpdatedStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UpdatedStoryModel({DateTime? timestamp}) = _UpdatedStoryModel;

  factory UpdatedStoryModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatedStoryModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class ConnectedStoryModel with _$ConnectedStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ConnectedStoryModel({String? postId, String? userId}) =
      _ConnectedStoryModel;

  factory ConnectedStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectedStoryModelFromJson(json);
}
