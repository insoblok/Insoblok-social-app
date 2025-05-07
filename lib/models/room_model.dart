import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

@freezed
abstract class RoomModel with _$RoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RoomModel({
    String? id,
    String? uid,
    List<String?>? uids,
    DateTime? regdate,
    DateTime? timestamp,
    String? content,
    String? statusSender,
    String? statusReceiver,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(FirebaseHelper.fromConvertJson(json));
}
