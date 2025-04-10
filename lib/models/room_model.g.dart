// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
      id: json['id'] as String?,
      senderId: json['sender_id'] as String?,
      receiverId: json['receiver_id'] as String?,
      regDate: json['reg_date'] as String?,
      updateDate: json['update_date'] as String?,
      content: json['content'] as String?,
      statusSender: json['status_sender'] as String?,
      statusReceiver: json['status_receiver'] as String?,
    );

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      'receiver_id': instance.receiverId,
      'reg_date': instance.regDate,
      'update_date': instance.updateDate,
      'content': instance.content,
      'status_sender': instance.statusSender,
      'status_receiver': instance.statusReceiver,
    };
