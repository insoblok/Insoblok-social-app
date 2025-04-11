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
    String? isRead,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return _$MessageModelFromJson(json);
  }
}

enum MessageModelType {
  text,
  image,
  video,
  audio,
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
