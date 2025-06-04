// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tastescore_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TastescoreModel {
  String? get id;
  String? get uid;
  String? get postId;
  String? get userUid;
  String? get type;
  int? get bonus;
  String? get desc;
  DateTime? get updateDate;
  DateTime? get timestamp;

  /// Create a copy of TastescoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TastescoreModelCopyWith<TastescoreModel> get copyWith =>
      _$TastescoreModelCopyWithImpl<TastescoreModel>(
          this as TastescoreModel, _$identity);

  /// Serializes this TastescoreModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TastescoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, postId, userUid, type,
      bonus, desc, updateDate, timestamp);

  @override
  String toString() {
    return 'TastescoreModel(id: $id, uid: $uid, postId: $postId, userUid: $userUid, type: $type, bonus: $bonus, desc: $desc, updateDate: $updateDate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $TastescoreModelCopyWith<$Res> {
  factory $TastescoreModelCopyWith(
          TastescoreModel value, $Res Function(TastescoreModel) _then) =
      _$TastescoreModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? postId,
      String? userUid,
      String? type,
      int? bonus,
      String? desc,
      DateTime? updateDate,
      DateTime? timestamp});
}

/// @nodoc
class _$TastescoreModelCopyWithImpl<$Res>
    implements $TastescoreModelCopyWith<$Res> {
  _$TastescoreModelCopyWithImpl(this._self, this._then);

  final TastescoreModel _self;
  final $Res Function(TastescoreModel) _then;

  /// Create a copy of TastescoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? postId = freezed,
    Object? userUid = freezed,
    Object? type = freezed,
    Object? bonus = freezed,
    Object? desc = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
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
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      bonus: freezed == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as int?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TastescoreModel implements TastescoreModel {
  _TastescoreModel(
      {this.id,
      this.uid,
      this.postId,
      this.userUid,
      this.type,
      this.bonus,
      this.desc,
      this.updateDate,
      this.timestamp});
  factory _TastescoreModel.fromJson(Map<String, dynamic> json) =>
      _$TastescoreModelFromJson(json);

  @override
  final String? id;
  @override
  final String? uid;
  @override
  final String? postId;
  @override
  final String? userUid;
  @override
  final String? type;
  @override
  final int? bonus;
  @override
  final String? desc;
  @override
  final DateTime? updateDate;
  @override
  final DateTime? timestamp;

  /// Create a copy of TastescoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TastescoreModelCopyWith<_TastescoreModel> get copyWith =>
      __$TastescoreModelCopyWithImpl<_TastescoreModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TastescoreModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TastescoreModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.bonus, bonus) || other.bonus == bonus) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, uid, postId, userUid, type,
      bonus, desc, updateDate, timestamp);

  @override
  String toString() {
    return 'TastescoreModel(id: $id, uid: $uid, postId: $postId, userUid: $userUid, type: $type, bonus: $bonus, desc: $desc, updateDate: $updateDate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$TastescoreModelCopyWith<$Res>
    implements $TastescoreModelCopyWith<$Res> {
  factory _$TastescoreModelCopyWith(
          _TastescoreModel value, $Res Function(_TastescoreModel) _then) =
      __$TastescoreModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? uid,
      String? postId,
      String? userUid,
      String? type,
      int? bonus,
      String? desc,
      DateTime? updateDate,
      DateTime? timestamp});
}

/// @nodoc
class __$TastescoreModelCopyWithImpl<$Res>
    implements _$TastescoreModelCopyWith<$Res> {
  __$TastescoreModelCopyWithImpl(this._self, this._then);

  final _TastescoreModel _self;
  final $Res Function(_TastescoreModel) _then;

  /// Create a copy of TastescoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? postId = freezed,
    Object? userUid = freezed,
    Object? type = freezed,
    Object? bonus = freezed,
    Object? desc = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_TastescoreModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      bonus: freezed == bonus
          ? _self.bonus
          : bonus // ignore: cast_nullable_to_non_nullable
              as int?,
      desc: freezed == desc
          ? _self.desc
          : desc // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
