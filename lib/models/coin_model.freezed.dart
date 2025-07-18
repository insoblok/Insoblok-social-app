// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coin_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoinModel {

 String? get icon; String? get type; String? get unit; String? get amount;
/// Create a copy of CoinModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoinModelCopyWith<CoinModel> get copyWith => _$CoinModelCopyWithImpl<CoinModel>(this as CoinModel, _$identity);

  /// Serializes this CoinModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoinModel&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,type,unit,amount);

@override
String toString() {
  return 'CoinModel(icon: $icon, type: $type, unit: $unit, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $CoinModelCopyWith<$Res>  {
  factory $CoinModelCopyWith(CoinModel value, $Res Function(CoinModel) _then) = _$CoinModelCopyWithImpl;
@useResult
$Res call({
 String? icon, String? type, String? unit, String? amount
});




}
/// @nodoc
class _$CoinModelCopyWithImpl<$Res>
    implements $CoinModelCopyWith<$Res> {
  _$CoinModelCopyWithImpl(this._self, this._then);

  final CoinModel _self;
  final $Res Function(CoinModel) _then;

/// Create a copy of CoinModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = freezed,Object? type = freezed,Object? unit = freezed,Object? amount = freezed,}) {
  return _then(_self.copyWith(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoinModel].
extension CoinModelPatterns on CoinModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoinModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoinModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoinModel value)  $default,){
final _that = this;
switch (_that) {
case _CoinModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoinModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoinModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? icon,  String? type,  String? unit,  String? amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoinModel() when $default != null:
return $default(_that.icon,_that.type,_that.unit,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? icon,  String? type,  String? unit,  String? amount)  $default,) {final _that = this;
switch (_that) {
case _CoinModel():
return $default(_that.icon,_that.type,_that.unit,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? icon,  String? type,  String? unit,  String? amount)?  $default,) {final _that = this;
switch (_that) {
case _CoinModel() when $default != null:
return $default(_that.icon,_that.type,_that.unit,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CoinModel implements CoinModel {
   _CoinModel({this.icon, this.type, this.unit, this.amount});
  factory _CoinModel.fromJson(Map<String, dynamic> json) => _$CoinModelFromJson(json);

@override final  String? icon;
@override final  String? type;
@override final  String? unit;
@override final  String? amount;

/// Create a copy of CoinModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoinModelCopyWith<_CoinModel> get copyWith => __$CoinModelCopyWithImpl<_CoinModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoinModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoinModel&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.type, type) || other.type == type)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,icon,type,unit,amount);

@override
String toString() {
  return 'CoinModel(icon: $icon, type: $type, unit: $unit, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$CoinModelCopyWith<$Res> implements $CoinModelCopyWith<$Res> {
  factory _$CoinModelCopyWith(_CoinModel value, $Res Function(_CoinModel) _then) = __$CoinModelCopyWithImpl;
@override @useResult
$Res call({
 String? icon, String? type, String? unit, String? amount
});




}
/// @nodoc
class __$CoinModelCopyWithImpl<$Res>
    implements _$CoinModelCopyWith<$Res> {
  __$CoinModelCopyWithImpl(this._self, this._then);

  final _CoinModel _self;
  final $Res Function(_CoinModel) _then;

/// Create a copy of CoinModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = freezed,Object? type = freezed,Object? unit = freezed,Object? amount = freezed,}) {
  return _then(_CoinModel(
icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
