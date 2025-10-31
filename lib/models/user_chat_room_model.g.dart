// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserChatRoomModel _$UserChatRoomModelFromJson(Map<String, dynamic> json) =>
    _UserChatRoomModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      roomId: json['room_id'] as String?,
      isArchived: json['is_archived'] as bool?,
      archivedAt:
          json['archived_at'] == null
              ? null
              : DateTime.parse(json['archived_at'] as String),
      isMuted: json['is_muted'] as bool?,
      muteDuration: json['mute_duration'] as String?,
      mutedAt:
          json['muted_at'] == null
              ? null
              : DateTime.parse(json['muted_at'] as String),
      isDeleted: json['is_deleted'] as bool?,
      deletedAt:
          json['deleted_at'] == null
              ? null
              : DateTime.parse(json['deleted_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt(),
      lastReadAt:
          json['last_read_at'] == null
              ? null
              : DateTime.parse(json['last_read_at'] as String),
    );

Map<String, dynamic> _$UserChatRoomModelToJson(_UserChatRoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'room_id': instance.roomId,
      'is_archived': instance.isArchived,
      'archived_at': instance.archivedAt?.toIso8601String(),
      'is_muted': instance.isMuted,
      'mute_duration': instance.muteDuration,
      'muted_at': instance.mutedAt?.toIso8601String(),
      'is_deleted': instance.isDeleted,
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'unread_count': instance.unreadCount,
      'last_read_at': instance.lastReadAt?.toIso8601String(),
    };
