import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/services/services.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsModel with _$NewsModel {
  factory NewsModel({
    String? article_id,
    String? title,
    String? link,
    List<String?>? keywords,
    List<String?>? creator,
    String? description,
    String? content,
    String? pubDate,
    String? pubDateTz,
    String? image_url,
    String? video_url,
    String? source_id,
    String? source_name,
    int? source_priority,
    String? source_url,
    String? source_icon,
    String? language,
    List<String?>? country,
    List<String?>? category,
    String? sentiment,
    String? sentiment_stats,
    String? ai_tag,
    String? ai_region,
    String? ai_org,
    DateTime? timestamp,
    DateTime? updateDate,
    bool? duplicate,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(FirebaseHelper.fromConvertJson(json));
}
