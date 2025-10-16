import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/enums/enums.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';


@freezed
abstract class RoomModel with _$RoomModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  factory RoomModel({
    String? id,
    String? userId,
    String? type,
    List<String?>? userIds,
    DateTime? updatedAt,
    DateTime? timestamp,
    String? status,
    List<String>? archivedBy,
    List<String>? deletedBy,     
    String? content,
    String? statusSender,
    String? statusReceiver,
    bool? isGroup,
    String? lastMessage,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(FirebaseHelper.fromConvertJson(json));
  
}
