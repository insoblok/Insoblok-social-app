import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MessageModel({
    String? id,
    String? senderId,
    String? content,
    String? url,
    String? type,
    String? regDate,
    String? updateDate,
  }) = _MessageModel;
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
