import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/enums/enums.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory MessageModel({
    String? id,
    String? chatId,
    String? content,
    String? senderId,
    String? type,
    String? status,
    String? senderName,
    DateTime? timestamp,
    List<String>? medias,
    List<String>? readBy,
    bool? isRead,
  }) = _MessageModel;
  
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    

    return _$MessageModelFromJson(FirebaseHelper.fromConvertJson(json));
  }

  // Map<String, dynamic> toJson() => _$MessageModelToJson(this as _MessageModel);
  
}
