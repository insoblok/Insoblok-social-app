// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_code_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccessCodeModel {

 String? get id; String? get email; String? get userId; DateTime? get birthday; String? get accessCode; bool? get expiry; bool? get checked; DateTime? get createdAt;
/// Create a copy of AccessCodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessCodeModelCopyWith<AccessCodeModel> get copyWith => _$AccessCodeModelCopyWithImpl<AccessCodeModel>(this as AccessCodeModel, _$identity);

  /// Serializes this AccessCodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessCodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.accessCode, accessCode) || other.accessCode == accessCode)&&(identical(other.expiry, expiry) || other.expiry == expiry)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,userId,birthday,accessCode,expiry,checked,createdAt);

@override
String toString() {
  return 'AccessCodeModel(id: $id, email: $email, userId: $userId, birthday: $birthday, accessCode: $accessCode, expiry: $expiry, checked: $checked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AccessCodeModelCopyWith<$Res>  {
  factory $AccessCodeModelCopyWith(AccessCodeModel value, $Res Function(AccessCodeModel) _then) = _$AccessCodeModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? email, String? userId, DateTime? birthday, String? accessCode, bool? expiry, bool? checked, DateTime? createdAt
});




}
/// @nodoc
class _$AccessCodeModelCopyWithImpl<$Res>
    implements $AccessCodeModelCopyWith<$Res> {
  _$AccessCodeModelCopyWithImpl(this._self, this._then);

  final AccessCodeModel _self;
  final $Res Function(AccessCodeModel) _then;

/// Create a copy of AccessCodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? email = freezed,Object? userId = freezed,Object? birthday = freezed,Object? accessCode = freezed,Object? expiry = freezed,Object? checked = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,accessCode: freezed == accessCode ? _self.accessCode : accessCode // ignore: cast_nullable_to_non_nullable
as String?,expiry: freezed == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as bool?,checked: freezed == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessCodeModel].
extension AccessCodeModelPatterns on AccessCodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessCodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessCodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessCodeModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessCodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessCodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessCodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? email,  String? userId,  DateTime? birthday,  String? accessCode,  bool? expiry,  bool? checked,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessCodeModel() when $default != null:
return $default(_that.id,_that.email,_that.userId,_that.birthday,_that.accessCode,_that.expiry,_that.checked,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? email,  String? userId,  DateTime? birthday,  String? accessCode,  bool? expiry,  bool? checked,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AccessCodeModel():
return $default(_that.id,_that.email,_that.userId,_that.birthday,_that.accessCode,_that.expiry,_that.checked,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? email,  String? userId,  DateTime? birthday,  String? accessCode,  bool? expiry,  bool? checked,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AccessCodeModel() when $default != null:
return $default(_that.id,_that.email,_that.userId,_that.birthday,_that.accessCode,_that.expiry,_that.checked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AccessCodeModel implements AccessCodeModel {
   _AccessCodeModel({this.id, this.email, this.userId, this.birthday, this.accessCode, this.expiry, this.checked, this.createdAt});
  factory _AccessCodeModel.fromJson(Map<String, dynamic> json) => _$AccessCodeModelFromJson(json);

@override final  String? id;
@override final  String? email;
@override final  String? userId;
@override final  DateTime? birthday;
@override final  String? accessCode;
@override final  bool? expiry;
@override final  bool? checked;
@override final  DateTime? createdAt;

/// Create a copy of AccessCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessCodeModelCopyWith<_AccessCodeModel> get copyWith => __$AccessCodeModelCopyWithImpl<_AccessCodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessCodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessCodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.birthday, birthday) || other.birthday == birthday)&&(identical(other.accessCode, accessCode) || other.accessCode == accessCode)&&(identical(other.expiry, expiry) || other.expiry == expiry)&&(identical(other.checked, checked) || other.checked == checked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,userId,birthday,accessCode,expiry,checked,createdAt);

@override
String toString() {
  return 'AccessCodeModel(id: $id, email: $email, userId: $userId, birthday: $birthday, accessCode: $accessCode, expiry: $expiry, checked: $checked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AccessCodeModelCopyWith<$Res> implements $AccessCodeModelCopyWith<$Res> {
  factory _$AccessCodeModelCopyWith(_AccessCodeModel value, $Res Function(_AccessCodeModel) _then) = __$AccessCodeModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? email, String? userId, DateTime? birthday, String? accessCode, bool? expiry, bool? checked, DateTime? createdAt
});




}
/// @nodoc
class __$AccessCodeModelCopyWithImpl<$Res>
    implements _$AccessCodeModelCopyWith<$Res> {
  __$AccessCodeModelCopyWithImpl(this._self, this._then);

  final _AccessCodeModel _self;
  final $Res Function(_AccessCodeModel) _then;

/// Create a copy of AccessCodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? email = freezed,Object? userId = freezed,Object? birthday = freezed,Object? accessCode = freezed,Object? expiry = freezed,Object? checked = freezed,Object? createdAt = freezed,}) {
  return _then(_AccessCodeModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,birthday: freezed == birthday ? _self.birthday : birthday // ignore: cast_nullable_to_non_nullable
as DateTime?,accessCode: freezed == accessCode ? _self.accessCode : accessCode // ignore: cast_nullable_to_non_nullable
as String?,expiry: freezed == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as bool?,checked: freezed == checked ? _self.checked : checked // ignore: cast_nullable_to_non_nullable
as bool?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
