import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/cloudsearch/v1.dart';

import 'package:insoblok/services/services.dart';

part 'user_chat_room_model.freezed.dart';
part 'user_chat_room_model.g.dart';

@freezed
abstract class UserChatRoomModel with _$UserChatRoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserChatRoomModel({
    String? id,
    String? userId,
    String? roomId,
    bool? isArchived,
    DateTime? archivedAt,
    bool? isMuted,
    String? muteDuration,
    DateTime? mutedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    int? unreadCount,
    DateTime? lastReadAt,
  }) = _UserChatRoomModel;

  factory UserChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$UserChatRoomModelFromJson(FirebaseHelper.fromConvertJson(json));
}
