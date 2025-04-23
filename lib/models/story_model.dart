import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory StoryModel({
    String? uid,
    String? title,
    String? text,
    String? regdate,
    String? status,
    String? timestamp,
    List<MediaStoryModel>? medias,
    List<String>? likes,
    List<String>? follows,
    List<StoryCommentModel>? comments,
  }) = _StoryModel;
  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
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
    String? timestamp,
    List<MediaStoryModel>? medias,
  }) = _StoryCommentModel;
  factory StoryCommentModel.fromJson(Map<String, dynamic> json) =>
      _$StoryCommentModelFromJson(json);
}
