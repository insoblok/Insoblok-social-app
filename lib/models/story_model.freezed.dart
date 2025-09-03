// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 String? get id; String? get userId; String? get title; String? get text; String? get status; String? get category; List<String>? get likes; List<String>? get follows; List<String>? get views; DateTime? get updateDate; DateTime? get timestamp; List<ConnectedStoryModel>? get connects; List<String>? get comments; List<String>? get allowUsers; List<StoryVoteModel>? get votes; List<MediaStoryModel>? get medias;
/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryModelCopyWith<StoryModel> get copyWith => _$StoryModelCopyWithImpl<StoryModel>(this as StoryModel, _$identity);

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.likes, likes)&&const DeepCollectionEquality().equals(other.follows, follows)&&const DeepCollectionEquality().equals(other.views, views)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.connects, connects)&&const DeepCollectionEquality().equals(other.comments, comments)&&const DeepCollectionEquality().equals(other.allowUsers, allowUsers)&&const DeepCollectionEquality().equals(other.votes, votes)&&const DeepCollectionEquality().equals(other.medias, medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,text,status,category,const DeepCollectionEquality().hash(likes),const DeepCollectionEquality().hash(follows),const DeepCollectionEquality().hash(views),updateDate,timestamp,const DeepCollectionEquality().hash(connects),const DeepCollectionEquality().hash(comments),const DeepCollectionEquality().hash(allowUsers),const DeepCollectionEquality().hash(votes),const DeepCollectionEquality().hash(medias));

@override
String toString() {
  return 'StoryModel(id: $id, userId: $userId, title: $title, text: $text, status: $status, category: $category, likes: $likes, follows: $follows, views: $views, updateDate: $updateDate, timestamp: $timestamp, connects: $connects, comments: $comments, allowUsers: $allowUsers, votes: $votes, medias: $medias)';
}


}

/// @nodoc
abstract mixin class $StoryModelCopyWith<$Res>  {
  factory $StoryModelCopyWith(StoryModel value, $Res Function(StoryModel) _then) = _$StoryModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? title, String? text, String? status, String? category, List<String>? likes, List<String>? follows, List<String>? views, DateTime? updateDate, DateTime? timestamp, List<ConnectedStoryModel>? connects, List<String>? comments, List<String>? allowUsers, List<StoryVoteModel>? votes, List<MediaStoryModel>? medias
});




}
/// @nodoc
class _$StoryModelCopyWithImpl<$Res>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._self, this._then);

  final StoryModel _self;
  final $Res Function(StoryModel) _then;

/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? title = freezed,Object? text = freezed,Object? status = freezed,Object? category = freezed,Object? likes = freezed,Object? follows = freezed,Object? views = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? connects = freezed,Object? comments = freezed,Object? allowUsers = freezed,Object? votes = freezed,Object? medias = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,follows: freezed == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as List<String>?,views: freezed == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as List<String>?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,connects: freezed == connects ? _self.connects : connects // ignore: cast_nullable_to_non_nullable
as List<ConnectedStoryModel>?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>?,allowUsers: freezed == allowUsers ? _self.allowUsers : allowUsers // ignore: cast_nullable_to_non_nullable
as List<String>?,votes: freezed == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as List<StoryVoteModel>?,medias: freezed == medias ? _self.medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryModel].
extension StoryModelPatterns on StoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryModel value)  $default,){
final _that = this;
switch (_that) {
case _StoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? title,  String? text,  String? status,  String? category,  List<String>? likes,  List<String>? follows,  List<String>? views,  DateTime? updateDate,  DateTime? timestamp,  List<ConnectedStoryModel>? connects,  List<String>? comments,  List<String>? allowUsers,  List<StoryVoteModel>? votes,  List<MediaStoryModel>? medias)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.text,_that.status,_that.category,_that.likes,_that.follows,_that.views,_that.updateDate,_that.timestamp,_that.connects,_that.comments,_that.allowUsers,_that.votes,_that.medias);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? title,  String? text,  String? status,  String? category,  List<String>? likes,  List<String>? follows,  List<String>? views,  DateTime? updateDate,  DateTime? timestamp,  List<ConnectedStoryModel>? connects,  List<String>? comments,  List<String>? allowUsers,  List<StoryVoteModel>? votes,  List<MediaStoryModel>? medias)  $default,) {final _that = this;
switch (_that) {
case _StoryModel():
return $default(_that.id,_that.userId,_that.title,_that.text,_that.status,_that.category,_that.likes,_that.follows,_that.views,_that.updateDate,_that.timestamp,_that.connects,_that.comments,_that.allowUsers,_that.votes,_that.medias);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? title,  String? text,  String? status,  String? category,  List<String>? likes,  List<String>? follows,  List<String>? views,  DateTime? updateDate,  DateTime? timestamp,  List<ConnectedStoryModel>? connects,  List<String>? comments,  List<String>? allowUsers,  List<StoryVoteModel>? votes,  List<MediaStoryModel>? medias)?  $default,) {final _that = this;
switch (_that) {
case _StoryModel() when $default != null:
return $default(_that.id,_that.userId,_that.title,_that.text,_that.status,_that.category,_that.likes,_that.follows,_that.views,_that.updateDate,_that.timestamp,_that.connects,_that.comments,_that.allowUsers,_that.votes,_that.medias);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoryModel implements StoryModel {
   _StoryModel({this.id, this.userId, this.title, this.text, this.status, this.category, final  List<String>? likes, final  List<String>? follows, final  List<String>? views, this.updateDate, this.timestamp, final  List<ConnectedStoryModel>? connects, final  List<String>? comments, final  List<String>? allowUsers, final  List<String>? reactions, final  List<StoryVoteModel>? votes, final  List<MediaStoryModel>? medias}): _likes = likes,_follows = follows,_views = views,_connects = connects,_comments = comments,_allowUsers = allowUsers,_votes = votes,_medias = medias;
  factory _StoryModel.fromJson(Map<String, dynamic> json) => _$StoryModelFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? title;
@override final  String? text;
@override final  String? status;
@override final  String? category;
 final  List<String>? _likes;
@override List<String>? get likes {
  final value = _likes;
  if (value == null) return null;
  if (_likes is EqualUnmodifiableListView) return _likes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _follows;
@override List<String>? get follows {
  final value = _follows;
  if (value == null) return null;
  if (_follows is EqualUnmodifiableListView) return _follows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _views;
@override List<String>? get views {
  final value = _views;
  if (value == null) return null;
  if (_views is EqualUnmodifiableListView) return _views;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? updateDate;
@override final  DateTime? timestamp;
 final  List<ConnectedStoryModel>? _connects;
@override List<ConnectedStoryModel>? get connects {
  final value = _connects;
  if (value == null) return null;
  if (_connects is EqualUnmodifiableListView) return _connects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _comments;
@override List<String>? get comments {
  final value = _comments;
  if (value == null) return null;
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _allowUsers;
@override List<String>? get allowUsers {
  final value = _allowUsers;
  if (value == null) return null;
  if (_allowUsers is EqualUnmodifiableListView) return _allowUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<StoryVoteModel>? _votes;
@override List<StoryVoteModel>? get votes {
  final value = _votes;
  if (value == null) return null;
  if (_votes is EqualUnmodifiableListView) return _votes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<MediaStoryModel>? _medias;
@override List<MediaStoryModel>? get medias {
  final value = _medias;
  if (value == null) return null;
  if (_medias is EqualUnmodifiableListView) return _medias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryModelCopyWith<_StoryModel> get copyWith => __$StoryModelCopyWithImpl<_StoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._likes, _likes)&&const DeepCollectionEquality().equals(other._follows, _follows)&&const DeepCollectionEquality().equals(other._views, _views)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._connects, _connects)&&const DeepCollectionEquality().equals(other._comments, _comments)&&const DeepCollectionEquality().equals(other._allowUsers, _allowUsers)&&const DeepCollectionEquality().equals(other._votes, _votes)&&const DeepCollectionEquality().equals(other._medias, _medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,title,text,status,category,const DeepCollectionEquality().hash(_likes),const DeepCollectionEquality().hash(_follows),const DeepCollectionEquality().hash(_views),updateDate,timestamp,const DeepCollectionEquality().hash(_connects),const DeepCollectionEquality().hash(_comments),const DeepCollectionEquality().hash(_allowUsers),const DeepCollectionEquality().hash(_votes),const DeepCollectionEquality().hash(_medias));

@override
String toString() {
  return 'StoryModel(id: $id, userId: $userId, title: $title, text: $text, status: $status, category: $category, likes: $likes, follows: $follows, views: $views, updateDate: $updateDate, timestamp: $timestamp, connects: $connects, comments: $comments, allowUsers: $allowUsers, votes: $votes, medias: $medias)';
}


}

/// @nodoc
abstract mixin class _$StoryModelCopyWith<$Res> implements $StoryModelCopyWith<$Res> {
  factory _$StoryModelCopyWith(_StoryModel value, $Res Function(_StoryModel) _then) = __$StoryModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? title, String? text, String? status, String? category, List<String>? likes, List<String>? follows, List<String>? views, DateTime? updateDate, DateTime? timestamp, List<ConnectedStoryModel>? connects, List<String>? comments, List<String>? allowUsers, List<StoryVoteModel>? votes, List<MediaStoryModel>? medias
});




}
/// @nodoc
class __$StoryModelCopyWithImpl<$Res>
    implements _$StoryModelCopyWith<$Res> {
  __$StoryModelCopyWithImpl(this._self, this._then);

  final _StoryModel _self;
  final $Res Function(_StoryModel) _then;

/// Create a copy of StoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? title = freezed,Object? text = freezed,Object? status = freezed,Object? category = freezed,Object? likes = freezed,Object? follows = freezed,Object? views = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? connects = freezed,Object? comments = freezed,Object? allowUsers = freezed,Object? votes = freezed,Object? medias = freezed,}) {
  return _then(_StoryModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self._likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,follows: freezed == follows ? _self._follows : follows // ignore: cast_nullable_to_non_nullable
as List<String>?,views: freezed == views ? _self._views : views // ignore: cast_nullable_to_non_nullable
as List<String>?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,connects: freezed == connects ? _self._connects : connects // ignore: cast_nullable_to_non_nullable
as List<ConnectedStoryModel>?,comments: freezed == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<String>?,allowUsers: freezed == allowUsers ? _self._allowUsers : allowUsers // ignore: cast_nullable_to_non_nullable
as List<String>?,votes: freezed == votes ? _self._votes : votes // ignore: cast_nullable_to_non_nullable
as List<StoryVoteModel>?,medias: freezed == medias ? _self._medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}


}


/// @nodoc
mixin _$StoryVoteModel {

 String? get userId; bool? get vote; DateTime? get timestamp;
/// Create a copy of StoryVoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryVoteModelCopyWith<StoryVoteModel> get copyWith => _$StoryVoteModelCopyWithImpl<StoryVoteModel>(this as StoryVoteModel, _$identity);

  /// Serializes this StoryVoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryVoteModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vote, vote) || other.vote == vote)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,vote,timestamp);

@override
String toString() {
  return 'StoryVoteModel(userId: $userId, vote: $vote, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $StoryVoteModelCopyWith<$Res>  {
  factory $StoryVoteModelCopyWith(StoryVoteModel value, $Res Function(StoryVoteModel) _then) = _$StoryVoteModelCopyWithImpl;
@useResult
$Res call({
 String? userId, bool? vote, DateTime? timestamp
});




}
/// @nodoc
class _$StoryVoteModelCopyWithImpl<$Res>
    implements $StoryVoteModelCopyWith<$Res> {
  _$StoryVoteModelCopyWithImpl(this._self, this._then);

  final StoryVoteModel _self;
  final $Res Function(StoryVoteModel) _then;

/// Create a copy of StoryVoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? vote = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,vote: freezed == vote ? _self.vote : vote // ignore: cast_nullable_to_non_nullable
as bool?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryVoteModel].
extension StoryVoteModelPatterns on StoryVoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryVoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryVoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryVoteModel value)  $default,){
final _that = this;
switch (_that) {
case _StoryVoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryVoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoryVoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? userId,  bool? vote,  DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryVoteModel() when $default != null:
return $default(_that.userId,_that.vote,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? userId,  bool? vote,  DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _StoryVoteModel():
return $default(_that.userId,_that.vote,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? userId,  bool? vote,  DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _StoryVoteModel() when $default != null:
return $default(_that.userId,_that.vote,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoryVoteModel implements StoryVoteModel {
   _StoryVoteModel({this.userId, this.vote, this.timestamp});
  factory _StoryVoteModel.fromJson(Map<String, dynamic> json) => _$StoryVoteModelFromJson(json);

@override final  String? userId;
@override final  bool? vote;
@override final  DateTime? timestamp;

/// Create a copy of StoryVoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryVoteModelCopyWith<_StoryVoteModel> get copyWith => __$StoryVoteModelCopyWithImpl<_StoryVoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryVoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryVoteModel&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.vote, vote) || other.vote == vote)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,vote,timestamp);

@override
String toString() {
  return 'StoryVoteModel(userId: $userId, vote: $vote, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$StoryVoteModelCopyWith<$Res> implements $StoryVoteModelCopyWith<$Res> {
  factory _$StoryVoteModelCopyWith(_StoryVoteModel value, $Res Function(_StoryVoteModel) _then) = __$StoryVoteModelCopyWithImpl;
@override @useResult
$Res call({
 String? userId, bool? vote, DateTime? timestamp
});




}
/// @nodoc
class __$StoryVoteModelCopyWithImpl<$Res>
    implements _$StoryVoteModelCopyWith<$Res> {
  __$StoryVoteModelCopyWithImpl(this._self, this._then);

  final _StoryVoteModel _self;
  final $Res Function(_StoryVoteModel) _then;

/// Create a copy of StoryVoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? vote = freezed,Object? timestamp = freezed,}) {
  return _then(_StoryVoteModel(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,vote: freezed == vote ? _self.vote : vote // ignore: cast_nullable_to_non_nullable
as bool?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$MediaStoryModel {

 String? get link; String? get thumb; String? get type; double? get width; double? get height; String? get publicId;
/// Create a copy of MediaStoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaStoryModelCopyWith<MediaStoryModel> get copyWith => _$MediaStoryModelCopyWithImpl<MediaStoryModel>(this as MediaStoryModel, _$identity);

  /// Serializes this MediaStoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaStoryModel&&(identical(other.link, link) || other.link == link)&&(identical(other.thumb, thumb) || other.thumb == thumb)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,link,thumb,type,width,height);

@override
String toString() {
  return 'MediaStoryModel(link: $link, thumb: $thumb, type: $type, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $MediaStoryModelCopyWith<$Res>  {
  factory $MediaStoryModelCopyWith(MediaStoryModel value, $Res Function(MediaStoryModel) _then) = _$MediaStoryModelCopyWithImpl;
@useResult
$Res call({
 String? link, String? thumb, String? type, double? width, double? height
});




}
/// @nodoc
class _$MediaStoryModelCopyWithImpl<$Res>
    implements $MediaStoryModelCopyWith<$Res> {
  _$MediaStoryModelCopyWithImpl(this._self, this._then);

  final MediaStoryModel _self;
  final $Res Function(MediaStoryModel) _then;

/// Create a copy of MediaStoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? link = freezed,Object? thumb = freezed,Object? type = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_self.copyWith(
link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,thumb: freezed == thumb ? _self.thumb : thumb // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaStoryModel].
extension MediaStoryModelPatterns on MediaStoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaStoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaStoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaStoryModel value)  $default,){
final _that = this;
switch (_that) {
case _MediaStoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaStoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _MediaStoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? link,  String? thumb,  String? type,  double? width,  double? height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaStoryModel() when $default != null:
return $default(_that.link,_that.thumb,_that.type,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? link,  String? thumb,  String? type,  double? width,  double? height)  $default,) {final _that = this;
switch (_that) {
case _MediaStoryModel():
return $default(_that.link,_that.thumb,_that.type,_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? link,  String? thumb,  String? type,  double? width,  double? height)?  $default,) {final _that = this;
switch (_that) {
case _MediaStoryModel() when $default != null:
return $default(_that.link,_that.thumb,_that.type,_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MediaStoryModel implements MediaStoryModel {
   _MediaStoryModel({this.link, this.thumb, this.type, this.width, this.height, this.publicId});
  factory _MediaStoryModel.fromJson(Map<String, dynamic> json) => _$MediaStoryModelFromJson(json);

@override final  String? link;
@override final  String? thumb;
@override final  String? type;
@override final  double? width;
@override final  double? height;
@override final  String? publicId;

/// Create a copy of MediaStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaStoryModelCopyWith<_MediaStoryModel> get copyWith => __$MediaStoryModelCopyWithImpl<_MediaStoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaStoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaStoryModel&&(identical(other.link, link) || other.link == link)&&(identical(other.thumb, thumb) || other.thumb == thumb)&&(identical(other.type, type) || other.type == type)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,link,thumb,type,width,height);

@override
String toString() {
  return 'MediaStoryModel(link: $link, thumb: $thumb, type: $type, width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$MediaStoryModelCopyWith<$Res> implements $MediaStoryModelCopyWith<$Res> {
  factory _$MediaStoryModelCopyWith(_MediaStoryModel value, $Res Function(_MediaStoryModel) _then) = __$MediaStoryModelCopyWithImpl;
@override @useResult
$Res call({
 String? link, String? thumb, String? type, double? width, double? height
});




}
/// @nodoc
class __$MediaStoryModelCopyWithImpl<$Res>
    implements _$MediaStoryModelCopyWith<$Res> {
  __$MediaStoryModelCopyWithImpl(this._self, this._then);

  final _MediaStoryModel _self;
  final $Res Function(_MediaStoryModel) _then;

/// Create a copy of MediaStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? link = freezed,Object? thumb = freezed,Object? type = freezed,Object? width = freezed,Object? height = freezed,}) {
  return _then(_MediaStoryModel(
link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,thumb: freezed == thumb ? _self.thumb : thumb // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$StoryCommentModel {

 String? get id; String? get userId; String? get storyId; String? get commentId; String? get content; List<String>? get likes; DateTime? get timestamp; List<MediaStoryModel>? get medias;
/// Create a copy of StoryCommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCommentModelCopyWith<StoryCommentModel> get copyWith => _$StoryCommentModelCopyWithImpl<StoryCommentModel>(this as StoryCommentModel, _$identity);

  /// Serializes this StoryCommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.likes, likes)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.medias, medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storyId,commentId,content,const DeepCollectionEquality().hash(likes),timestamp,const DeepCollectionEquality().hash(medias));

@override
String toString() {
  return 'StoryCommentModel(id: $id, userId: $userId, storyId: $storyId, commentId: $commentId, content: $content, likes: $likes, timestamp: $timestamp, medias: $medias)';
}


}

/// @nodoc
abstract mixin class $StoryCommentModelCopyWith<$Res>  {
  factory $StoryCommentModelCopyWith(StoryCommentModel value, $Res Function(StoryCommentModel) _then) = _$StoryCommentModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? userId, String? storyId, String? commentId, String? content, List<String>? likes, DateTime? timestamp, List<MediaStoryModel>? medias
});




}
/// @nodoc
class _$StoryCommentModelCopyWithImpl<$Res>
    implements $StoryCommentModelCopyWith<$Res> {
  _$StoryCommentModelCopyWithImpl(this._self, this._then);

  final StoryCommentModel _self;
  final $Res Function(StoryCommentModel) _then;

/// Create a copy of StoryCommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? userId = freezed,Object? storyId = freezed,Object? commentId = freezed,Object? content = freezed,Object? likes = freezed,Object? timestamp = freezed,Object? medias = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,storyId: freezed == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String?,commentId: freezed == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self.medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoryCommentModel].
extension StoryCommentModelPatterns on StoryCommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoryCommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoryCommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoryCommentModel value)  $default,){
final _that = this;
switch (_that) {
case _StoryCommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoryCommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoryCommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? storyId,  String? commentId,  String? content,  List<String>? likes,  DateTime? timestamp,  List<MediaStoryModel>? medias)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoryCommentModel() when $default != null:
return $default(_that.id,_that.userId,_that.storyId,_that.commentId,_that.content,_that.likes,_that.timestamp,_that.medias);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? userId,  String? storyId,  String? commentId,  String? content,  List<String>? likes,  DateTime? timestamp,  List<MediaStoryModel>? medias)  $default,) {final _that = this;
switch (_that) {
case _StoryCommentModel():
return $default(_that.id,_that.userId,_that.storyId,_that.commentId,_that.content,_that.likes,_that.timestamp,_that.medias);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? userId,  String? storyId,  String? commentId,  String? content,  List<String>? likes,  DateTime? timestamp,  List<MediaStoryModel>? medias)?  $default,) {final _that = this;
switch (_that) {
case _StoryCommentModel() when $default != null:
return $default(_that.id,_that.userId,_that.storyId,_that.commentId,_that.content,_that.likes,_that.timestamp,_that.medias);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StoryCommentModel implements StoryCommentModel {
   _StoryCommentModel({this.id, this.userId, this.storyId, this.commentId, this.content, final  List<String>? likes, this.timestamp, final  List<MediaStoryModel>? medias}): _likes = likes,_medias = medias;
  factory _StoryCommentModel.fromJson(Map<String, dynamic> json) => _$StoryCommentModelFromJson(json);

@override final  String? id;
@override final  String? userId;
@override final  String? storyId;
@override final  String? commentId;
@override final  String? content;
 final  List<String>? _likes;
@override List<String>? get likes {
  final value = _likes;
  if (value == null) return null;
  if (_likes is EqualUnmodifiableListView) return _likes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? timestamp;
 final  List<MediaStoryModel>? _medias;
@override List<MediaStoryModel>? get medias {
  final value = _medias;
  if (value == null) return null;
  if (_medias is EqualUnmodifiableListView) return _medias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StoryCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCommentModelCopyWith<_StoryCommentModel> get copyWith => __$StoryCommentModelCopyWithImpl<_StoryCommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryCommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.storyId, storyId) || other.storyId == storyId)&&(identical(other.commentId, commentId) || other.commentId == commentId)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._likes, _likes)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._medias, _medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,storyId,commentId,content,const DeepCollectionEquality().hash(_likes),timestamp,const DeepCollectionEquality().hash(_medias));

@override
String toString() {
  return 'StoryCommentModel(id: $id, userId: $userId, storyId: $storyId, commentId: $commentId, content: $content, likes: $likes, timestamp: $timestamp, medias: $medias)';
}


}

/// @nodoc
abstract mixin class _$StoryCommentModelCopyWith<$Res> implements $StoryCommentModelCopyWith<$Res> {
  factory _$StoryCommentModelCopyWith(_StoryCommentModel value, $Res Function(_StoryCommentModel) _then) = __$StoryCommentModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? userId, String? storyId, String? commentId, String? content, List<String>? likes, DateTime? timestamp, List<MediaStoryModel>? medias
});




}
/// @nodoc
class __$StoryCommentModelCopyWithImpl<$Res>
    implements _$StoryCommentModelCopyWith<$Res> {
  __$StoryCommentModelCopyWithImpl(this._self, this._then);

  final _StoryCommentModel _self;
  final $Res Function(_StoryCommentModel) _then;

/// Create a copy of StoryCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? userId = freezed,Object? storyId = freezed,Object? commentId = freezed,Object? content = freezed,Object? likes = freezed,Object? timestamp = freezed,Object? medias = freezed,}) {
  return _then(_StoryCommentModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,storyId: freezed == storyId ? _self.storyId : storyId // ignore: cast_nullable_to_non_nullable
as String?,commentId: freezed == commentId ? _self.commentId : commentId // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self._likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self._medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}


}


/// @nodoc
mixin _$UpdatedStoryModel {

 DateTime? get timestamp;
/// Create a copy of UpdatedStoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatedStoryModelCopyWith<UpdatedStoryModel> get copyWith => _$UpdatedStoryModelCopyWithImpl<UpdatedStoryModel>(this as UpdatedStoryModel, _$identity);

  /// Serializes this UpdatedStoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatedStoryModel&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp);

@override
String toString() {
  return 'UpdatedStoryModel(timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $UpdatedStoryModelCopyWith<$Res>  {
  factory $UpdatedStoryModelCopyWith(UpdatedStoryModel value, $Res Function(UpdatedStoryModel) _then) = _$UpdatedStoryModelCopyWithImpl;
@useResult
$Res call({
 DateTime? timestamp
});




}
/// @nodoc
class _$UpdatedStoryModelCopyWithImpl<$Res>
    implements $UpdatedStoryModelCopyWith<$Res> {
  _$UpdatedStoryModelCopyWithImpl(this._self, this._then);

  final UpdatedStoryModel _self;
  final $Res Function(UpdatedStoryModel) _then;

/// Create a copy of UpdatedStoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatedStoryModel].
extension UpdatedStoryModelPatterns on UpdatedStoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatedStoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatedStoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatedStoryModel value)  $default,){
final _that = this;
switch (_that) {
case _UpdatedStoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatedStoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatedStoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatedStoryModel() when $default != null:
return $default(_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? timestamp)  $default,) {final _that = this;
switch (_that) {
case _UpdatedStoryModel():
return $default(_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _UpdatedStoryModel() when $default != null:
return $default(_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UpdatedStoryModel implements UpdatedStoryModel {
   _UpdatedStoryModel({this.timestamp});
  factory _UpdatedStoryModel.fromJson(Map<String, dynamic> json) => _$UpdatedStoryModelFromJson(json);

@override final  DateTime? timestamp;

/// Create a copy of UpdatedStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatedStoryModelCopyWith<_UpdatedStoryModel> get copyWith => __$UpdatedStoryModelCopyWithImpl<_UpdatedStoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatedStoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatedStoryModel&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp);

@override
String toString() {
  return 'UpdatedStoryModel(timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$UpdatedStoryModelCopyWith<$Res> implements $UpdatedStoryModelCopyWith<$Res> {
  factory _$UpdatedStoryModelCopyWith(_UpdatedStoryModel value, $Res Function(_UpdatedStoryModel) _then) = __$UpdatedStoryModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime? timestamp
});




}
/// @nodoc
class __$UpdatedStoryModelCopyWithImpl<$Res>
    implements _$UpdatedStoryModelCopyWith<$Res> {
  __$UpdatedStoryModelCopyWithImpl(this._self, this._then);

  final _UpdatedStoryModel _self;
  final $Res Function(_UpdatedStoryModel) _then;

/// Create a copy of UpdatedStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = freezed,}) {
  return _then(_UpdatedStoryModel(
timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ConnectedStoryModel {

 String? get postId; String? get userId;
/// Create a copy of ConnectedStoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectedStoryModelCopyWith<ConnectedStoryModel> get copyWith => _$ConnectedStoryModelCopyWithImpl<ConnectedStoryModel>(this as ConnectedStoryModel, _$identity);

  /// Serializes this ConnectedStoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectedStoryModel&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,userId);

@override
String toString() {
  return 'ConnectedStoryModel(postId: $postId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $ConnectedStoryModelCopyWith<$Res>  {
  factory $ConnectedStoryModelCopyWith(ConnectedStoryModel value, $Res Function(ConnectedStoryModel) _then) = _$ConnectedStoryModelCopyWithImpl;
@useResult
$Res call({
 String? postId, String? userId
});




}
/// @nodoc
class _$ConnectedStoryModelCopyWithImpl<$Res>
    implements $ConnectedStoryModelCopyWith<$Res> {
  _$ConnectedStoryModelCopyWithImpl(this._self, this._then);

  final ConnectedStoryModel _self;
  final $Res Function(ConnectedStoryModel) _then;

/// Create a copy of ConnectedStoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = freezed,Object? userId = freezed,}) {
  return _then(_self.copyWith(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectedStoryModel].
extension ConnectedStoryModelPatterns on ConnectedStoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectedStoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectedStoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectedStoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ConnectedStoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectedStoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectedStoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? postId,  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectedStoryModel() when $default != null:
return $default(_that.postId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? postId,  String? userId)  $default,) {final _that = this;
switch (_that) {
case _ConnectedStoryModel():
return $default(_that.postId,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? postId,  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _ConnectedStoryModel() when $default != null:
return $default(_that.postId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ConnectedStoryModel implements ConnectedStoryModel {
   _ConnectedStoryModel({this.postId, this.userId});
  factory _ConnectedStoryModel.fromJson(Map<String, dynamic> json) => _$ConnectedStoryModelFromJson(json);

@override final  String? postId;
@override final  String? userId;

/// Create a copy of ConnectedStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectedStoryModelCopyWith<_ConnectedStoryModel> get copyWith => __$ConnectedStoryModelCopyWithImpl<_ConnectedStoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectedStoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectedStoryModel&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,userId);

@override
String toString() {
  return 'ConnectedStoryModel(postId: $postId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$ConnectedStoryModelCopyWith<$Res> implements $ConnectedStoryModelCopyWith<$Res> {
  factory _$ConnectedStoryModelCopyWith(_ConnectedStoryModel value, $Res Function(_ConnectedStoryModel) _then) = __$ConnectedStoryModelCopyWithImpl;
@override @useResult
$Res call({
 String? postId, String? userId
});




}
/// @nodoc
class __$ConnectedStoryModelCopyWithImpl<$Res>
    implements _$ConnectedStoryModelCopyWith<$Res> {
  __$ConnectedStoryModelCopyWithImpl(this._self, this._then);

  final _ConnectedStoryModel _self;
  final $Res Function(_ConnectedStoryModel) _then;

/// Create a copy of ConnectedStoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = freezed,Object? userId = freezed,}) {
  return _then(_ConnectedStoryModel(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
