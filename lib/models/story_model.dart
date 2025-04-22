import 'package:freezed_annotation/freezed_annotation.dart';

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
    String? regdate,
    String? status,
    List<MediaStoryModel>? medias,
  }) = _StoryModel;
  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

@freezed
abstract class MediaStoryModel with _$MediaStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MediaStoryModel({
    String? id,
    String? link,
    String? type,
    String? regdate,
  }) = _MediaStoryModel;
  factory MediaStoryModel.fromJson(Map<String, dynamic> json) =>
      _$MediaStoryModelFromJson(json);
}
