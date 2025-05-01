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
  String? get url;
  String? get authorsByline;
  String? get articleId;
  String? get clusterId;
  NewsSourceModel? get source;
  String? get imageUrl;
  String? get country;
  String? get language;
  String? get pubDate;
  String? get addDate;
  String? get refreshDate;
  double? get score;
  String? get title;
  String? get description;
  String? get content;
  String? get medium;
  List<String?>? get links;
  List<Map<String, dynamic>>? get labels;
  String? get claim;
  String? get verdict;
  List<Map<String, dynamic>>? get keywords;
  List<Map<String, dynamic>>? get topics;
  List<Map<String, dynamic>>? get categories;
  List<Map<String, dynamic>>? get taxonomies;
  List<Map<String, dynamic>>? get entities;
  List<Map<String, dynamic>>? get companies;
  Map<String, dynamic>? get sentiment;
  String? get summary;
  String? get shortSummary;

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
            (identical(other.url, url) || other.url == url) &&
            (identical(other.authorsByline, authorsByline) ||
                other.authorsByline == authorsByline) &&
            (identical(other.articleId, articleId) ||
                other.articleId == articleId) &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.pubDate, pubDate) || other.pubDate == pubDate) &&
            (identical(other.addDate, addDate) || other.addDate == addDate) &&
            (identical(other.refreshDate, refreshDate) ||
                other.refreshDate == refreshDate) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            const DeepCollectionEquality().equals(other.links, links) &&
            const DeepCollectionEquality().equals(other.labels, labels) &&
            (identical(other.claim, claim) || other.claim == claim) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            const DeepCollectionEquality().equals(other.keywords, keywords) &&
            const DeepCollectionEquality().equals(other.topics, topics) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality()
                .equals(other.taxonomies, taxonomies) &&
            const DeepCollectionEquality().equals(other.entities, entities) &&
            const DeepCollectionEquality().equals(other.companies, companies) &&
            const DeepCollectionEquality().equals(other.sentiment, sentiment) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.shortSummary, shortSummary) ||
                other.shortSummary == shortSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        url,
        authorsByline,
        articleId,
        clusterId,
        source,
        imageUrl,
        country,
        language,
        pubDate,
        addDate,
        refreshDate,
        score,
        title,
        description,
        content,
        medium,
        const DeepCollectionEquality().hash(links),
        const DeepCollectionEquality().hash(labels),
        claim,
        verdict,
        const DeepCollectionEquality().hash(keywords),
        const DeepCollectionEquality().hash(topics),
        const DeepCollectionEquality().hash(categories),
        const DeepCollectionEquality().hash(taxonomies),
        const DeepCollectionEquality().hash(entities),
        const DeepCollectionEquality().hash(companies),
        const DeepCollectionEquality().hash(sentiment),
        summary,
        shortSummary
      ]);

  @override
  String toString() {
    return 'NewsModel(url: $url, authorsByline: $authorsByline, articleId: $articleId, clusterId: $clusterId, source: $source, imageUrl: $imageUrl, country: $country, language: $language, pubDate: $pubDate, addDate: $addDate, refreshDate: $refreshDate, score: $score, title: $title, description: $description, content: $content, medium: $medium, links: $links, labels: $labels, claim: $claim, verdict: $verdict, keywords: $keywords, topics: $topics, categories: $categories, taxonomies: $taxonomies, entities: $entities, companies: $companies, sentiment: $sentiment, summary: $summary, shortSummary: $shortSummary)';
  }
}

/// @nodoc
abstract mixin class $NewsModelCopyWith<$Res> {
  factory $NewsModelCopyWith(NewsModel value, $Res Function(NewsModel) _then) =
      _$NewsModelCopyWithImpl;
  @useResult
  $Res call(
      {String? url,
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
      String? shortSummary});

  $NewsSourceModelCopyWith<$Res>? get source;
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
    Object? url = freezed,
    Object? authorsByline = freezed,
    Object? articleId = freezed,
    Object? clusterId = freezed,
    Object? source = freezed,
    Object? imageUrl = freezed,
    Object? country = freezed,
    Object? language = freezed,
    Object? pubDate = freezed,
    Object? addDate = freezed,
    Object? refreshDate = freezed,
    Object? score = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? medium = freezed,
    Object? links = freezed,
    Object? labels = freezed,
    Object? claim = freezed,
    Object? verdict = freezed,
    Object? keywords = freezed,
    Object? topics = freezed,
    Object? categories = freezed,
    Object? taxonomies = freezed,
    Object? entities = freezed,
    Object? companies = freezed,
    Object? sentiment = freezed,
    Object? summary = freezed,
    Object? shortSummary = freezed,
  }) {
    return _then(_self.copyWith(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      authorsByline: freezed == authorsByline
          ? _self.authorsByline
          : authorsByline // ignore: cast_nullable_to_non_nullable
              as String?,
      articleId: freezed == articleId
          ? _self.articleId
          : articleId // ignore: cast_nullable_to_non_nullable
              as String?,
      clusterId: freezed == clusterId
          ? _self.clusterId
          : clusterId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as NewsSourceModel?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDate: freezed == pubDate
          ? _self.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as String?,
      addDate: freezed == addDate
          ? _self.addDate
          : addDate // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshDate: freezed == refreshDate
          ? _self.refreshDate
          : refreshDate // ignore: cast_nullable_to_non_nullable
              as String?,
      score: freezed == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _self.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      links: freezed == links
          ? _self.links
          : links // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      labels: freezed == labels
          ? _self.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      claim: freezed == claim
          ? _self.claim
          : claim // ignore: cast_nullable_to_non_nullable
              as String?,
      verdict: freezed == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _self.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      topics: freezed == topics
          ? _self.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      categories: freezed == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      taxonomies: freezed == taxonomies
          ? _self.taxonomies
          : taxonomies // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      entities: freezed == entities
          ? _self.entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      companies: freezed == companies
          ? _self.companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      sentiment: freezed == sentiment
          ? _self.sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      shortSummary: freezed == shortSummary
          ? _self.shortSummary
          : shortSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceModelCopyWith<$Res>? get source {
    if (_self.source == null) {
      return null;
    }

    return $NewsSourceModelCopyWith<$Res>(_self.source!, (value) {
      return _then(_self.copyWith(source: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NewsModel implements NewsModel {
  _NewsModel(
      {this.url,
      this.authorsByline,
      this.articleId,
      this.clusterId,
      this.source,
      this.imageUrl,
      this.country,
      this.language,
      this.pubDate,
      this.addDate,
      this.refreshDate,
      this.score,
      this.title,
      this.description,
      this.content,
      this.medium,
      final List<String?>? links,
      final List<Map<String, dynamic>>? labels,
      this.claim,
      this.verdict,
      final List<Map<String, dynamic>>? keywords,
      final List<Map<String, dynamic>>? topics,
      final List<Map<String, dynamic>>? categories,
      final List<Map<String, dynamic>>? taxonomies,
      final List<Map<String, dynamic>>? entities,
      final List<Map<String, dynamic>>? companies,
      final Map<String, dynamic>? sentiment,
      this.summary,
      this.shortSummary})
      : _links = links,
        _labels = labels,
        _keywords = keywords,
        _topics = topics,
        _categories = categories,
        _taxonomies = taxonomies,
        _entities = entities,
        _companies = companies,
        _sentiment = sentiment;
  factory _NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  @override
  final String? url;
  @override
  final String? authorsByline;
  @override
  final String? articleId;
  @override
  final String? clusterId;
  @override
  final NewsSourceModel? source;
  @override
  final String? imageUrl;
  @override
  final String? country;
  @override
  final String? language;
  @override
  final String? pubDate;
  @override
  final String? addDate;
  @override
  final String? refreshDate;
  @override
  final double? score;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? content;
  @override
  final String? medium;
  final List<String?>? _links;
  @override
  List<String?>? get links {
    final value = _links;
    if (value == null) return null;
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _labels;
  @override
  List<Map<String, dynamic>>? get labels {
    final value = _labels;
    if (value == null) return null;
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? claim;
  @override
  final String? verdict;
  final List<Map<String, dynamic>>? _keywords;
  @override
  List<Map<String, dynamic>>? get keywords {
    final value = _keywords;
    if (value == null) return null;
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _topics;
  @override
  List<Map<String, dynamic>>? get topics {
    final value = _topics;
    if (value == null) return null;
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _categories;
  @override
  List<Map<String, dynamic>>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _taxonomies;
  @override
  List<Map<String, dynamic>>? get taxonomies {
    final value = _taxonomies;
    if (value == null) return null;
    if (_taxonomies is EqualUnmodifiableListView) return _taxonomies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _entities;
  @override
  List<Map<String, dynamic>>? get entities {
    final value = _entities;
    if (value == null) return null;
    if (_entities is EqualUnmodifiableListView) return _entities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _companies;
  @override
  List<Map<String, dynamic>>? get companies {
    final value = _companies;
    if (value == null) return null;
    if (_companies is EqualUnmodifiableListView) return _companies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _sentiment;
  @override
  Map<String, dynamic>? get sentiment {
    final value = _sentiment;
    if (value == null) return null;
    if (_sentiment is EqualUnmodifiableMapView) return _sentiment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? summary;
  @override
  final String? shortSummary;

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
            (identical(other.url, url) || other.url == url) &&
            (identical(other.authorsByline, authorsByline) ||
                other.authorsByline == authorsByline) &&
            (identical(other.articleId, articleId) ||
                other.articleId == articleId) &&
            (identical(other.clusterId, clusterId) ||
                other.clusterId == clusterId) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.pubDate, pubDate) || other.pubDate == pubDate) &&
            (identical(other.addDate, addDate) || other.addDate == addDate) &&
            (identical(other.refreshDate, refreshDate) ||
                other.refreshDate == refreshDate) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            const DeepCollectionEquality().equals(other._links, _links) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.claim, claim) || other.claim == claim) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._taxonomies, _taxonomies) &&
            const DeepCollectionEquality().equals(other._entities, _entities) &&
            const DeepCollectionEquality()
                .equals(other._companies, _companies) &&
            const DeepCollectionEquality()
                .equals(other._sentiment, _sentiment) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.shortSummary, shortSummary) ||
                other.shortSummary == shortSummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        url,
        authorsByline,
        articleId,
        clusterId,
        source,
        imageUrl,
        country,
        language,
        pubDate,
        addDate,
        refreshDate,
        score,
        title,
        description,
        content,
        medium,
        const DeepCollectionEquality().hash(_links),
        const DeepCollectionEquality().hash(_labels),
        claim,
        verdict,
        const DeepCollectionEquality().hash(_keywords),
        const DeepCollectionEquality().hash(_topics),
        const DeepCollectionEquality().hash(_categories),
        const DeepCollectionEquality().hash(_taxonomies),
        const DeepCollectionEquality().hash(_entities),
        const DeepCollectionEquality().hash(_companies),
        const DeepCollectionEquality().hash(_sentiment),
        summary,
        shortSummary
      ]);

  @override
  String toString() {
    return 'NewsModel(url: $url, authorsByline: $authorsByline, articleId: $articleId, clusterId: $clusterId, source: $source, imageUrl: $imageUrl, country: $country, language: $language, pubDate: $pubDate, addDate: $addDate, refreshDate: $refreshDate, score: $score, title: $title, description: $description, content: $content, medium: $medium, links: $links, labels: $labels, claim: $claim, verdict: $verdict, keywords: $keywords, topics: $topics, categories: $categories, taxonomies: $taxonomies, entities: $entities, companies: $companies, sentiment: $sentiment, summary: $summary, shortSummary: $shortSummary)';
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
      {String? url,
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
      String? shortSummary});

  @override
  $NewsSourceModelCopyWith<$Res>? get source;
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
    Object? url = freezed,
    Object? authorsByline = freezed,
    Object? articleId = freezed,
    Object? clusterId = freezed,
    Object? source = freezed,
    Object? imageUrl = freezed,
    Object? country = freezed,
    Object? language = freezed,
    Object? pubDate = freezed,
    Object? addDate = freezed,
    Object? refreshDate = freezed,
    Object? score = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? content = freezed,
    Object? medium = freezed,
    Object? links = freezed,
    Object? labels = freezed,
    Object? claim = freezed,
    Object? verdict = freezed,
    Object? keywords = freezed,
    Object? topics = freezed,
    Object? categories = freezed,
    Object? taxonomies = freezed,
    Object? entities = freezed,
    Object? companies = freezed,
    Object? sentiment = freezed,
    Object? summary = freezed,
    Object? shortSummary = freezed,
  }) {
    return _then(_NewsModel(
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      authorsByline: freezed == authorsByline
          ? _self.authorsByline
          : authorsByline // ignore: cast_nullable_to_non_nullable
              as String?,
      articleId: freezed == articleId
          ? _self.articleId
          : articleId // ignore: cast_nullable_to_non_nullable
              as String?,
      clusterId: freezed == clusterId
          ? _self.clusterId
          : clusterId // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as NewsSourceModel?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _self.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      pubDate: freezed == pubDate
          ? _self.pubDate
          : pubDate // ignore: cast_nullable_to_non_nullable
              as String?,
      addDate: freezed == addDate
          ? _self.addDate
          : addDate // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshDate: freezed == refreshDate
          ? _self.refreshDate
          : refreshDate // ignore: cast_nullable_to_non_nullable
              as String?,
      score: freezed == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as double?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _self.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      links: freezed == links
          ? _self._links
          : links // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      labels: freezed == labels
          ? _self._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      claim: freezed == claim
          ? _self.claim
          : claim // ignore: cast_nullable_to_non_nullable
              as String?,
      verdict: freezed == verdict
          ? _self.verdict
          : verdict // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: freezed == keywords
          ? _self._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      topics: freezed == topics
          ? _self._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      categories: freezed == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      taxonomies: freezed == taxonomies
          ? _self._taxonomies
          : taxonomies // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      entities: freezed == entities
          ? _self._entities
          : entities // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      companies: freezed == companies
          ? _self._companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      sentiment: freezed == sentiment
          ? _self._sentiment
          : sentiment // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      summary: freezed == summary
          ? _self.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      shortSummary: freezed == shortSummary
          ? _self.shortSummary
          : shortSummary // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of NewsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceModelCopyWith<$Res>? get source {
    if (_self.source == null) {
      return null;
    }

    return $NewsSourceModelCopyWith<$Res>(_self.source!, (value) {
      return _then(_self.copyWith(source: value));
    });
  }
}

/// @nodoc
mixin _$NewsSourceModel {
  String? get domain;
  bool? get paywall;
  NewsSourceLocationModel? get location;

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsSourceModelCopyWith<NewsSourceModel> get copyWith =>
      _$NewsSourceModelCopyWithImpl<NewsSourceModel>(
          this as NewsSourceModel, _$identity);

  /// Serializes this NewsSourceModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsSourceModel &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.paywall, paywall) || other.paywall == paywall) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, domain, paywall, location);

  @override
  String toString() {
    return 'NewsSourceModel(domain: $domain, paywall: $paywall, location: $location)';
  }
}

/// @nodoc
abstract mixin class $NewsSourceModelCopyWith<$Res> {
  factory $NewsSourceModelCopyWith(
          NewsSourceModel value, $Res Function(NewsSourceModel) _then) =
      _$NewsSourceModelCopyWithImpl;
  @useResult
  $Res call({String? domain, bool? paywall, NewsSourceLocationModel? location});

  $NewsSourceLocationModelCopyWith<$Res>? get location;
}

/// @nodoc
class _$NewsSourceModelCopyWithImpl<$Res>
    implements $NewsSourceModelCopyWith<$Res> {
  _$NewsSourceModelCopyWithImpl(this._self, this._then);

  final NewsSourceModel _self;
  final $Res Function(NewsSourceModel) _then;

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? domain = freezed,
    Object? paywall = freezed,
    Object? location = freezed,
  }) {
    return _then(_self.copyWith(
      domain: freezed == domain
          ? _self.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      paywall: freezed == paywall
          ? _self.paywall
          : paywall // ignore: cast_nullable_to_non_nullable
              as bool?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as NewsSourceLocationModel?,
    ));
  }

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceLocationModelCopyWith<$Res>? get location {
    if (_self.location == null) {
      return null;
    }

    return $NewsSourceLocationModelCopyWith<$Res>(_self.location!, (value) {
      return _then(_self.copyWith(location: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NewsSourceModel implements NewsSourceModel {
  _NewsSourceModel({this.domain, this.paywall, this.location});
  factory _NewsSourceModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceModelFromJson(json);

  @override
  final String? domain;
  @override
  final bool? paywall;
  @override
  final NewsSourceLocationModel? location;

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NewsSourceModelCopyWith<_NewsSourceModel> get copyWith =>
      __$NewsSourceModelCopyWithImpl<_NewsSourceModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NewsSourceModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NewsSourceModel &&
            (identical(other.domain, domain) || other.domain == domain) &&
            (identical(other.paywall, paywall) || other.paywall == paywall) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, domain, paywall, location);

  @override
  String toString() {
    return 'NewsSourceModel(domain: $domain, paywall: $paywall, location: $location)';
  }
}

/// @nodoc
abstract mixin class _$NewsSourceModelCopyWith<$Res>
    implements $NewsSourceModelCopyWith<$Res> {
  factory _$NewsSourceModelCopyWith(
          _NewsSourceModel value, $Res Function(_NewsSourceModel) _then) =
      __$NewsSourceModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? domain, bool? paywall, NewsSourceLocationModel? location});

  @override
  $NewsSourceLocationModelCopyWith<$Res>? get location;
}

/// @nodoc
class __$NewsSourceModelCopyWithImpl<$Res>
    implements _$NewsSourceModelCopyWith<$Res> {
  __$NewsSourceModelCopyWithImpl(this._self, this._then);

  final _NewsSourceModel _self;
  final $Res Function(_NewsSourceModel) _then;

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? domain = freezed,
    Object? paywall = freezed,
    Object? location = freezed,
  }) {
    return _then(_NewsSourceModel(
      domain: freezed == domain
          ? _self.domain
          : domain // ignore: cast_nullable_to_non_nullable
              as String?,
      paywall: freezed == paywall
          ? _self.paywall
          : paywall // ignore: cast_nullable_to_non_nullable
              as bool?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as NewsSourceLocationModel?,
    ));
  }

  /// Create a copy of NewsSourceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceLocationModelCopyWith<$Res>? get location {
    if (_self.location == null) {
      return null;
    }

    return $NewsSourceLocationModelCopyWith<$Res>(_self.location!, (value) {
      return _then(_self.copyWith(location: value));
    });
  }
}

/// @nodoc
mixin _$NewsSourceLocationModel {
  String? get country;
  String? get city;
  NewsSourceCoordModel? get coordinates;

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsSourceLocationModelCopyWith<NewsSourceLocationModel> get copyWith =>
      _$NewsSourceLocationModelCopyWithImpl<NewsSourceLocationModel>(
          this as NewsSourceLocationModel, _$identity);

  /// Serializes this NewsSourceLocationModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsSourceLocationModel &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, country, city, coordinates);

  @override
  String toString() {
    return 'NewsSourceLocationModel(country: $country, city: $city, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class $NewsSourceLocationModelCopyWith<$Res> {
  factory $NewsSourceLocationModelCopyWith(NewsSourceLocationModel value,
          $Res Function(NewsSourceLocationModel) _then) =
      _$NewsSourceLocationModelCopyWithImpl;
  @useResult
  $Res call({String? country, String? city, NewsSourceCoordModel? coordinates});

  $NewsSourceCoordModelCopyWith<$Res>? get coordinates;
}

/// @nodoc
class _$NewsSourceLocationModelCopyWithImpl<$Res>
    implements $NewsSourceLocationModelCopyWith<$Res> {
  _$NewsSourceLocationModelCopyWithImpl(this._self, this._then);

  final NewsSourceLocationModel _self;
  final $Res Function(NewsSourceLocationModel) _then;

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? country = freezed,
    Object? city = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_self.copyWith(
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as NewsSourceCoordModel?,
    ));
  }

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceCoordModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
      return null;
    }

    return $NewsSourceCoordModelCopyWith<$Res>(_self.coordinates!, (value) {
      return _then(_self.copyWith(coordinates: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _NewsSourceLocationModel implements NewsSourceLocationModel {
  _NewsSourceLocationModel({this.country, this.city, this.coordinates});
  factory _NewsSourceLocationModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceLocationModelFromJson(json);

  @override
  final String? country;
  @override
  final String? city;
  @override
  final NewsSourceCoordModel? coordinates;

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NewsSourceLocationModelCopyWith<_NewsSourceLocationModel> get copyWith =>
      __$NewsSourceLocationModelCopyWithImpl<_NewsSourceLocationModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NewsSourceLocationModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NewsSourceLocationModel &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, country, city, coordinates);

  @override
  String toString() {
    return 'NewsSourceLocationModel(country: $country, city: $city, coordinates: $coordinates)';
  }
}

/// @nodoc
abstract mixin class _$NewsSourceLocationModelCopyWith<$Res>
    implements $NewsSourceLocationModelCopyWith<$Res> {
  factory _$NewsSourceLocationModelCopyWith(_NewsSourceLocationModel value,
          $Res Function(_NewsSourceLocationModel) _then) =
      __$NewsSourceLocationModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? country, String? city, NewsSourceCoordModel? coordinates});

  @override
  $NewsSourceCoordModelCopyWith<$Res>? get coordinates;
}

/// @nodoc
class __$NewsSourceLocationModelCopyWithImpl<$Res>
    implements _$NewsSourceLocationModelCopyWith<$Res> {
  __$NewsSourceLocationModelCopyWithImpl(this._self, this._then);

  final _NewsSourceLocationModel _self;
  final $Res Function(_NewsSourceLocationModel) _then;

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? country = freezed,
    Object? city = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_NewsSourceLocationModel(
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _self.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _self.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as NewsSourceCoordModel?,
    ));
  }

  /// Create a copy of NewsSourceLocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NewsSourceCoordModelCopyWith<$Res>? get coordinates {
    if (_self.coordinates == null) {
      return null;
    }

    return $NewsSourceCoordModelCopyWith<$Res>(_self.coordinates!, (value) {
      return _then(_self.copyWith(coordinates: value));
    });
  }
}

/// @nodoc
mixin _$NewsSourceCoordModel {
  double? get lat;
  double? get lon;

  /// Create a copy of NewsSourceCoordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NewsSourceCoordModelCopyWith<NewsSourceCoordModel> get copyWith =>
      _$NewsSourceCoordModelCopyWithImpl<NewsSourceCoordModel>(
          this as NewsSourceCoordModel, _$identity);

  /// Serializes this NewsSourceCoordModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NewsSourceCoordModel &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon);

  @override
  String toString() {
    return 'NewsSourceCoordModel(lat: $lat, lon: $lon)';
  }
}

/// @nodoc
abstract mixin class $NewsSourceCoordModelCopyWith<$Res> {
  factory $NewsSourceCoordModelCopyWith(NewsSourceCoordModel value,
          $Res Function(NewsSourceCoordModel) _then) =
      _$NewsSourceCoordModelCopyWithImpl;
  @useResult
  $Res call({double? lat, double? lon});
}

/// @nodoc
class _$NewsSourceCoordModelCopyWithImpl<$Res>
    implements $NewsSourceCoordModelCopyWith<$Res> {
  _$NewsSourceCoordModelCopyWithImpl(this._self, this._then);

  final NewsSourceCoordModel _self;
  final $Res Function(NewsSourceCoordModel) _then;

  /// Create a copy of NewsSourceCoordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_self.copyWith(
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _NewsSourceCoordModel implements NewsSourceCoordModel {
  _NewsSourceCoordModel({this.lat, this.lon});
  factory _NewsSourceCoordModel.fromJson(Map<String, dynamic> json) =>
      _$NewsSourceCoordModelFromJson(json);

  @override
  final double? lat;
  @override
  final double? lon;

  /// Create a copy of NewsSourceCoordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NewsSourceCoordModelCopyWith<_NewsSourceCoordModel> get copyWith =>
      __$NewsSourceCoordModelCopyWithImpl<_NewsSourceCoordModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NewsSourceCoordModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NewsSourceCoordModel &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lat, lon);

  @override
  String toString() {
    return 'NewsSourceCoordModel(lat: $lat, lon: $lon)';
  }
}

/// @nodoc
abstract mixin class _$NewsSourceCoordModelCopyWith<$Res>
    implements $NewsSourceCoordModelCopyWith<$Res> {
  factory _$NewsSourceCoordModelCopyWith(_NewsSourceCoordModel value,
          $Res Function(_NewsSourceCoordModel) _then) =
      __$NewsSourceCoordModelCopyWithImpl;
  @override
  @useResult
  $Res call({double? lat, double? lon});
}

/// @nodoc
class __$NewsSourceCoordModelCopyWithImpl<$Res>
    implements _$NewsSourceCoordModelCopyWith<$Res> {
  __$NewsSourceCoordModelCopyWithImpl(this._self, this._then);

  final _NewsSourceCoordModel _self;
  final $Res Function(_NewsSourceCoordModel) _then;

  /// Create a copy of NewsSourceCoordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_NewsSourceCoordModel(
      lat: freezed == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _self.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

// dart format on
