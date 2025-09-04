// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 int? get id; String? get from_address; String? get to_address; String? get token_symbol; double? get amount; String? get tx_hash; DateTime? get timestamp; String? get status; String? get chain;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.from_address, from_address) || other.from_address == from_address)&&(identical(other.to_address, to_address) || other.to_address == to_address)&&(identical(other.token_symbol, token_symbol) || other.token_symbol == token_symbol)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.tx_hash, tx_hash) || other.tx_hash == tx_hash)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.chain, chain) || other.chain == chain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,from_address,to_address,token_symbol,amount,tx_hash,timestamp,status,chain);

@override
String toString() {
  return 'TransactionModel(id: $id, from_address: $from_address, to_address: $to_address, token_symbol: $token_symbol, amount: $amount, tx_hash: $tx_hash, timestamp: $timestamp, status: $status, chain: $chain)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 int? id, String? from_address, String? to_address, String? token_symbol, double? amount, String? tx_hash, DateTime? timestamp, String? status, String? chain
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? from_address = freezed,Object? to_address = freezed,Object? token_symbol = freezed,Object? amount = freezed,Object? tx_hash = freezed,Object? timestamp = freezed,Object? status = freezed,Object? chain = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,from_address: freezed == from_address ? _self.from_address : from_address // ignore: cast_nullable_to_non_nullable
as String?,to_address: freezed == to_address ? _self.to_address : to_address // ignore: cast_nullable_to_non_nullable
as String?,token_symbol: freezed == token_symbol ? _self.token_symbol : token_symbol // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,tx_hash: freezed == tx_hash ? _self.tx_hash : tx_hash // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,chain: freezed == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? from_address,  String? to_address,  String? token_symbol,  double? amount,  String? tx_hash,  DateTime? timestamp,  String? status,  String? chain)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.from_address,_that.to_address,_that.token_symbol,_that.amount,_that.tx_hash,_that.timestamp,_that.status,_that.chain);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? from_address,  String? to_address,  String? token_symbol,  double? amount,  String? tx_hash,  DateTime? timestamp,  String? status,  String? chain)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.from_address,_that.to_address,_that.token_symbol,_that.amount,_that.tx_hash,_that.timestamp,_that.status,_that.chain);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? from_address,  String? to_address,  String? token_symbol,  double? amount,  String? tx_hash,  DateTime? timestamp,  String? status,  String? chain)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.from_address,_that.to_address,_that.token_symbol,_that.amount,_that.tx_hash,_that.timestamp,_that.status,_that.chain);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TransactionModel implements TransactionModel {
   _TransactionModel({this.id, this.from_address, this.to_address, this.token_symbol, this.amount, this.tx_hash, this.timestamp, this.status, this.chain});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  int? id;
@override final  String? from_address;
@override final  String? to_address;
@override final  String? token_symbol;
@override final  double? amount;
@override final  String? tx_hash;
@override final  DateTime? timestamp;
@override final  String? status;
@override final  String? chain;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.from_address, from_address) || other.from_address == from_address)&&(identical(other.to_address, to_address) || other.to_address == to_address)&&(identical(other.token_symbol, token_symbol) || other.token_symbol == token_symbol)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.tx_hash, tx_hash) || other.tx_hash == tx_hash)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.status, status) || other.status == status)&&(identical(other.chain, chain) || other.chain == chain));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,from_address,to_address,token_symbol,amount,tx_hash,timestamp,status,chain);

@override
String toString() {
  return 'TransactionModel(id: $id, from_address: $from_address, to_address: $to_address, token_symbol: $token_symbol, amount: $amount, tx_hash: $tx_hash, timestamp: $timestamp, status: $status, chain: $chain)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? from_address, String? to_address, String? token_symbol, double? amount, String? tx_hash, DateTime? timestamp, String? status, String? chain
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? from_address = freezed,Object? to_address = freezed,Object? token_symbol = freezed,Object? amount = freezed,Object? tx_hash = freezed,Object? timestamp = freezed,Object? status = freezed,Object? chain = freezed,}) {
  return _then(_TransactionModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,from_address: freezed == from_address ? _self.from_address : from_address // ignore: cast_nullable_to_non_nullable
as String?,to_address: freezed == to_address ? _self.to_address : to_address // ignore: cast_nullable_to_non_nullable
as String?,token_symbol: freezed == token_symbol ? _self.token_symbol : token_symbol // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,tx_hash: freezed == tx_hash ? _self.tx_hash : tx_hash // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,chain: freezed == chain ? _self.chain : chain // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
