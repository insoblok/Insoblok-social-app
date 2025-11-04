// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_chat_room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserChatRoomModel {

 String? get id; String? get userId; String? get roomId; bool? get isArchived; DateTime? get archivedAt; bool? get isMuted; String? get muteDuration; DateTime? get mutedAt; bool? get isDeleted; DateTime? get deletedAt; int? get unreadCount; DateTime? get lastReadAt;
/// Create a copy of UserChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserChatRoomModelCopyWith<UserChatRoomModel> get copyWith => _$UserChatRoomModelCopyWithImpl<UserChatRoomModel>(this as UserChatRoomModel, _$identity);

  /// Serializes this UserChatRoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserChatRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.muteDuration, muteDuration) || other.muteDuration == muteDuration)&&(identical(other.mutedAt, mutedAt) || other.mutedAt == mutedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,roomId,isArchived,archivedAt,isMuted,muteDuration,mutedAt,isDeleted,deletedAt,unreadCount,lastReadAt);

@override
String toString() {
  return 'UserChatRoomModel(id: $id, userId: $userId, roomId: $roomId, isArchived: $isArchived, archivedAt: $archivedAt, isMuted: $isMuted, muteDuration: $muteDuration, mutedAt: $mutedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, unreadCount: $unreadCount, lastReadAt: $lastReadAt)';
}


}

/// @nodoc
abstract mixin class $UserChatRoomModelCopyWith<$Res>  {
  factory $UserChatRoomModelCopyWith(UserChatRoomModel value, $Res Function(UserChatRoomModel) _then) = _$UserChatRoomModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? roomId, bool? isArchived, DateTime? archivedAt, bool? isMuted, String? muteDuration, DateTime? mutedAt, bool? isDeleted, DateTime? deletedAt, int? unreadCount, DateTime? lastReadAt
});




}
/// @nodoc
class _$UserChatRoomModelCopyWithImpl<$Res>
    implements $UserChatRoomModelCopyWith<$Res> {
  _$UserChatRoomModelCopyWithImpl(this._self, this._then);

  final UserChatRoomModel _self;
  final $Res Function(UserChatRoomModel) _then;

/// Create a copy of UserChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? roomId = freezed,Object? isArchived = freezed,Object? archivedAt = freezed,Object? isMuted = freezed,Object? muteDuration = freezed,Object? mutedAt = freezed,Object? isDeleted = freezed,Object? deletedAt = freezed,Object? unreadCount = freezed,Object? lastReadAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMuted: freezed == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool?,muteDuration: freezed == muteDuration ? _self.muteDuration : muteDuration // ignore: cast_nullable_to_non_nullable
as String?,mutedAt: freezed == mutedAt ? _self.mutedAt : mutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: freezed == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: freezed == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int?,lastReadAt: freezed == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserChatRoomModel].
extension UserChatRoomModelPatterns on UserChatRoomModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserChatRoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserChatRoomModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserChatRoomModel value)  $default,){
final _that = this;
switch (_that) {
case _UserChatRoomModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserChatRoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserChatRoomModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? roomId,  bool? isArchived,  DateTime? archivedAt,  bool? isMuted,  String? muteDuration,  DateTime? mutedAt,  bool? isDeleted,  DateTime? deletedAt,  int? unreadCount,  DateTime? lastReadAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserChatRoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.isArchived,_that.archivedAt,_that.isMuted,_that.muteDuration,_that.mutedAt,_that.isDeleted,_that.deletedAt,_that.unreadCount,_that.lastReadAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? roomId,  bool? isArchived,  DateTime? archivedAt,  bool? isMuted,  String? muteDuration,  DateTime? mutedAt,  bool? isDeleted,  DateTime? deletedAt,  int? unreadCount,  DateTime? lastReadAt)  $default,) {final _that = this;
switch (_that) {
case _UserChatRoomModel():
return $default(_that.id,_that.userId,_that.roomId,_that.isArchived,_that.archivedAt,_that.isMuted,_that.muteDuration,_that.mutedAt,_that.isDeleted,_that.deletedAt,_that.unreadCount,_that.lastReadAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? roomId,  bool? isArchived,  DateTime? archivedAt,  bool? isMuted,  String? muteDuration,  DateTime? mutedAt,  bool? isDeleted,  DateTime? deletedAt,  int? unreadCount,  DateTime? lastReadAt)?  $default,) {final _that = this;
switch (_that) {
case _UserChatRoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.roomId,_that.isArchived,_that.archivedAt,_that.isMuted,_that.muteDuration,_that.mutedAt,_that.isDeleted,_that.deletedAt,_that.unreadCount,_that.lastReadAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserChatRoomModel implements UserChatRoomModel {
   _UserChatRoomModel({this.id, this.userId, this.roomId, this.isArchived, this.archivedAt, this.isMuted, this.muteDuration, this.mutedAt, this.isDeleted, this.deletedAt, this.unreadCount, this.lastReadAt});
  factory _UserChatRoomModel.fromJson(Map<String, dynamic> json) => _$UserChatRoomModelFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? roomId;
@override final  bool? isArchived;
@override final  DateTime? archivedAt;
@override final  bool? isMuted;
@override final  String? muteDuration;
@override final  DateTime? mutedAt;
@override final  bool? isDeleted;
@override final  DateTime? deletedAt;
@override final  int? unreadCount;
@override final  DateTime? lastReadAt;

/// Create a copy of UserChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserChatRoomModelCopyWith<_UserChatRoomModel> get copyWith => __$UserChatRoomModelCopyWithImpl<_UserChatRoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserChatRoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserChatRoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.isArchived, isArchived) || other.isArchived == isArchived)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.muteDuration, muteDuration) || other.muteDuration == muteDuration)&&(identical(other.mutedAt, mutedAt) || other.mutedAt == mutedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,roomId,isArchived,archivedAt,isMuted,muteDuration,mutedAt,isDeleted,deletedAt,unreadCount,lastReadAt);

@override
String toString() {
  return 'UserChatRoomModel(id: $id, userId: $userId, roomId: $roomId, isArchived: $isArchived, archivedAt: $archivedAt, isMuted: $isMuted, muteDuration: $muteDuration, mutedAt: $mutedAt, isDeleted: $isDeleted, deletedAt: $deletedAt, unreadCount: $unreadCount, lastReadAt: $lastReadAt)';
}


}

/// @nodoc
abstract mixin class _$UserChatRoomModelCopyWith<$Res> implements $UserChatRoomModelCopyWith<$Res> {
  factory _$UserChatRoomModelCopyWith(_UserChatRoomModel value, $Res Function(_UserChatRoomModel) _then) = __$UserChatRoomModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? roomId, bool? isArchived, DateTime? archivedAt, bool? isMuted, String? muteDuration, DateTime? mutedAt, bool? isDeleted, DateTime? deletedAt, int? unreadCount, DateTime? lastReadAt
});




}
/// @nodoc
class __$UserChatRoomModelCopyWithImpl<$Res>
    implements _$UserChatRoomModelCopyWith<$Res> {
  __$UserChatRoomModelCopyWithImpl(this._self, this._then);

  final _UserChatRoomModel _self;
  final $Res Function(_UserChatRoomModel) _then;

/// Create a copy of UserChatRoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? roomId = freezed,Object? isArchived = freezed,Object? archivedAt = freezed,Object? isMuted = freezed,Object? muteDuration = freezed,Object? mutedAt = freezed,Object? isDeleted = freezed,Object? deletedAt = freezed,Object? unreadCount = freezed,Object? lastReadAt = freezed,}) {
  return _then(_UserChatRoomModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,isArchived: freezed == isArchived ? _self.isArchived : isArchived // ignore: cast_nullable_to_non_nullable
as bool?,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMuted: freezed == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool?,muteDuration: freezed == muteDuration ? _self.muteDuration : muteDuration // ignore: cast_nullable_to_non_nullable
as String?,mutedAt: freezed == mutedAt ? _self.mutedAt : mutedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: freezed == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: freezed == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int?,lastReadAt: freezed == lastReadAt ? _self.lastReadAt : lastReadAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
