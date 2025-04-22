import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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
    String? timestamp,
    String? url,
    String? type,
    String? isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return _$MessageModelFromJson(json);
  }
}

extension MessageModelExt on MessageModel {
  String get messageTime {
    try {
      if (timestamp != null) {
        var date = kFullDateTimeFormatter.parse(timestamp!);
        return kDateHMFormatter.format(date.toLocal());
      }
    } catch (e) {
      logger.e(e);
    }
    return kDateHMFormatter.format(DateTime.now());
  }
}

enum MessageModelType { text, image, video, audio, paid }

extension MessageModelTypeExt on MessageModelType {
  static MessageModelType fromString(String data) {
    switch (data) {
      case 'text':
        return MessageModelType.text;
      case 'image':
        return MessageModelType.image;
      case 'video':
        return MessageModelType.video;
      case 'audio':
        return MessageModelType.audio;
      case 'paid':
        return MessageModelType.paid;
    }
    return MessageModelType.text;
  }
}
