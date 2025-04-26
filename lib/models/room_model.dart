import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

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

extension RoomModelExt on RoomModel {
  String? get recentDate {
    try {
      if (updateDate != null) {
        var date = kFullDateTimeFormatter.parse(updateDate!);
        return kDateMDYFormatter.format(date);
      }
    } catch (e) {
      logger.e(e);
    }
    return null;
  }
}
