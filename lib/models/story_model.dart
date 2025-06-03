import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryModel({
    String? id,
    String? uid,
    String? title,
    String? text,
    String? status,
    String? category,
    List<String>? likes,
    List<String>? follows,
    DateTime? updateDate,
    DateTime? timestamp,
    List<StoryCommentModel>? comments,
    List<StoryVoteModel>? votes,
    List<MediaStoryModel>? medias,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class StoryVoteModel with _$StoryVoteModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryVoteModel({String? uid, bool? vote, DateTime? timestamp}) =
      _StoryVoteModel;

  factory StoryVoteModel.fromJson(Map<String, dynamic> json) =>
      _$StoryVoteModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class MediaStoryModel with _$MediaStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MediaStoryModel({String? link, String? type}) = _MediaStoryModel;

  factory MediaStoryModel.fromJson(Map<String, dynamic> json) =>
      _$MediaStoryModelFromJson(json);
}

@freezed
abstract class StoryCommentModel with _$StoryCommentModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryCommentModel({
    String? uid,
    String? content,
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
