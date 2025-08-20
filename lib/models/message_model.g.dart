// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageModel _$MessageModelFromJson(Map<String, dynamic> json) =>
    _MessageModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      senderId: json['sender_id'] as String?,
      senderName: json['sender_name'] as String?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
      url: json['url'] as String?,
      type: json['type'] as String?,
      isRead: json['is_read'] as bool?,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'timestamp': instance.timestamp?.toIso8601String(),
      'url': instance.url,
      'type': instance.type,
      'is_read': instance.isRead,
    };
