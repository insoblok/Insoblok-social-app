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
  String? get key;
  String? get postId;
  String? get userUid;
  List<ConnectedStoryModel>? get connects;
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
            (identical(other.key, key) || other.key == key) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            const DeepCollectionEquality().equals(other.connects, connects) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, postId, userUid,
      const DeepCollectionEquality().hash(connects), updateDate, timestamp);

  @override
  String toString() {
    return 'TastescoreModel(id: $id, key: $key, postId: $postId, userUid: $userUid, connects: $connects, updateDate: $updateDate, timestamp: $timestamp)';
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
      String? key,
      String? postId,
      String? userUid,
      List<ConnectedStoryModel>? connects,
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
    Object? key = freezed,
    Object? postId = freezed,
    Object? userUid = freezed,
    Object? connects = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      connects: freezed == connects
          ? _self.connects
          : connects // ignore: cast_nullable_to_non_nullable
              as List<ConnectedStoryModel>?,
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
      this.key,
      this.postId,
      this.userUid,
      final List<ConnectedStoryModel>? connects,
      this.updateDate,
      this.timestamp})
      : _connects = connects;
  factory _TastescoreModel.fromJson(Map<String, dynamic> json) =>
      _$TastescoreModelFromJson(json);

  @override
  final String? id;
  @override
  final String? key;
  @override
  final String? postId;
  @override
  final String? userUid;
  final List<ConnectedStoryModel>? _connects;
  @override
  List<ConnectedStoryModel>? get connects {
    final value = _connects;
    if (value == null) return null;
    if (_connects is EqualUnmodifiableListView) return _connects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
            (identical(other.key, key) || other.key == key) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid) &&
            const DeepCollectionEquality().equals(other._connects, _connects) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, key, postId, userUid,
      const DeepCollectionEquality().hash(_connects), updateDate, timestamp);

  @override
  String toString() {
    return 'TastescoreModel(id: $id, key: $key, postId: $postId, userUid: $userUid, connects: $connects, updateDate: $updateDate, timestamp: $timestamp)';
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
      String? key,
      String? postId,
      String? userUid,
      List<ConnectedStoryModel>? connects,
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
    Object? key = freezed,
    Object? postId = freezed,
    Object? userUid = freezed,
    Object? connects = freezed,
    Object? updateDate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_TastescoreModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
      connects: freezed == connects
          ? _self._connects
          : connects // ignore: cast_nullable_to_non_nullable
              as List<ConnectedStoryModel>?,
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
mixin _$ConnectedStoryModel {
  String? get postId;
  String? get userUid;

  /// Create a copy of ConnectedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectedStoryModelCopyWith<ConnectedStoryModel> get copyWith =>
      _$ConnectedStoryModelCopyWithImpl<ConnectedStoryModel>(
          this as ConnectedStoryModel, _$identity);

  /// Serializes this ConnectedStoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectedStoryModel &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, postId, userUid);

  @override
  String toString() {
    return 'ConnectedStoryModel(postId: $postId, userUid: $userUid)';
  }
}

/// @nodoc
abstract mixin class $ConnectedStoryModelCopyWith<$Res> {
  factory $ConnectedStoryModelCopyWith(
          ConnectedStoryModel value, $Res Function(ConnectedStoryModel) _then) =
      _$ConnectedStoryModelCopyWithImpl;
  @useResult
  $Res call({String? postId, String? userUid});
}

/// @nodoc
class _$ConnectedStoryModelCopyWithImpl<$Res>
    implements $ConnectedStoryModelCopyWith<$Res> {
  _$ConnectedStoryModelCopyWithImpl(this._self, this._then);

  final ConnectedStoryModel _self;
  final $Res Function(ConnectedStoryModel) _then;

  /// Create a copy of ConnectedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = freezed,
    Object? userUid = freezed,
  }) {
    return _then(_self.copyWith(
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ConnectedStoryModel implements ConnectedStoryModel {
  _ConnectedStoryModel({this.postId, this.userUid});
  factory _ConnectedStoryModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectedStoryModelFromJson(json);

  @override
  final String? postId;
  @override
  final String? userUid;

  /// Create a copy of ConnectedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConnectedStoryModelCopyWith<_ConnectedStoryModel> get copyWith =>
      __$ConnectedStoryModelCopyWithImpl<_ConnectedStoryModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ConnectedStoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConnectedStoryModel &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userUid, userUid) || other.userUid == userUid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, postId, userUid);

  @override
  String toString() {
    return 'ConnectedStoryModel(postId: $postId, userUid: $userUid)';
  }
}

/// @nodoc
abstract mixin class _$ConnectedStoryModelCopyWith<$Res>
    implements $ConnectedStoryModelCopyWith<$Res> {
  factory _$ConnectedStoryModelCopyWith(_ConnectedStoryModel value,
          $Res Function(_ConnectedStoryModel) _then) =
      __$ConnectedStoryModelCopyWithImpl;
  @override
  @useResult
  $Res call({String? postId, String? userUid});
}

/// @nodoc
class __$ConnectedStoryModelCopyWithImpl<$Res>
    implements _$ConnectedStoryModelCopyWith<$Res> {
  __$ConnectedStoryModelCopyWithImpl(this._self, this._then);

  final _ConnectedStoryModel _self;
  final $Res Function(_ConnectedStoryModel) _then;

  /// Create a copy of ConnectedStoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postId = freezed,
    Object? userUid = freezed,
  }) {
    return _then(_ConnectedStoryModel(
      postId: freezed == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      userUid: freezed == userUid
          ? _self.userUid
          : userUid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
