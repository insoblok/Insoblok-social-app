import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
abstract class RoomModel with _$RoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RoomModel({
    String? id,
    String? uid,
    List<String?>? uids,
    String? regdate,
    String? timestamp,
    String? content,
    String? statusSender,
    String? statusReceiver,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
