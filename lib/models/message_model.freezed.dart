// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String? get id; String? get chatId; String? get content; String? get senderId; String? get type; String? get status; String? get senderName; DateTime? get timestamp; List<String>? get medias; List<String>? get readBy; bool? get isRead;
/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageModelCopyWith<MessageModel> get copyWith => _$MessageModelCopyWithImpl<MessageModel>(this as MessageModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.medias, medias)&&const DeepCollectionEquality().equals(other.readBy, readBy)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,id,chatId,content,senderId,type,status,senderName,timestamp,const DeepCollectionEquality().hash(medias),const DeepCollectionEquality().hash(readBy),isRead);

@override
String toString() {
  return 'MessageModel(id: $id, chatId: $chatId, content: $content, senderId: $senderId, type: $type, status: $status, senderName: $senderName, timestamp: $timestamp, medias: $medias, readBy: $readBy, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class $MessageModelCopyWith<$Res>  {
  factory $MessageModelCopyWith(MessageModel value, $Res Function(MessageModel) _then) = _$MessageModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? chatId, String? content, String? senderId, String? type, String? status, String? senderName, DateTime? timestamp, List<String>? medias, List<String>? readBy, bool? isRead
});




}
/// @nodoc
class _$MessageModelCopyWithImpl<$Res>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._self, this._then);

  final MessageModel _self;
  final $Res Function(MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? chatId = freezed,Object? content = freezed,Object? senderId = freezed,Object? type = freezed,Object? status = freezed,Object? senderName = freezed,Object? timestamp = freezed,Object? medias = freezed,Object? readBy = freezed,Object? isRead = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self.medias : medias // ignore: cast_nullable_to_non_nullable
as List<String>?,readBy: freezed == readBy ? _self.readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>?,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageModel].
extension MessageModelPatterns on MessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageModel value)  $default,){
final _that = this;
switch (_that) {
case _MessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? chatId,  String? content,  String? senderId,  String? type,  String? status,  String? senderName,  DateTime? timestamp,  List<String>? medias,  List<String>? readBy,  bool? isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.chatId,_that.content,_that.senderId,_that.type,_that.status,_that.senderName,_that.timestamp,_that.medias,_that.readBy,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? chatId,  String? content,  String? senderId,  String? type,  String? status,  String? senderName,  DateTime? timestamp,  List<String>? medias,  List<String>? readBy,  bool? isRead)  $default,) {final _that = this;
switch (_that) {
case _MessageModel():
return $default(_that.id,_that.chatId,_that.content,_that.senderId,_that.type,_that.status,_that.senderName,_that.timestamp,_that.medias,_that.readBy,_that.isRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? chatId,  String? content,  String? senderId,  String? type,  String? status,  String? senderName,  DateTime? timestamp,  List<String>? medias,  List<String>? readBy,  bool? isRead)?  $default,) {final _that = this;
switch (_that) {
case _MessageModel() when $default != null:
return $default(_that.id,_that.chatId,_that.content,_that.senderId,_that.type,_that.status,_that.senderName,_that.timestamp,_that.medias,_that.readBy,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MessageModel implements MessageModel {
   _MessageModel({this.id, this.chatId, this.content, this.senderId, this.type, this.status, this.senderName, this.timestamp, final  List<String>? medias, final  List<String>? readBy, this.isRead}): _medias = medias,_readBy = readBy;
  

@override final  String? id;
@override final  String? chatId;
@override final  String? content;
@override final  String? senderId;
@override final  String? type;
@override final  String? status;
@override final  String? senderName;
@override final  DateTime? timestamp;
 final  List<String>? _medias;
@override List<String>? get medias {
  final value = _medias;
  if (value == null) return null;
  if (_medias is EqualUnmodifiableListView) return _medias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _readBy;
@override List<String>? get readBy {
  final value = _readBy;
  if (value == null) return null;
  if (_readBy is EqualUnmodifiableListView) return _readBy;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? isRead;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageModelCopyWith<_MessageModel> get copyWith => __$MessageModelCopyWithImpl<_MessageModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._medias, _medias)&&const DeepCollectionEquality().equals(other._readBy, _readBy)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,id,chatId,content,senderId,type,status,senderName,timestamp,const DeepCollectionEquality().hash(_medias),const DeepCollectionEquality().hash(_readBy),isRead);

@override
String toString() {
  return 'MessageModel(id: $id, chatId: $chatId, content: $content, senderId: $senderId, type: $type, status: $status, senderName: $senderName, timestamp: $timestamp, medias: $medias, readBy: $readBy, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$MessageModelCopyWith<$Res> implements $MessageModelCopyWith<$Res> {
  factory _$MessageModelCopyWith(_MessageModel value, $Res Function(_MessageModel) _then) = __$MessageModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? chatId, String? content, String? senderId, String? type, String? status, String? senderName, DateTime? timestamp, List<String>? medias, List<String>? readBy, bool? isRead
});




}
/// @nodoc
class __$MessageModelCopyWithImpl<$Res>
    implements _$MessageModelCopyWith<$Res> {
  __$MessageModelCopyWithImpl(this._self, this._then);

  final _MessageModel _self;
  final $Res Function(_MessageModel) _then;

/// Create a copy of MessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? chatId = freezed,Object? content = freezed,Object? senderId = freezed,Object? type = freezed,Object? status = freezed,Object? senderName = freezed,Object? timestamp = freezed,Object? medias = freezed,Object? readBy = freezed,Object? isRead = freezed,}) {
  return _then(_MessageModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self._medias : medias // ignore: cast_nullable_to_non_nullable
as List<String>?,readBy: freezed == readBy ? _self._readBy : readBy // ignore: cast_nullable_to_non_nullable
as List<String>?,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
