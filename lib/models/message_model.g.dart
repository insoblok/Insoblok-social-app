// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(
  Map<String, dynamic> json,
) => _MessageModel(
  id: json['id'] as String?,
  chatId: json['chat_id'] as String?,
  content: json['content'] as String?,
  senderId: json['sender_id'] as String?,
  type: json['type'] as String?,
  status: json['status'] as String?,
  senderName: json['sender_name'] as String?,
  timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
  medias: (json['medias'] as List<dynamic>?)?.map((e) => e as String).toList(),
  readBy: (json['read_by'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isRead: json['is_read'] as bool?,
);

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_id': instance.chatId,
      'content': instance.content,
      'sender_id': instance.senderId,
      'type': instance.type,
      'status': instance.status,
      'sender_name': instance.senderName,
      'timestamp': instance.timestamp?.toIso8601String(),
      'medias': instance.medias,
      'read_by': instance.readBy,
      'is_read': instance.isRead,
    };
