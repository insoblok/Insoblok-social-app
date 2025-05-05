import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_model.freezed.dart';
part 'news_model.g.dart';

@freezed
abstract class NewsModel with _$NewsModel {
  factory NewsModel({
    String? id,
    String? url,
    String? authorsByline,
    String? articleId,
    String? clusterId,
    NewsSourceModel? source,
    String? imageUrl,
    String? country,
    String? language,
    String? pubDate,
    String? addDate,
    String? refreshDate,
    double? score,
    String? title,
    String? description,
    String? content,
    String? medium,
    List<String?>? links,
    List<Map<String, dynamic>>? labels,
    String? claim,
    String? verdict,
    List<Map<String, dynamic>>? keywords,
    List<Map<String, dynamic>>? topics,
    List<Map<String, dynamic>>? categories,
    List<Map<String, dynamic>>? taxonomies,
    List<Map<String, dynamic>>? entities,
    List<Map<String, dynamic>>? companies,
    Map<String, dynamic>? sentiment,
    String? summary,
    String? shortSummary,
  }) = _NewsModel;
  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
}

@freezed
abstract class NewsSourceModel with _$NewsSourceModel {
  factory NewsSourceModel({
    String? domain,
    bool? paywall,
    NewsSourceLocationModel? location,
  }) = _NewsSourceModel;
  factory NewsSourceModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceModelFromJson(json);
}

@freezed
abstract class NewsSourceLocationModel with _$NewsSourceLocationModel {
  factory NewsSourceLocationModel({
    String? country,
    String? city,
    NewsSourceCoordModel? coordinates,
  }) = _NewsSourceLocationModel;
  factory NewsSourceLocationModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceLocationModelFromJson(json);
}

@freezed
abstract class NewsSourceCoordModel with _$NewsSourceCoordModel {
  factory NewsSourceCoordModel({double? lat, double? lon}) =
      _NewsSourceCoordModel;
  factory NewsSourceCoordModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceCoordModelFromJson(json);
}
