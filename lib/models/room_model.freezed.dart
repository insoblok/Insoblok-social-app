// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String? get id; String? get userId; String? get type; List<String?>? get userIds; DateTime? get updatedAt; DateTime? get timestamp; String? get status; List<String>? get archivedBy; List<String>? get deletedBy; String? get content; String? get statusSender; String? get statusReceiver; bool? get isGroup; String? get lastMessage;
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomModelCopyWith<RoomModel> get copyWith => _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.archivedBy, archivedBy)&&const DeepCollectionEquality().equals(other.deletedBy, deletedBy)&&(identical(other.content, content) || other.content == content)&&(identical(other.statusSender, statusSender) || other.statusSender == statusSender)&&(identical(other.statusReceiver, statusReceiver) || other.statusReceiver == statusReceiver)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,const DeepCollectionEquality().hash(userIds),updatedAt,timestamp,status,const DeepCollectionEquality().hash(archivedBy),const DeepCollectionEquality().hash(deletedBy),content,statusSender,statusReceiver,isGroup,lastMessage);

@override
String toString() {
  return 'RoomModel(id: $id, userId: $userId, type: $type, userIds: $userIds, updatedAt: $updatedAt, timestamp: $timestamp, status: $status, archivedBy: $archivedBy, deletedBy: $deletedBy, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver, isGroup: $isGroup, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res>  {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) = _$RoomModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? type, List<String?>? userIds, DateTime? updatedAt, DateTime? timestamp, String? status, List<String>? archivedBy, List<String>? deletedBy, String? content, String? statusSender, String? statusReceiver, bool? isGroup, String? lastMessage
});




}
/// @nodoc
class _$RoomModelCopyWithImpl<$Res>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._self, this._then);

  final RoomModel _self;
  final $Res Function(RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? type = freezed,Object? userIds = freezed,Object? updatedAt = freezed,Object? timestamp = freezed,Object? status = freezed,Object? archivedBy = freezed,Object? deletedBy = freezed,Object? content = freezed,Object? statusSender = freezed,Object? statusReceiver = freezed,Object? isGroup = freezed,Object? lastMessage = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String?>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,archivedBy: freezed == archivedBy ? _self.archivedBy : archivedBy // ignore: cast_nullable_to_non_nullable
as List<String>?,deletedBy: freezed == deletedBy ? _self.deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as List<String>?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,statusSender: freezed == statusSender ? _self.statusSender : statusSender // ignore: cast_nullable_to_non_nullable
as String?,statusReceiver: freezed == statusReceiver ? _self.statusReceiver : statusReceiver // ignore: cast_nullable_to_non_nullable
as String?,isGroup: freezed == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomModel].
extension RoomModelPatterns on RoomModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomModel value)  $default,){
final _that = this;
switch (_that) {
case _RoomModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomModel value)?  $default,){
final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? type,  List<String?>? userIds,  DateTime? updatedAt,  DateTime? timestamp,  String? status,  List<String>? archivedBy,  List<String>? deletedBy,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup,  String? lastMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.userIds,_that.updatedAt,_that.timestamp,_that.status,_that.archivedBy,_that.deletedBy,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup,_that.lastMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? type,  List<String?>? userIds,  DateTime? updatedAt,  DateTime? timestamp,  String? status,  List<String>? archivedBy,  List<String>? deletedBy,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup,  String? lastMessage)  $default,) {final _that = this;
switch (_that) {
case _RoomModel():
return $default(_that.id,_that.userId,_that.type,_that.userIds,_that.updatedAt,_that.timestamp,_that.status,_that.archivedBy,_that.deletedBy,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup,_that.lastMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? type,  List<String?>? userIds,  DateTime? updatedAt,  DateTime? timestamp,  String? status,  List<String>? archivedBy,  List<String>? deletedBy,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup,  String? lastMessage)?  $default,) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.userIds,_that.updatedAt,_that.timestamp,_that.status,_that.archivedBy,_that.deletedBy,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup,_that.lastMessage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _RoomModel implements RoomModel {
   _RoomModel({this.id, this.userId, this.type, final  List<String?>? userIds, this.updatedAt, this.timestamp, this.status, final  List<String>? archivedBy, final  List<String>? deletedBy, this.content, this.statusSender, this.statusReceiver, this.isGroup, this.lastMessage}): _userIds = userIds,_archivedBy = archivedBy,_deletedBy = deletedBy;
  factory _RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? type;
 final  List<String?>? _userIds;
@override List<String?>? get userIds {
  final value = _userIds;
  if (value == null) return null;
  if (_userIds is EqualUnmodifiableListView) return _userIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? updatedAt;
@override final  DateTime? timestamp;
@override final  String? status;
 final  List<String>? _archivedBy;
@override List<String>? get archivedBy {
  final value = _archivedBy;
  if (value == null) return null;
  if (_archivedBy is EqualUnmodifiableListView) return _archivedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _deletedBy;
@override List<String>? get deletedBy {
  final value = _deletedBy;
  if (value == null) return null;
  if (_deletedBy is EqualUnmodifiableListView) return _deletedBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? content;
@override final  String? statusSender;
@override final  String? statusReceiver;
@override final  bool? isGroup;
@override final  String? lastMessage;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomModelCopyWith<_RoomModel> get copyWith => __$RoomModelCopyWithImpl<_RoomModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._userIds, _userIds)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._archivedBy, _archivedBy)&&const DeepCollectionEquality().equals(other._deletedBy, _deletedBy)&&(identical(other.content, content) || other.content == content)&&(identical(other.statusSender, statusSender) || other.statusSender == statusSender)&&(identical(other.statusReceiver, statusReceiver) || other.statusReceiver == statusReceiver)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,const DeepCollectionEquality().hash(_userIds),updatedAt,timestamp,status,const DeepCollectionEquality().hash(_archivedBy),const DeepCollectionEquality().hash(_deletedBy),content,statusSender,statusReceiver,isGroup,lastMessage);

@override
String toString() {
  return 'RoomModel(id: $id, userId: $userId, type: $type, userIds: $userIds, updatedAt: $updatedAt, timestamp: $timestamp, status: $status, archivedBy: $archivedBy, deletedBy: $deletedBy, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver, isGroup: $isGroup, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res> implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(_RoomModel value, $Res Function(_RoomModel) _then) = __$RoomModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? type, List<String?>? userIds, DateTime? updatedAt, DateTime? timestamp, String? status, List<String>? archivedBy, List<String>? deletedBy, String? content, String? statusSender, String? statusReceiver, bool? isGroup, String? lastMessage
});




}
/// @nodoc
class __$RoomModelCopyWithImpl<$Res>
    implements _$RoomModelCopyWith<$Res> {
  __$RoomModelCopyWithImpl(this._self, this._then);

  final _RoomModel _self;
  final $Res Function(_RoomModel) _then;

/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? type = freezed,Object? userIds = freezed,Object? updatedAt = freezed,Object? timestamp = freezed,Object? status = freezed,Object? archivedBy = freezed,Object? deletedBy = freezed,Object? content = freezed,Object? statusSender = freezed,Object? statusReceiver = freezed,Object? isGroup = freezed,Object? lastMessage = freezed,}) {
  return _then(_RoomModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self._userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String?>?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,archivedBy: freezed == archivedBy ? _self._archivedBy : archivedBy // ignore: cast_nullable_to_non_nullable
as List<String>?,deletedBy: freezed == deletedBy ? _self._deletedBy : deletedBy // ignore: cast_nullable_to_non_nullable
as List<String>?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,statusSender: freezed == statusSender ? _self.statusSender : statusSender // ignore: cast_nullable_to_non_nullable
as String?,statusReceiver: freezed == statusReceiver ? _self.statusReceiver : statusReceiver // ignore: cast_nullable_to_non_nullable
as String?,isGroup: freezed == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
