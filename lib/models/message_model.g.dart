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
      timestamp: json['timestamp'] as String?,
      url: json['url'] as String?,
      isRead: json['is_read'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(_MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'timestamp': instance.timestamp,
      'url': instance.url,
      'is_read': instance.isRead,
    };
