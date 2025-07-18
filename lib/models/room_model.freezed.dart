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

 String? get id; String? get userId; List<String?>? get userIds; DateTime? get updateDate; DateTime? get timestamp; String? get content; String? get statusSender; String? get statusReceiver; bool? get isGroup;
/// Create a copy of RoomModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomModelCopyWith<RoomModel> get copyWith => _$RoomModelCopyWithImpl<RoomModel>(this as RoomModel, _$identity);

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.userIds, userIds)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&(identical(other.statusSender, statusSender) || other.statusSender == statusSender)&&(identical(other.statusReceiver, statusReceiver) || other.statusReceiver == statusReceiver)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(userIds),updateDate,timestamp,content,statusSender,statusReceiver,isGroup);

@override
String toString() {
  return 'RoomModel(id: $id, userId: $userId, userIds: $userIds, updateDate: $updateDate, timestamp: $timestamp, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver, isGroup: $isGroup)';
}


}

/// @nodoc
abstract mixin class $RoomModelCopyWith<$Res>  {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) _then) = _$RoomModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, List<String?>? userIds, DateTime? updateDate, DateTime? timestamp, String? content, String? statusSender, String? statusReceiver, bool? isGroup
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? userIds = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? content = freezed,Object? statusSender = freezed,Object? statusReceiver = freezed,Object? isGroup = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self.userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String?>?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,statusSender: freezed == statusSender ? _self.statusSender : statusSender // ignore: cast_nullable_to_non_nullable
as String?,statusReceiver: freezed == statusReceiver ? _self.statusReceiver : statusReceiver // ignore: cast_nullable_to_non_nullable
as String?,isGroup: freezed == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  List<String?>? userIds,  DateTime? updateDate,  DateTime? timestamp,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.userIds,_that.updateDate,_that.timestamp,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  List<String?>? userIds,  DateTime? updateDate,  DateTime? timestamp,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup)  $default,) {final _that = this;
switch (_that) {
case _RoomModel():
return $default(_that.id,_that.userId,_that.userIds,_that.updateDate,_that.timestamp,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  List<String?>? userIds,  DateTime? updateDate,  DateTime? timestamp,  String? content,  String? statusSender,  String? statusReceiver,  bool? isGroup)?  $default,) {final _that = this;
switch (_that) {
case _RoomModel() when $default != null:
return $default(_that.id,_that.userId,_that.userIds,_that.updateDate,_that.timestamp,_that.content,_that.statusSender,_that.statusReceiver,_that.isGroup);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RoomModel implements RoomModel {
   _RoomModel({this.id, this.userId, final  List<String?>? userIds, this.updateDate, this.timestamp, this.content, this.statusSender, this.statusReceiver, this.isGroup}): _userIds = userIds;
  factory _RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);

@override final  String? id;
@override final  String? userId;
 final  List<String?>? _userIds;
@override List<String?>? get userIds {
  final value = _userIds;
  if (value == null) return null;
  if (_userIds is EqualUnmodifiableListView) return _userIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? updateDate;
@override final  DateTime? timestamp;
@override final  String? content;
@override final  String? statusSender;
@override final  String? statusReceiver;
@override final  bool? isGroup;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._userIds, _userIds)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.content, content) || other.content == content)&&(identical(other.statusSender, statusSender) || other.statusSender == statusSender)&&(identical(other.statusReceiver, statusReceiver) || other.statusReceiver == statusReceiver)&&(identical(other.isGroup, isGroup) || other.isGroup == isGroup));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(_userIds),updateDate,timestamp,content,statusSender,statusReceiver,isGroup);

@override
String toString() {
  return 'RoomModel(id: $id, userId: $userId, userIds: $userIds, updateDate: $updateDate, timestamp: $timestamp, content: $content, statusSender: $statusSender, statusReceiver: $statusReceiver, isGroup: $isGroup)';
}


}

/// @nodoc
abstract mixin class _$RoomModelCopyWith<$Res> implements $RoomModelCopyWith<$Res> {
  factory _$RoomModelCopyWith(_RoomModel value, $Res Function(_RoomModel) _then) = __$RoomModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, List<String?>? userIds, DateTime? updateDate, DateTime? timestamp, String? content, String? statusSender, String? statusReceiver, bool? isGroup
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? userIds = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? content = freezed,Object? statusSender = freezed,Object? statusReceiver = freezed,Object? isGroup = freezed,}) {
  return _then(_RoomModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,userIds: freezed == userIds ? _self._userIds : userIds // ignore: cast_nullable_to_non_nullable
as List<String?>?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,statusSender: freezed == statusSender ? _self.statusSender : statusSender // ignore: cast_nullable_to_non_nullable
as String?,statusReceiver: freezed == statusReceiver ? _self.statusReceiver : statusReceiver // ignore: cast_nullable_to_non_nullable
as String?,isGroup: freezed == isGroup ? _self.isGroup : isGroup // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
