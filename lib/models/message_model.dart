import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MessageModel({
    String? id,
    String? content,
    String? senderId,
    String? senderName,
    DateTime? timestamp,
    String? url,
    String? type,
    String? isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return _$MessageModelFromJson(FirebaseHelper.fromConvertJson(json));
  }
}
