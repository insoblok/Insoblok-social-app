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
  String? get senderId;
  String? get receiverId;
  String? get regDate;
  String? get updateDate;
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
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.statusSender, statusSender) ||
                other.statusSender == statusSender) &&
            (identical(other.statusReceiver, statusReceiver) ||
                other.statusReceiver == statusReceiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, receiverId,
      regDate, updateDate, content, statusSender, statusReceiver);

  @override
  String toString() {
    return 'RoomModel(id: $id, senderId: $senderId, receiverId: $receiverId, regDate: $regDate, updateDate: $updateDate, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver)';
  }
}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res> {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) =
      _$RoomModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? senderId,
      String? receiverId,
      String? regDate,
      String? updateDate,
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
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? regDate = freezed,
    Object? updateDate = freezed,
    Object? content = freezed,
    Object? statusSender = freezed,
    Object? statusReceiver = freezed,
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
      receiverId: freezed == receiverId
          ? _self.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _self.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.senderId,
      this.receiverId,
      this.regDate,
      this.updateDate,
      this.content,
      this.statusSender,
      this.statusReceiver});
  factory _RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  @override
  final String? id;
  @override
  final String? senderId;
  @override
  final String? receiverId;
  @override
  final String? regDate;
  @override
  final String? updateDate;
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
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.regDate, regDate) || other.regDate == regDate) &&
            (identical(other.updateDate, updateDate) ||
                other.updateDate == updateDate) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.statusSender, statusSender) ||
                other.statusSender == statusSender) &&
            (identical(other.statusReceiver, statusReceiver) ||
                other.statusReceiver == statusReceiver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, senderId, receiverId,
      regDate, updateDate, content, statusSender, statusReceiver);

  @override
  String toString() {
    return 'RoomModel(id: $id, senderId: $senderId, receiverId: $receiverId, regDate: $regDate, updateDate: $updateDate, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver)';
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
      String? senderId,
      String? receiverId,
      String? regDate,
      String? updateDate,
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
    Object? senderId = freezed,
    Object? receiverId = freezed,
    Object? regDate = freezed,
    Object? updateDate = freezed,
    Object? content = freezed,
    Object? statusSender = freezed,
    Object? statusReceiver = freezed,
  }) {
    return _then(_RoomModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      receiverId: freezed == receiverId
          ? _self.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String?,
      regDate: freezed == regDate
          ? _self.regDate
          : regDate // ignore: cast_nullable_to_non_nullable
              as String?,
      updateDate: freezed == updateDate
          ? _self.updateDate
          : updateDate // ignore: cast_nullable_to_non_nullable
              as String?,
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
