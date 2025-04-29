import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
abstract class RoomModel with _$RoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RoomModel({
    String? id,
    String? relatedId,
    String? senderId,
    String? receiverId,
    String? regDate,
    String? updateDate,
    String? content,
    String? statusSender,
    String? statusReceiver,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
