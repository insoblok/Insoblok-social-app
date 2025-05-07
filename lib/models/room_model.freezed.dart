// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomModel {
  String? get id;
  String? get uid;
  List<String?>? get uids;
  DateTime? get regdate;
  DateTime? get timestamp;
  String? get content;
  String? get statusSender;
  String? get statusReceiver;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoomModelCopyWith<RoomModel> get copyWith =>
      _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RoomModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other.uids, uids) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.statusSender, statusSender) ||
                other.statusSender == statusSender) &&
            (identical(other.statusReceiver, statusReceiver) ||
                other.statusReceiver == statusReceiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      const DeepCollectionEquality().hash(uids),
      regdate,
      timestamp,
      content,
      statusSender,
      statusReceiver);

  @override
  String toString() {
    return 'RoomModel(id: $id, uid: $uid, uids: $uids, regdate: $regdate, timestamp: $timestamp, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver)';
  }
}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res> {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) =
      _$RoomModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? uid,
      List<String?>? uids,
      DateTime? regdate,
      DateTime? timestamp,
      String? content,
      String? statusSender,
      String? statusReceiver});
}

/// @nodoc
class _$RoomModelCopyWithImpl<$Res> implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._self, this._then);

  final RoomModel _self;
  final $Res Function(RoomModel) _then;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? uids = freezed,
    Object? regdate = freezed,
    Object? timestamp = freezed,
    Object? content = freezed,
    Object? statusSender = freezed,
    Object? statusReceiver = freezed,
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
      uids: freezed == uids
          ? _self.uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      statusSender: freezed == statusSender
          ? _self.statusSender
          : statusSender // ignore: cast_nullable_to_non_nullable
              as String?,
      statusReceiver: freezed == statusReceiver
          ? _self.statusReceiver
          : statusReceiver // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RoomModel implements RoomModel {
  _RoomModel(
      {this.id,
      this.uid,
      final List<String?>? uids,
      this.regdate,
      this.timestamp,
      this.content,
      this.statusSender,
      this.statusReceiver})
      : _uids = uids;
  factory _RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  @override
  final String? id;
  @override
  final String? uid;
  final List<String?>? _uids;
  @override
  List<String?>? get uids {
    final value = _uids;
    if (value == null) return null;
    if (_uids is EqualUnmodifiableListView) return _uids;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? regdate;
  @override
  final DateTime? timestamp;
  @override
  final String? content;
  @override
  final String? statusSender;
  @override
  final String? statusReceiver;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RoomModelCopyWith<_RoomModel> get copyWith =>
      __$RoomModelCopyWithImpl<_RoomModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RoomModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RoomModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._uids, _uids) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.statusSender, statusSender) ||
                other.statusSender == statusSender) &&
            (identical(other.statusReceiver, statusReceiver) ||
                other.statusReceiver == statusReceiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uid,
      const DeepCollectionEquality().hash(_uids),
      regdate,
      timestamp,
      content,
      statusSender,
      statusReceiver);

  @override
  String toString() {
    return 'RoomModel(id: $id, uid: $uid, uids: $uids, regdate: $regdate, timestamp: $timestamp, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver)';
  }
}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res>
    implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(
          _RoomModel value, $Res Function(_RoomModel) _then) =
      __$RoomModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? uid,
      List<String?>? uids,
      DateTime? regdate,
      DateTime? timestamp,
      String? content,
      String? statusSender,
      String? statusReceiver});
}

/// @nodoc
class __$RoomModelCopyWithImpl<$Res> implements _$RoomModelCopyWith<$Res> {
  __$RoomModelCopyWithImpl(this._self, this._then);

  final _RoomModel _self;
  final $Res Function(_RoomModel) _then;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? uid = freezed,
    Object? uids = freezed,
    Object? regdate = freezed,
    Object? timestamp = freezed,
    Object? content = freezed,
    Object? statusSender = freezed,
    Object? statusReceiver = freezed,
  }) {
    return _then(_RoomModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      uids: freezed == uids
          ? _self._uids
          : uids // ignore: cast_nullable_to_non_nullable
              as List<String?>?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      statusSender: freezed == statusSender
          ? _self.statusSender
          : statusSender // ignore: cast_nullable_to_non_nullable
              as String?,
      statusReceiver: freezed == statusReceiver
          ? _self.statusReceiver
          : statusReceiver // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
