// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  id: json['id'] as String?,
  userId: json['user_id'] as String?,
  type: json['type'] as String?,
  userIds:
      (json['user_ids'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
  status: json['status'] as String?,
  archivedBy:
      (json['archived_by'] as List<dynamic>?)?.map((e) => e as String).toList(),
  deletedBy:
      (json['deleted_by'] as List<dynamic>?)?.map((e) => e as String).toList(),
  content: json['content'] as String?,
  statusSender: json['status_sender'] as String?,
  statusReceiver: json['status_receiver'] as String?,
  isGroup: json['is_group'] as bool?,
  lastMessage: json['last_message'] as String?,
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'type': instance.type,
      'user_ids': instance.userIds,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'status': instance.status,
      'archived_by': instance.archivedBy,
      'deleted_by': instance.deletedBy,
      'content': instance.content,
      'status_sender': instance.statusSender,
      'status_receiver': instance.statusReceiver,
      'is_group': instance.isGroup,
      'last_message': instance.lastMessage,
    };
