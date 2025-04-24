import 'package:insoblok/models/models.dart';

extension StoryModelExt on StoryModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'text': text,
      'regdate': regdate,
      'status': status,
      'timestamp': timestamp,
      'likes': likes,
      'follows': follows,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
      'comments': (comments ?? []).map((e) => e.toJson()).toList(),
    };
  }
}
