import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory PostModel({
    String? id,
    String? uid,
    MediaStoryModel? media,
    String? timestamp,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(FirebaseHelper.fromConvertJson(json));
}
