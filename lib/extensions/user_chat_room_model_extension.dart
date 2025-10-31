import 'package:insoblok/models/models.dart';

extension UserChatRoomModelExtension on UserChatRoomModel {
  static UserChatRoomModel defaultSettings(String chatroomId, String userId) {
    return UserChatRoomModel(
      roomId: chatroomId,
      userId: userId,
      isArchived: false,
      isMuted: false,
      isDeleted: false,
      unreadCount: 0,
    );
  }
}