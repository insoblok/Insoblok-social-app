// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoryModel {
  String? get id;
  String? get uid;
  String? get title;
  String? get text;
  String? get regdate;
  String? get status;
  String? get timestamp;
  List<MediaStoryModel>? get medias;
  List<String>? get likes;
  List<String>? get follows;
  List<StoryCommentModel>? get comments;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoryModelCopyWith<StoryModel> get copyWith =>
      _$StoryModelCopyWithImpl<StoryModel>(this as StoryModel, _$identity);

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other.medias, medias) &&
            const DeepCollectionEquality().equals(other.likes, likes) &&
            const DeepCollectionEquality().equals(other.follows, follows) &&
            const DeepCollectionEquality().equals(other.comments, comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      title,
      text,
      regdate,
      status,
      timestamp,
      const DeepCollectionEquality().hash(medias),
      const DeepCollectionEquality().hash(likes),
      const DeepCollectionEquality().hash(follows),
      const DeepCollectionEquality().hash(comments));

  @override
  String toString() {
    return 'StoryModel(id: $id, uid: $uid, title: $title, text: $text, regdate: $regdate, status: $status, timestamp: $timestamp, medias: $medias, likes: $likes, follows: $follows, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class $StoryModelCopyWith<$Res> {
  factory $StoryModelCopyWith(
          StoryModel value, $Res Function(StoryModel) _then) =
      _$StoryModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? title,
      String? text,
      String? regdate,
      String? status,
      String? timestamp,
      List<MediaStoryModel>? medias,
      List<String>? likes,
      List<String>? follows,
      List<StoryCommentModel>? comments});
}

/// @nodoc
class _$StoryModelCopyWithImpl<$Res> implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._self, this._then);

  final StoryModel _self;
  final $Res Function(StoryModel) _then;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? title = freezed,
    Object? text = freezed,
    Object? regdate = freezed,
    Object? status = freezed,
    Object? timestamp = freezed,
    Object? medias = freezed,
    Object? likes = freezed,
    Object? follows = freezed,
    Object? comments = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      medias: freezed == medias
          ? _self.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
      likes: freezed == likes
          ? _self.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      follows: freezed == follows
          ? _self.follows
          : follows // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      comments: freezed == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<StoryCommentModel>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoryModel implements StoryModel {
  _StoryModel(
      {this.id,
      this.uid,
      this.title,
      this.text,
      this.regdate,
      this.status,
      this.timestamp,
      final List<MediaStoryModel>? medias,
      final List<String>? likes,
      final List<String>? follows,
      final List<StoryCommentModel>? comments})
      : _medias = medias,
        _likes = likes,
        _follows = follows,
        _comments = comments;
  factory _StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  @override
  final String? id;
  @override
  final String? uid;
  @override
  final String? title;
  @override
  final String? text;
  @override
  final String? regdate;
  @override
  final String? status;
  @override
  final String? timestamp;
  final List<MediaStoryModel>? _medias;
  @override
  List<MediaStoryModel>? get medias {
    final value = _medias;
    if (value == null) return null;
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _likes;
  @override
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _follows;
  @override
  List<String>? get follows {
    final value = _follows;
    if (value == null) return null;
    if (_follows is EqualUnmodifiableListView) return _follows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<StoryCommentModel>? _comments;
  @override
  List<StoryCommentModel>? get comments {
    final value = _comments;
    if (value == null) return null;
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoryModelCopyWith<_StoryModel> get copyWith =>
      __$StoryModelCopyWithImpl<_StoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._follows, _follows) &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      title,
      text,
      regdate,
      status,
      timestamp,
      const DeepCollectionEquality().hash(_medias),
      const DeepCollectionEquality().hash(_likes),
      const DeepCollectionEquality().hash(_follows),
      const DeepCollectionEquality().hash(_comments));

  @override
  String toString() {
    return 'StoryModel(id: $id, uid: $uid, title: $title, text: $text, regdate: $regdate, status: $status, timestamp: $timestamp, medias: $medias, likes: $likes, follows: $follows, comments: $comments)';
  }
}

/// @nodoc
abstract mixin class _$StoryModelCopyWith<$Res>
    implements $StoryModelCopyWith<$Res> {
  factory _$StoryModelCopyWith(
          _StoryModel value, $Res Function(_StoryModel) _then) =
      __$StoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? title,
      String? text,
      String? regdate,
      String? status,
      String? timestamp,
      List<MediaStoryModel>? medias,
      List<String>? likes,
      List<String>? follows,
      List<StoryCommentModel>? comments});
}

/// @nodoc
class __$StoryModelCopyWithImpl<$Res> implements _$StoryModelCopyWith<$Res> {
  __$StoryModelCopyWithImpl(this._self, this._then);

  final _StoryModel _self;
  final $Res Function(_StoryModel) _then;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? title = freezed,
    Object? text = freezed,
    Object? regdate = freezed,
    Object? status = freezed,
    Object? timestamp = freezed,
    Object? medias = freezed,
    Object? likes = freezed,
    Object? follows = freezed,
    Object? comments = freezed,
  }) {
    return _then(_StoryModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      medias: freezed == medias
          ? _self._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
      likes: freezed == likes
          ? _self._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      follows: freezed == follows
          ? _self._follows
          : follows // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      comments: freezed == comments
          ? _self._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<StoryCommentModel>?,
    ));
  }
}

/// @nodoc
mixin _$MediaStoryModel {
  String? get link;
  String? get type;

  /// Create a copy of MediaStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaStoryModelCopyWith<MediaStoryModel> get copyWith =>
      _$MediaStoryModelCopyWithImpl<MediaStoryModel>(
          this as MediaStoryModel, _$identity);

  /// Serializes this MediaStoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaStoryModel &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, link, type);

  @override
  String toString() {
    return 'MediaStoryModel(link: $link, type: $type)';
  }
}

/// @nodoc
abstract mixin class $MediaStoryModelCopyWith<$Res> {
  factory $MediaStoryModelCopyWith(
          MediaStoryModel value, $Res Function(MediaStoryModel) _then) =
      _$MediaStoryModelCopyWithImpl;
  @useResult
  $Res call({String? link, String? type});
}

/// @nodoc
class _$MediaStoryModelCopyWithImpl<$Res>
    implements $MediaStoryModelCopyWith<$Res> {
  _$MediaStoryModelCopyWithImpl(this._self, this._then);

  final MediaStoryModel _self;
  final $Res Function(MediaStoryModel) _then;

  /// Create a copy of MediaStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? link = freezed,
    Object? type = freezed,
  }) {
    return _then(_self.copyWith(
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MediaStoryModel implements MediaStoryModel {
  _MediaStoryModel({this.link, this.type});
  factory _MediaStoryModel.fromJson(Map<String, dynamic> json) =>
      _$MediaStoryModelFromJson(json);

  @override
  final String? link;
  @override
  final String? type;

  /// Create a copy of MediaStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaStoryModelCopyWith<_MediaStoryModel> get copyWith =>
      __$MediaStoryModelCopyWithImpl<_MediaStoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaStoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaStoryModel &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, link, type);

  @override
  String toString() {
    return 'MediaStoryModel(link: $link, type: $type)';
  }
}

/// @nodoc
abstract mixin class _$MediaStoryModelCopyWith<$Res>
    implements $MediaStoryModelCopyWith<$Res> {
  factory _$MediaStoryModelCopyWith(
          _MediaStoryModel value, $Res Function(_MediaStoryModel) _then) =
      __$MediaStoryModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? link, String? type});
}

/// @nodoc
class __$MediaStoryModelCopyWithImpl<$Res>
    implements _$MediaStoryModelCopyWith<$Res> {
  __$MediaStoryModelCopyWithImpl(this._self, this._then);

  final _MediaStoryModel _self;
  final $Res Function(_MediaStoryModel) _then;

  /// Create a copy of MediaStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? link = freezed,
    Object? type = freezed,
  }) {
    return _then(_MediaStoryModel(
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$StoryCommentModel {
  String? get uid;
  String? get content;
  String? get timestamp;
  List<MediaStoryModel>? get medias;

  /// Create a copy of StoryCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StoryCommentModelCopyWith<StoryCommentModel> get copyWith =>
      _$StoryCommentModelCopyWithImpl<StoryCommentModel>(
          this as StoryCommentModel, _$identity);

  /// Serializes this StoryCommentModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StoryCommentModel &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other.medias, medias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, content, timestamp,
      const DeepCollectionEquality().hash(medias));

  @override
  String toString() {
    return 'StoryCommentModel(uid: $uid, content: $content, timestamp: $timestamp, medias: $medias)';
  }
}

/// @nodoc
abstract mixin class $StoryCommentModelCopyWith<$Res> {
  factory $StoryCommentModelCopyWith(
          StoryCommentModel value, $Res Function(StoryCommentModel) _then) =
      _$StoryCommentModelCopyWithImpl;
  @useResult
  $Res call(
      {String? uid,
      String? content,
      String? timestamp,
      List<MediaStoryModel>? medias});
}

/// @nodoc
class _$StoryCommentModelCopyWithImpl<$Res>
    implements $StoryCommentModelCopyWith<$Res> {
  _$StoryCommentModelCopyWithImpl(this._self, this._then);

  final StoryCommentModel _self;
  final $Res Function(StoryCommentModel) _then;

  /// Create a copy of StoryCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? content = freezed,
    Object? timestamp = freezed,
    Object? medias = freezed,
  }) {
    return _then(_self.copyWith(
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      medias: freezed == medias
          ? _self.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoryCommentModel implements StoryCommentModel {
  _StoryCommentModel(
      {this.uid,
      this.content,
      this.timestamp,
      final List<MediaStoryModel>? medias})
      : _medias = medias;
  factory _StoryCommentModel.fromJson(Map<String, dynamic> json) =>
      _$StoryCommentModelFromJson(json);

  @override
  final String? uid;
  @override
  final String? content;
  @override
  final String? timestamp;
  final List<MediaStoryModel>? _medias;
  @override
  List<MediaStoryModel>? get medias {
    final value = _medias;
    if (value == null) return null;
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of StoryCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StoryCommentModelCopyWith<_StoryCommentModel> get copyWith =>
      __$StoryCommentModelCopyWithImpl<_StoryCommentModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StoryCommentModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StoryCommentModel &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._medias, _medias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, content, timestamp,
      const DeepCollectionEquality().hash(_medias));

  @override
  String toString() {
    return 'StoryCommentModel(uid: $uid, content: $content, timestamp: $timestamp, medias: $medias)';
  }
}

/// @nodoc
abstract mixin class _$StoryCommentModelCopyWith<$Res>
    implements $StoryCommentModelCopyWith<$Res> {
  factory _$StoryCommentModelCopyWith(
          _StoryCommentModel value, $Res Function(_StoryCommentModel) _then) =
      __$StoryCommentModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? uid,
      String? content,
      String? timestamp,
      List<MediaStoryModel>? medias});
}

/// @nodoc
class __$StoryCommentModelCopyWithImpl<$Res>
    implements _$StoryCommentModelCopyWith<$Res> {
  __$StoryCommentModelCopyWithImpl(this._self, this._then);

  final _StoryCommentModel _self;
  final $Res Function(_StoryCommentModel) _then;

  /// Create a copy of StoryCommentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = freezed,
    Object? content = freezed,
    Object? timestamp = freezed,
    Object? medias = freezed,
  }) {
    return _then(_StoryCommentModel(
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
      medias: freezed == medias
          ? _self._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
    ));
  }
}

/// @nodoc
mixin _$UpdatedStoryModel {
  String? get timestamp;

  /// Create a copy of UpdatedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatedStoryModelCopyWith<UpdatedStoryModel> get copyWith =>
      _$UpdatedStoryModelCopyWithImpl<UpdatedStoryModel>(
          this as UpdatedStoryModel, _$identity);

  /// Serializes this UpdatedStoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatedStoryModel &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp);

  @override
  String toString() {
    return 'UpdatedStoryModel(timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $UpdatedStoryModelCopyWith<$Res> {
  factory $UpdatedStoryModelCopyWith(
          UpdatedStoryModel value, $Res Function(UpdatedStoryModel) _then) =
      _$UpdatedStoryModelCopyWithImpl;
  @useResult
  $Res call({String? timestamp});
}

/// @nodoc
class _$UpdatedStoryModelCopyWithImpl<$Res>
    implements $UpdatedStoryModelCopyWith<$Res> {
  _$UpdatedStoryModelCopyWithImpl(this._self, this._then);

  final UpdatedStoryModel _self;
  final $Res Function(UpdatedStoryModel) _then;

  /// Create a copy of UpdatedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = freezed,
  }) {
    return _then(_self.copyWith(
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UpdatedStoryModel implements UpdatedStoryModel {
  _UpdatedStoryModel({this.timestamp});
  factory _UpdatedStoryModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatedStoryModelFromJson(json);

  @override
  final String? timestamp;

  /// Create a copy of UpdatedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdatedStoryModelCopyWith<_UpdatedStoryModel> get copyWith =>
      __$UpdatedStoryModelCopyWithImpl<_UpdatedStoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdatedStoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdatedStoryModel &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp);

  @override
  String toString() {
    return 'UpdatedStoryModel(timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$UpdatedStoryModelCopyWith<$Res>
    implements $UpdatedStoryModelCopyWith<$Res> {
  factory _$UpdatedStoryModelCopyWith(
          _UpdatedStoryModel value, $Res Function(_UpdatedStoryModel) _then) =
      __$UpdatedStoryModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? timestamp});
}

/// @nodoc
class __$UpdatedStoryModelCopyWithImpl<$Res>
    implements _$UpdatedStoryModelCopyWith<$Res> {
  __$UpdatedStoryModelCopyWithImpl(this._self, this._then);

  final _UpdatedStoryModel _self;
  final $Res Function(_UpdatedStoryModel) _then;

  /// Create a copy of UpdatedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? timestamp = freezed,
  }) {
    return _then(_UpdatedStoryModel(
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
