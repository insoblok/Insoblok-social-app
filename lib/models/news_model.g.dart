// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => _NewsModel(
  article_id: json['article_id'] as String?,
  title: json['title'] as String?,
  link: json['link'] as String?,
  keywords:
      (json['keywords'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  creator:
      (json['creator'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  description: json['description'] as String?,
  content: json['content'] as String?,
  pubDate: json['pubDate'] as String?,
  pubDateTz: json['pubDateTz'] as String?,
  image_url: json['image_url'] as String?,
  video_url: json['video_url'] as String?,
  source_id: json['source_id'] as String?,
  source_name: json['source_name'] as String?,
  source_priority: (json['source_priority'] as num?)?.toInt(),
  source_url: json['source_url'] as String?,
  source_icon: json['source_icon'] as String?,
  language: json['language'] as String?,
  country:
      (json['country'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  category:
      (json['category'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  sentiment: json['sentiment'] as String?,
  sentiment_stats: json['sentiment_stats'] as String?,
  ai_tag: json['ai_tag'] as String?,
  ai_region: json['ai_region'] as String?,
  ai_org: json['ai_org'] as String?,
  timestamp:
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
  updateDate:
      json['updateDate'] == null
          ? null
          : DateTime.parse(json['updateDate'] as String),
  duplicate: json['duplicate'] as bool?,
);

Map<String, dynamic> _$NewsModelToJson(_NewsModel instance) =>
    <String, dynamic>{
      'article_id': instance.article_id,
      'title': instance.title,
      'link': instance.link,
      'keywords': instance.keywords,
      'creator': instance.creator,
      'description': instance.description,
      'content': instance.content,
      'pubDate': instance.pubDate,
      'pubDateTz': instance.pubDateTz,
      'image_url': instance.image_url,
      'video_url': instance.video_url,
      'source_id': instance.source_id,
      'source_name': instance.source_name,
      'source_priority': instance.source_priority,
      'source_url': instance.source_url,
      'source_icon': instance.source_icon,
      'language': instance.language,
      'country': instance.country,
      'category': instance.category,
      'sentiment': instance.sentiment,
      'sentiment_stats': instance.sentiment_stats,
      'ai_tag': instance.ai_tag,
      'ai_region': instance.ai_region,
      'ai_org': instance.ai_org,
      'timestamp': instance.timestamp?.toIso8601String(),
      'updateDate': instance.updateDate?.toIso8601String(),
      'duplicate': instance.duplicate,
    };
