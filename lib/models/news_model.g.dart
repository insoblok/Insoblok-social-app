// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => _NewsModel(
      url: json['url'] as String?,
      authorsByline: json['authorsByline'] as String?,
      articleId: json['articleId'] as String?,
      clusterId: json['clusterId'] as String?,
      source: json['source'] == null
          ? null
          : NewsSourceModel.fromJson(json['source'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      country: json['country'] as String?,
      language: json['language'] as String?,
      pubDate: json['pubDate'] as String?,
      addDate: json['addDate'] as String?,
      refreshDate: json['refreshDate'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      content: json['content'] as String?,
      medium: json['medium'] as String?,
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String?).toList(),
      labels: (json['labels'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      claim: json['claim'] as String?,
      verdict: json['verdict'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      topics: (json['topics'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      taxonomies: (json['taxonomies'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      entities: (json['entities'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      companies: (json['companies'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      sentiment: json['sentiment'] as Map<String, dynamic>?,
      summary: json['summary'] as String?,
      shortSummary: json['shortSummary'] as String?,
    );

Map<String, dynamic> _$NewsModelToJson(_NewsModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'authorsByline': instance.authorsByline,
      'articleId': instance.articleId,
      'clusterId': instance.clusterId,
      'source': instance.source,
      'imageUrl': instance.imageUrl,
      'country': instance.country,
      'language': instance.language,
      'pubDate': instance.pubDate,
      'addDate': instance.addDate,
      'refreshDate': instance.refreshDate,
      'score': instance.score,
      'title': instance.title,
      'description': instance.description,
      'content': instance.content,
      'medium': instance.medium,
      'links': instance.links,
      'labels': instance.labels,
      'claim': instance.claim,
      'verdict': instance.verdict,
      'keywords': instance.keywords,
      'topics': instance.topics,
      'categories': instance.categories,
      'taxonomies': instance.taxonomies,
      'entities': instance.entities,
      'companies': instance.companies,
      'sentiment': instance.sentiment,
      'summary': instance.summary,
      'shortSummary': instance.shortSummary,
    };

_NewsSourceModel _$NewsSourceModelFromJson(Map<String, dynamic> json) =>
    _NewsSourceModel(
      domain: json['domain'] as String?,
      paywall: json['paywall'] as bool?,
      location: json['location'] == null
          ? null
          : NewsSourceLocationModel.fromJson(
              json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsSourceModelToJson(_NewsSourceModel instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'paywall': instance.paywall,
      'location': instance.location,
    };

_NewsSourceLocationModel _$NewsSourceLocationModelFromJson(
        Map<String, dynamic> json) =>
    _NewsSourceLocationModel(
      country: json['country'] as String?,
      city: json['city'] as String?,
      coordinates: json['coordinates'] == null
          ? null
          : NewsSourceCoordModel.fromJson(
              json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NewsSourceLocationModelToJson(
        _NewsSourceLocationModel instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'coordinates': instance.coordinates,
    };

_NewsSourceCoordModel _$NewsSourceCoordModelFromJson(
        Map<String, dynamic> json) =>
    _NewsSourceCoordModel(
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NewsSourceCoordModelToJson(
        _NewsSourceCoordModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
