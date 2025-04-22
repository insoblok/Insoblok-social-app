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
  List<MediaStoryModel>? get medias;

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
            const DeepCollectionEquality().equals(other.medias, medias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, title, text, regdate,
      status, const DeepCollectionEquality().hash(medias));

  @override
  String toString() {
    return 'StoryModel(id: $id, uid: $uid, title: $title, text: $text, regdate: $regdate, status: $status, medias: $medias)';
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
      List<MediaStoryModel>? medias});
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
    Object? medias = freezed,
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
      medias: freezed == medias
          ? _self.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
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
      final List<MediaStoryModel>? medias})
      : _medias = medias;
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
  final List<MediaStoryModel>? _medias;
  @override
  List<MediaStoryModel>? get medias {
    final value = _medias;
    if (value == null) return null;
    if (_medias is EqualUnmodifiableListView) return _medias;
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
            const DeepCollectionEquality().equals(other._medias, _medias));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, title, text, regdate,
      status, const DeepCollectionEquality().hash(_medias));

  @override
  String toString() {
    return 'StoryModel(id: $id, uid: $uid, title: $title, text: $text, regdate: $regdate, status: $status, medias: $medias)';
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
      List<MediaStoryModel>? medias});
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
    Object? medias = freezed,
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
      medias: freezed == medias
          ? _self._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<MediaStoryModel>?,
    ));
  }
}

/// @nodoc
mixin _$MediaStoryModel {
  String? get id;
  String? get link;
  String? get type;
  String? get regdate;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.regdate, regdate) || other.regdate == regdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, link, type, regdate);

  @override
  String toString() {
    return 'MediaStoryModel(id: $id, link: $link, type: $type, regdate: $regdate)';
  }
}

/// @nodoc
abstract mixin class $MediaStoryModelCopyWith<$Res> {
  factory $MediaStoryModelCopyWith(
          MediaStoryModel value, $Res Function(MediaStoryModel) _then) =
      _$MediaStoryModelCopyWithImpl;
  @useResult
  $Res call({String? id, String? link, String? type, String? regdate});
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
    Object? id = freezed,
    Object? link = freezed,
    Object? type = freezed,
    Object? regdate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MediaStoryModel implements MediaStoryModel {
  _MediaStoryModel({this.id, this.link, this.type, this.regdate});
  factory _MediaStoryModel.fromJson(Map<String, dynamic> json) =>
      _$MediaStoryModelFromJson(json);

  @override
  final String? id;
  @override
  final String? link;
  @override
  final String? type;
  @override
  final String? regdate;

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
            (identical(other.id, id) || other.id == id) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.regdate, regdate) || other.regdate == regdate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, link, type, regdate);

  @override
  String toString() {
    return 'MediaStoryModel(id: $id, link: $link, type: $type, regdate: $regdate)';
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
  $Res call({String? id, String? link, String? type, String? regdate});
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
    Object? id = freezed,
    Object? link = freezed,
    Object? type = freezed,
    Object? regdate = freezed,
  }) {
    return _then(_MediaStoryModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _self.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
