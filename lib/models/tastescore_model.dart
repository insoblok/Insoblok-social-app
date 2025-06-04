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
    DateTime? updateDate,
    DateTime? timestamp,
  }) = _TastescoreModel;

  factory TastescoreModel.fromJson(Map<String, dynamic> json) =>
      _$TastescoreModelFromJson(json);
}
