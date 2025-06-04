import 'package:freezed_annotation/freezed_annotation.dart';

part 'tastescore_model.freezed.dart';
part 'tastescore_model.g.dart';

@freezed
abstract class TastescoreModel with _$TastescoreModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory TastescoreModel({
    String? id,
    String? uid,
    String? postId,
    String? userUid,
    String? type,
    int? bonus,
    String? desc,
    List<ConnectedStoryModel>? connects,
    DateTime? updateDate,
    DateTime? timestamp,
  }) = _TastescoreModel;

  factory TastescoreModel.fromJson(Map<String, dynamic> json) =>
      _$TastescoreModelFromJson(json);
}

@freezed
abstract class ConnectedStoryModel with _$ConnectedStoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ConnectedStoryModel({String? postId, String? userUid}) =
      _ConnectedStoryModel;

  factory ConnectedStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectedStoryModelFromJson(json);
}
