// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsModel {
  String? get article_id;
  String? get title;
  String? get link;
  List<String?>? get keywords;
  List<String?>? get creator;
  String? get description;
  String? get content;
  String? get pubDate;
  String? get pubDateTz;
  String? get image_url;
  String? get video_url;
  String? get source_id;
  String? get source_name;
  int? get source_priority;
  String? get source_url;
  String? get source_icon;
  String? get language;
  List<String?>? get country;
  List<String?>? get category;
  String? get sentiment;
  String? get sentiment_stats;
  String? get ai_tag;
  String? get ai_region;
  String? get ai_org;
  DateTime? get timestamp;
  DateTime? get updateDate;
  bool? get duplicate;

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsModelCopyWith<NewsModel> get copyWith =>
      _$NewsModelCopyWithImpl<NewsModel>(this as NewsModel, _$identity);

  /// Serializes this NewsModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsModel &&
            (identical(other.article_id, article_id) ||
                other.article_id == article_id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.link, link) || other.link == link) &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality().equals(other.creator, creator) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.pubDate, pubDate) || other.pubDate == pubDate) &&
            (identical(other.pubDateTz, pubDateTz) ||
                other.pubDateTz == pubDateTz) &&
            (identical(other.image_url, image_url) ||
                other.image_url == image_url) &&
            (identical(other.video_url, video_url) ||
                other.video_url == video_url) &&
            (identical(other.source_id, source_id) ||
                other.source_id == source_id) &&
            (identical(other.source_name, source_name) ||
                other.source_name == source_name) &&
            (identical(other.source_priority, source_priority) ||
                other.source_priority == source_priority) &&
            (identical(other.source_url, source_url) ||
                other.source_url == source_url) &&
            (identical(other.source_icon, source_icon) ||
                other.source_icon == source_icon) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other.country, country) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            (identical(other.sentiment, sentiment) ||
                other.sentiment == sentiment) &&
            (identical(other.sentiment_stats, sentiment_stats) ||
                other.sentiment_stats == sentiment_stats) &&
            (identical(other.ai_tag, ai_tag) || other.ai_tag == ai_tag) &&
            (identical(other.ai_region, ai_region) ||
                other.ai_region == ai_region) &&
            (identical(other.ai_org, ai_org) || other.ai_org == ai_org) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.duplicate, duplicate) ||
                other.duplicate == duplicate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        article_id,
        title,
        link,
        const DeepCollectionEquality().hash(keywords),
        const DeepCollectionEquality().hash(creator),
        description,
        content,
        pubDate,
        pubDateTz,
        image_url,
        video_url,
        source_id,
        source_name,
        source_priority,
        source_url,
        source_icon,
        language,
        const DeepCollectionEquality().hash(country),
        const DeepCollectionEquality().hash(category),
        sentiment,
        sentiment_stats,
        ai_tag,
        ai_region,
        ai_org,
        timestamp,
        updateDate,
        duplicate
      ]);

  @override
  String toString() {
    return 'NewsModel(article_id: $article_id, title: $title, link: $link, keywords: $keywords, creator: $creator, description: $description, content: $content, pubDate: $pubDate, pubDateTz: $pubDateTz, image_url: $image_url, video_url: $video_url, source_id: $source_id, source_name: $source_name, source_priority: $source_priority, source_url: $source_url, source_icon: $source_icon, language: $language, country: $country, category: $category, sentiment: $sentiment, sentiment_stats: $sentiment_stats, ai_tag: $ai_tag, ai_region: $ai_region, ai_org: $ai_org, timestamp: $timestamp, updateDate: $updateDate, duplicate: $duplicate)';
  }
}

/// @nodoc
abstract mixin class $NewsModelCopyWith<$Res> {
  factory $NewsModelCopyWith(NewsModel value, $Res Function(NewsModel) _then) =
      _$NewsModelCopyWithImpl;
  @useResult
  $Res call(
      {String? article_id,
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
      bool? duplicate});
}

/// @nodoc
class _$NewsModelCopyWithImpl<$Res> implements $NewsModelCopyWith<$Res> {
  _$NewsModelCopyWithImpl(this._self, this._then);

  final NewsModel _self;
  final $Res Function(NewsModel) _then;

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? article_id = freezed,
    Object? title = freezed,
    Object? link = freezed,
    Object? keywords = freezed,
    Object? creator = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? pubDate = freezed,
    Object? pubDateTz = freezed,
    Object? image_url = freezed,
    Object? video_url = freezed,
    Object? source_id = freezed,
    Object? source_name = freezed,
    Object? source_priority = freezed,
    Object? source_url = freezed,
    Object? source_icon = freezed,
    Object? language = freezed,
    Object? country = freezed,
    Object? category = freezed,
    Object? sentiment = freezed,
    Object? sentiment_stats = freezed,
    Object? ai_tag = freezed,
    Object? ai_region = freezed,
    Object? ai_org = freezed,
    Object? timestamp = freezed,
    Object? updateDate = freezed,
    Object? duplicate = freezed,
  }) {
    return _then(_self.copyWith(
      article_id: freezed == article_id
          ? _self.article_id
          : article_id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _self.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      creator: freezed == creator
          ? _self.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDate: freezed == pubDate
          ? _self.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDateTz: freezed == pubDateTz
          ? _self.pubDateTz
          : pubDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      image_url: freezed == image_url
          ? _self.image_url
          : image_url // ignore: cast_nullable_to_non_nullable
              as String?,
      video_url: freezed == video_url
          ? _self.video_url
          : video_url // ignore: cast_nullable_to_non_nullable
              as String?,
      source_id: freezed == source_id
          ? _self.source_id
          : source_id // ignore: cast_nullable_to_non_nullable
              as String?,
      source_name: freezed == source_name
          ? _self.source_name
          : source_name // ignore: cast_nullable_to_non_nullable
              as String?,
      source_priority: freezed == source_priority
          ? _self.source_priority
          : source_priority // ignore: cast_nullable_to_non_nullable
              as int?,
      source_url: freezed == source_url
          ? _self.source_url
          : source_url // ignore: cast_nullable_to_non_nullable
              as String?,
      source_icon: freezed == source_icon
          ? _self.source_icon
          : source_icon // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      sentiment: freezed == sentiment
          ? _self.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as String?,
      sentiment_stats: freezed == sentiment_stats
          ? _self.sentiment_stats
          : sentiment_stats // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_tag: freezed == ai_tag
          ? _self.ai_tag
          : ai_tag // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_region: freezed == ai_region
          ? _self.ai_region
          : ai_region // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_org: freezed == ai_org
          ? _self.ai_org
          : ai_org // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duplicate: freezed == duplicate
          ? _self.duplicate
          : duplicate // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NewsModel implements NewsModel {
  _NewsModel(
      {this.article_id,
      this.title,
      this.link,
      final List<String?>? keywords,
      final List<String?>? creator,
      this.description,
      this.content,
      this.pubDate,
      this.pubDateTz,
      this.image_url,
      this.video_url,
      this.source_id,
      this.source_name,
      this.source_priority,
      this.source_url,
      this.source_icon,
      this.language,
      final List<String?>? country,
      final List<String?>? category,
      this.sentiment,
      this.sentiment_stats,
      this.ai_tag,
      this.ai_region,
      this.ai_org,
      this.timestamp,
      this.updateDate,
      this.duplicate})
      : _keywords = keywords,
        _creator = creator,
        _country = country,
        _category = category;
  factory _NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  @override
  final String? article_id;
  @override
  final String? title;
  @override
  final String? link;
  final List<String?>? _keywords;
  @override
  List<String?>? get keywords {
    final value = _keywords;
    if (value == null) return null;
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String?>? _creator;
  @override
  List<String?>? get creator {
    final value = _creator;
    if (value == null) return null;
    if (_creator is EqualUnmodifiableListView) return _creator;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  @override
  final String? content;
  @override
  final String? pubDate;
  @override
  final String? pubDateTz;
  @override
  final String? image_url;
  @override
  final String? video_url;
  @override
  final String? source_id;
  @override
  final String? source_name;
  @override
  final int? source_priority;
  @override
  final String? source_url;
  @override
  final String? source_icon;
  @override
  final String? language;
  final List<String?>? _country;
  @override
  List<String?>? get country {
    final value = _country;
    if (value == null) return null;
    if (_country is EqualUnmodifiableListView) return _country;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String?>? _category;
  @override
  List<String?>? get category {
    final value = _category;
    if (value == null) return null;
    if (_category is EqualUnmodifiableListView) return _category;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? sentiment;
  @override
  final String? sentiment_stats;
  @override
  final String? ai_tag;
  @override
  final String? ai_region;
  @override
  final String? ai_org;
  @override
  final DateTime? timestamp;
  @override
  final DateTime? updateDate;
  @override
  final bool? duplicate;

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NewsModelCopyWith<_NewsModel> get copyWith =>
      __$NewsModelCopyWithImpl<_NewsModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NewsModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NewsModel &&
            (identical(other.article_id, article_id) ||
                other.article_id == article_id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.link, link) || other.link == link) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(other._creator, _creator) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.pubDate, pubDate) || other.pubDate == pubDate) &&
            (identical(other.pubDateTz, pubDateTz) ||
                other.pubDateTz == pubDateTz) &&
            (identical(other.image_url, image_url) ||
                other.image_url == image_url) &&
            (identical(other.video_url, video_url) ||
                other.video_url == video_url) &&
            (identical(other.source_id, source_id) ||
                other.source_id == source_id) &&
            (identical(other.source_name, source_name) ||
                other.source_name == source_name) &&
            (identical(other.source_priority, source_priority) ||
                other.source_priority == source_priority) &&
            (identical(other.source_url, source_url) ||
                other.source_url == source_url) &&
            (identical(other.source_icon, source_icon) ||
                other.source_icon == source_icon) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other._country, _country) &&
            const DeepCollectionEquality().equals(other._category, _category) &&
            (identical(other.sentiment, sentiment) ||
                other.sentiment == sentiment) &&
            (identical(other.sentiment_stats, sentiment_stats) ||
                other.sentiment_stats == sentiment_stats) &&
            (identical(other.ai_tag, ai_tag) || other.ai_tag == ai_tag) &&
            (identical(other.ai_region, ai_region) ||
                other.ai_region == ai_region) &&
            (identical(other.ai_org, ai_org) || other.ai_org == ai_org) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.duplicate, duplicate) ||
                other.duplicate == duplicate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        article_id,
        title,
        link,
        const DeepCollectionEquality().hash(_keywords),
        const DeepCollectionEquality().hash(_creator),
        description,
        content,
        pubDate,
        pubDateTz,
        image_url,
        video_url,
        source_id,
        source_name,
        source_priority,
        source_url,
        source_icon,
        language,
        const DeepCollectionEquality().hash(_country),
        const DeepCollectionEquality().hash(_category),
        sentiment,
        sentiment_stats,
        ai_tag,
        ai_region,
        ai_org,
        timestamp,
        updateDate,
        duplicate
      ]);

  @override
  String toString() {
    return 'NewsModel(article_id: $article_id, title: $title, link: $link, keywords: $keywords, creator: $creator, description: $description, content: $content, pubDate: $pubDate, pubDateTz: $pubDateTz, image_url: $image_url, video_url: $video_url, source_id: $source_id, source_name: $source_name, source_priority: $source_priority, source_url: $source_url, source_icon: $source_icon, language: $language, country: $country, category: $category, sentiment: $sentiment, sentiment_stats: $sentiment_stats, ai_tag: $ai_tag, ai_region: $ai_region, ai_org: $ai_org, timestamp: $timestamp, updateDate: $updateDate, duplicate: $duplicate)';
  }
}

/// @nodoc
abstract mixin class _$NewsModelCopyWith<$Res>
    implements $NewsModelCopyWith<$Res> {
  factory _$NewsModelCopyWith(
          _NewsModel value, $Res Function(_NewsModel) _then) =
      __$NewsModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? article_id,
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
      bool? duplicate});
}

/// @nodoc
class __$NewsModelCopyWithImpl<$Res> implements _$NewsModelCopyWith<$Res> {
  __$NewsModelCopyWithImpl(this._self, this._then);

  final _NewsModel _self;
  final $Res Function(_NewsModel) _then;

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? article_id = freezed,
    Object? title = freezed,
    Object? link = freezed,
    Object? keywords = freezed,
    Object? creator = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? pubDate = freezed,
    Object? pubDateTz = freezed,
    Object? image_url = freezed,
    Object? video_url = freezed,
    Object? source_id = freezed,
    Object? source_name = freezed,
    Object? source_priority = freezed,
    Object? source_url = freezed,
    Object? source_icon = freezed,
    Object? language = freezed,
    Object? country = freezed,
    Object? category = freezed,
    Object? sentiment = freezed,
    Object? sentiment_stats = freezed,
    Object? ai_tag = freezed,
    Object? ai_region = freezed,
    Object? ai_org = freezed,
    Object? timestamp = freezed,
    Object? updateDate = freezed,
    Object? duplicate = freezed,
  }) {
    return _then(_NewsModel(
      article_id: freezed == article_id
          ? _self.article_id
          : article_id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _self._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      creator: freezed == creator
          ? _self._creator
          : creator // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDate: freezed == pubDate
          ? _self.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDateTz: freezed == pubDateTz
          ? _self.pubDateTz
          : pubDateTz // ignore: cast_nullable_to_non_nullable
              as String?,
      image_url: freezed == image_url
          ? _self.image_url
          : image_url // ignore: cast_nullable_to_non_nullable
              as String?,
      video_url: freezed == video_url
          ? _self.video_url
          : video_url // ignore: cast_nullable_to_non_nullable
              as String?,
      source_id: freezed == source_id
          ? _self.source_id
          : source_id // ignore: cast_nullable_to_non_nullable
              as String?,
      source_name: freezed == source_name
          ? _self.source_name
          : source_name // ignore: cast_nullable_to_non_nullable
              as String?,
      source_priority: freezed == source_priority
          ? _self.source_priority
          : source_priority // ignore: cast_nullable_to_non_nullable
              as int?,
      source_url: freezed == source_url
          ? _self.source_url
          : source_url // ignore: cast_nullable_to_non_nullable
              as String?,
      source_icon: freezed == source_icon
          ? _self.source_icon
          : source_icon // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self._country
          : country // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      category: freezed == category
          ? _self._category
          : category // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      sentiment: freezed == sentiment
          ? _self.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as String?,
      sentiment_stats: freezed == sentiment_stats
          ? _self.sentiment_stats
          : sentiment_stats // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_tag: freezed == ai_tag
          ? _self.ai_tag
          : ai_tag // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_region: freezed == ai_region
          ? _self.ai_region
          : ai_region // ignore: cast_nullable_to_non_nullable
              as String?,
      ai_org: freezed == ai_org
          ? _self.ai_org
          : ai_org // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duplicate: freezed == duplicate
          ? _self.duplicate
          : duplicate // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
