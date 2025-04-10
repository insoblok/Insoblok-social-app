// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageModel {
  String? get id;
  String? get senderId;
  String? get content;
  String? get url;
  String? get type;
  String? get regDate;
  String? get updateDate;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageModelCopyWith<MessageModel> get copyWith =>
      _$MessageModelCopyWithImpl<MessageModel>(
          this as MessageModel, _$identity);

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, senderId, content, url, type, regDate, updateDate);

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, content: $content, url: $url, type: $type, regDate: $regDate, updateDate: $updateDate)';
  }
}

/// @nodoc
abstract mixin class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) _then) =
      _$MessageModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? senderId,
      String? content,
      String? url,
      String? type,
      String? regDate,
      String? updateDate});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res> implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._self, this._then);

  final MessageModel _self;
  final $Res Function(MessageModel) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? senderId = freezed,
    Object? content = freezed,
    Object? url = freezed,
    Object? type = freezed,
    Object? regDate = freezed,
    Object? updateDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _self.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MessageModel implements MessageModel {
  _MessageModel(
      {this.id,
      this.senderId,
      this.content,
      this.url,
      this.type,
      this.regDate,
      this.updateDate});
  factory _MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  @override
  final String? id;
  @override
  final String? senderId;
  @override
  final String? content;
  @override
  final String? url;
  @override
  final String? type;
  @override
  final String? regDate;
  @override
  final String? updateDate;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MessageModelCopyWith<_MessageModel> get copyWith =>
      __$MessageModelCopyWithImpl<_MessageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MessageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MessageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, senderId, content, url, type, regDate, updateDate);

  @override
  String toString() {
    return 'MessageModel(id: $id, senderId: $senderId, content: $content, url: $url, type: $type, regDate: $regDate, updateDate: $updateDate)';
  }
}

/// @nodoc
abstract mixin class _$MessageModelCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$MessageModelCopyWith(
          _MessageModel value, $Res Function(_MessageModel) _then) =
      __$MessageModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? senderId,
      String? content,
      String? url,
      String? type,
      String? regDate,
      String? updateDate});
}

/// @nodoc
class __$MessageModelCopyWithImpl<$Res>
    implements _$MessageModelCopyWith<$Res> {
  __$MessageModelCopyWithImpl(this._self, this._then);

  final _MessageModel _self;
  final $Res Function(_MessageModel) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? senderId = freezed,
    Object? content = freezed,
    Object? url = freezed,
    Object? type = freezed,
    Object? regDate = freezed,
    Object? updateDate = freezed,
  }) {
    return _then(_MessageModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _self.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
