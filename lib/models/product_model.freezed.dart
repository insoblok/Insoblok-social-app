// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {

 String? get id; String? get name; String? get description; List<String>? get tags; String? get avatarImage; String? get modelImage; double? get oldPrice; double? get price; String? get off; String? get delivery; String? get category; String? get categoryName; String? get type; String? get userId; List<String>? get likes; List<int>? get rates; int? get selles; DateTime? get updateDate; DateTime? get timestamp; List<MediaStoryModel>? get medias;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.modelImage, modelImage) || other.modelImage == modelImage)&&(identical(other.oldPrice, oldPrice) || other.oldPrice == oldPrice)&&(identical(other.price, price) || other.price == price)&&(identical(other.off, off) || other.off == off)&&(identical(other.delivery, delivery) || other.delivery == delivery)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.likes, likes)&&const DeepCollectionEquality().equals(other.rates, rates)&&(identical(other.selles, selles) || other.selles == selles)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other.medias, medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,const DeepCollectionEquality().hash(tags),avatarImage,modelImage,oldPrice,price,off,delivery,category,categoryName,type,userId,const DeepCollectionEquality().hash(likes),const DeepCollectionEquality().hash(rates),selles,updateDate,timestamp,const DeepCollectionEquality().hash(medias)]);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, tags: $tags, avatarImage: $avatarImage, modelImage: $modelImage, oldPrice: $oldPrice, price: $price, off: $off, delivery: $delivery, category: $category, categoryName: $categoryName, type: $type, userId: $userId, likes: $likes, rates: $rates, selles: $selles, updateDate: $updateDate, timestamp: $timestamp, medias: $medias)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? description, List<String>? tags, String? avatarImage, String? modelImage, double? oldPrice, double? price, String? off, String? delivery, String? category, String? categoryName, String? type, String? userId, List<String>? likes, List<int>? rates, int? selles, DateTime? updateDate, DateTime? timestamp, List<MediaStoryModel>? medias
});




}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? tags = freezed,Object? avatarImage = freezed,Object? modelImage = freezed,Object? oldPrice = freezed,Object? price = freezed,Object? off = freezed,Object? delivery = freezed,Object? category = freezed,Object? categoryName = freezed,Object? type = freezed,Object? userId = freezed,Object? likes = freezed,Object? rates = freezed,Object? selles = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? medias = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,avatarImage: freezed == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String?,modelImage: freezed == modelImage ? _self.modelImage : modelImage // ignore: cast_nullable_to_non_nullable
as String?,oldPrice: freezed == oldPrice ? _self.oldPrice : oldPrice // ignore: cast_nullable_to_non_nullable
as double?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,off: freezed == off ? _self.off : off // ignore: cast_nullable_to_non_nullable
as String?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,rates: freezed == rates ? _self.rates : rates // ignore: cast_nullable_to_non_nullable
as List<int>?,selles: freezed == selles ? _self.selles : selles // ignore: cast_nullable_to_non_nullable
as int?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self.medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? description,  List<String>? tags,  String? avatarImage,  String? modelImage,  double? oldPrice,  double? price,  String? off,  String? delivery,  String? category,  String? categoryName,  String? type,  String? userId,  List<String>? likes,  List<int>? rates,  int? selles,  DateTime? updateDate,  DateTime? timestamp,  List<MediaStoryModel>? medias)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.tags,_that.avatarImage,_that.modelImage,_that.oldPrice,_that.price,_that.off,_that.delivery,_that.category,_that.categoryName,_that.type,_that.userId,_that.likes,_that.rates,_that.selles,_that.updateDate,_that.timestamp,_that.medias);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? description,  List<String>? tags,  String? avatarImage,  String? modelImage,  double? oldPrice,  double? price,  String? off,  String? delivery,  String? category,  String? categoryName,  String? type,  String? userId,  List<String>? likes,  List<int>? rates,  int? selles,  DateTime? updateDate,  DateTime? timestamp,  List<MediaStoryModel>? medias)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.description,_that.tags,_that.avatarImage,_that.modelImage,_that.oldPrice,_that.price,_that.off,_that.delivery,_that.category,_that.categoryName,_that.type,_that.userId,_that.likes,_that.rates,_that.selles,_that.updateDate,_that.timestamp,_that.medias);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? description,  List<String>? tags,  String? avatarImage,  String? modelImage,  double? oldPrice,  double? price,  String? off,  String? delivery,  String? category,  String? categoryName,  String? type,  String? userId,  List<String>? likes,  List<int>? rates,  int? selles,  DateTime? updateDate,  DateTime? timestamp,  List<MediaStoryModel>? medias)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.tags,_that.avatarImage,_that.modelImage,_that.oldPrice,_that.price,_that.off,_that.delivery,_that.category,_that.categoryName,_that.type,_that.userId,_that.likes,_that.rates,_that.selles,_that.updateDate,_that.timestamp,_that.medias);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductModel implements ProductModel {
   _ProductModel({this.id, this.name, this.description, final  List<String>? tags, this.avatarImage, this.modelImage, this.oldPrice, this.price, this.off, this.delivery, this.category, this.categoryName, this.type, this.userId, final  List<String>? likes, final  List<int>? rates, this.selles, this.updateDate, this.timestamp, final  List<MediaStoryModel>? medias}): _tags = tags,_likes = likes,_rates = rates,_medias = medias;
  factory _ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? description;
 final  List<String>? _tags;
@override List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? avatarImage;
@override final  String? modelImage;
@override final  double? oldPrice;
@override final  double? price;
@override final  String? off;
@override final  String? delivery;
@override final  String? category;
@override final  String? categoryName;
@override final  String? type;
@override final  String? userId;
 final  List<String>? _likes;
@override List<String>? get likes {
  final value = _likes;
  if (value == null) return null;
  if (_likes is EqualUnmodifiableListView) return _likes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<int>? _rates;
@override List<int>? get rates {
  final value = _rates;
  if (value == null) return null;
  if (_rates is EqualUnmodifiableListView) return _rates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? selles;
@override final  DateTime? updateDate;
@override final  DateTime? timestamp;
 final  List<MediaStoryModel>? _medias;
@override List<MediaStoryModel>? get medias {
  final value = _medias;
  if (value == null) return null;
  if (_medias is EqualUnmodifiableListView) return _medias;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.avatarImage, avatarImage) || other.avatarImage == avatarImage)&&(identical(other.modelImage, modelImage) || other.modelImage == modelImage)&&(identical(other.oldPrice, oldPrice) || other.oldPrice == oldPrice)&&(identical(other.price, price) || other.price == price)&&(identical(other.off, off) || other.off == off)&&(identical(other.delivery, delivery) || other.delivery == delivery)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._likes, _likes)&&const DeepCollectionEquality().equals(other._rates, _rates)&&(identical(other.selles, selles) || other.selles == selles)&&(identical(other.updateDate, updateDate) || other.updateDate == updateDate)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._medias, _medias));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,const DeepCollectionEquality().hash(_tags),avatarImage,modelImage,oldPrice,price,off,delivery,category,categoryName,type,userId,const DeepCollectionEquality().hash(_likes),const DeepCollectionEquality().hash(_rates),selles,updateDate,timestamp,const DeepCollectionEquality().hash(_medias)]);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, tags: $tags, avatarImage: $avatarImage, modelImage: $modelImage, oldPrice: $oldPrice, price: $price, off: $off, delivery: $delivery, category: $category, categoryName: $categoryName, type: $type, userId: $userId, likes: $likes, rates: $rates, selles: $selles, updateDate: $updateDate, timestamp: $timestamp, medias: $medias)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? description, List<String>? tags, String? avatarImage, String? modelImage, double? oldPrice, double? price, String? off, String? delivery, String? category, String? categoryName, String? type, String? userId, List<String>? likes, List<int>? rates, int? selles, DateTime? updateDate, DateTime? timestamp, List<MediaStoryModel>? medias
});




}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? description = freezed,Object? tags = freezed,Object? avatarImage = freezed,Object? modelImage = freezed,Object? oldPrice = freezed,Object? price = freezed,Object? off = freezed,Object? delivery = freezed,Object? category = freezed,Object? categoryName = freezed,Object? type = freezed,Object? userId = freezed,Object? likes = freezed,Object? rates = freezed,Object? selles = freezed,Object? updateDate = freezed,Object? timestamp = freezed,Object? medias = freezed,}) {
  return _then(_ProductModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,avatarImage: freezed == avatarImage ? _self.avatarImage : avatarImage // ignore: cast_nullable_to_non_nullable
as String?,modelImage: freezed == modelImage ? _self.modelImage : modelImage // ignore: cast_nullable_to_non_nullable
as String?,oldPrice: freezed == oldPrice ? _self.oldPrice : oldPrice // ignore: cast_nullable_to_non_nullable
as double?,price: freezed == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double?,off: freezed == off ? _self.off : off // ignore: cast_nullable_to_non_nullable
as String?,delivery: freezed == delivery ? _self.delivery : delivery // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,likes: freezed == likes ? _self._likes : likes // ignore: cast_nullable_to_non_nullable
as List<String>?,rates: freezed == rates ? _self._rates : rates // ignore: cast_nullable_to_non_nullable
as List<int>?,selles: freezed == selles ? _self.selles : selles // ignore: cast_nullable_to_non_nullable
as int?,updateDate: freezed == updateDate ? _self.updateDate : updateDate // ignore: cast_nullable_to_non_nullable
as DateTime?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime?,medias: freezed == medias ? _self._medias : medias // ignore: cast_nullable_to_non_nullable
as List<MediaStoryModel>?,
  ));
}


}


/// @nodoc
mixin _$ProductTribeCategoryModel {

 String? get title; List<ProductSubtypeModel>? get subtypes;
/// Create a copy of ProductTribeCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductTribeCategoryModelCopyWith<ProductTribeCategoryModel> get copyWith => _$ProductTribeCategoryModelCopyWithImpl<ProductTribeCategoryModel>(this as ProductTribeCategoryModel, _$identity);

  /// Serializes this ProductTribeCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductTribeCategoryModel&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.subtypes, subtypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(subtypes));

@override
String toString() {
  return 'ProductTribeCategoryModel(title: $title, subtypes: $subtypes)';
}


}

/// @nodoc
abstract mixin class $ProductTribeCategoryModelCopyWith<$Res>  {
  factory $ProductTribeCategoryModelCopyWith(ProductTribeCategoryModel value, $Res Function(ProductTribeCategoryModel) _then) = _$ProductTribeCategoryModelCopyWithImpl;
@useResult
$Res call({
 String? title, List<ProductSubtypeModel>? subtypes
});




}
/// @nodoc
class _$ProductTribeCategoryModelCopyWithImpl<$Res>
    implements $ProductTribeCategoryModelCopyWith<$Res> {
  _$ProductTribeCategoryModelCopyWithImpl(this._self, this._then);

  final ProductTribeCategoryModel _self;
  final $Res Function(ProductTribeCategoryModel) _then;

/// Create a copy of ProductTribeCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? subtypes = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtypes: freezed == subtypes ? _self.subtypes : subtypes // ignore: cast_nullable_to_non_nullable
as List<ProductSubtypeModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductTribeCategoryModel].
extension ProductTribeCategoryModelPatterns on ProductTribeCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductTribeCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductTribeCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductTribeCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductTribeCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductTribeCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductTribeCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  List<ProductSubtypeModel>? subtypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductTribeCategoryModel() when $default != null:
return $default(_that.title,_that.subtypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  List<ProductSubtypeModel>? subtypes)  $default,) {final _that = this;
switch (_that) {
case _ProductTribeCategoryModel():
return $default(_that.title,_that.subtypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  List<ProductSubtypeModel>? subtypes)?  $default,) {final _that = this;
switch (_that) {
case _ProductTribeCategoryModel() when $default != null:
return $default(_that.title,_that.subtypes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductTribeCategoryModel implements ProductTribeCategoryModel {
   _ProductTribeCategoryModel({this.title, final  List<ProductSubtypeModel>? subtypes}): _subtypes = subtypes;
  factory _ProductTribeCategoryModel.fromJson(Map<String, dynamic> json) => _$ProductTribeCategoryModelFromJson(json);

@override final  String? title;
 final  List<ProductSubtypeModel>? _subtypes;
@override List<ProductSubtypeModel>? get subtypes {
  final value = _subtypes;
  if (value == null) return null;
  if (_subtypes is EqualUnmodifiableListView) return _subtypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ProductTribeCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductTribeCategoryModelCopyWith<_ProductTribeCategoryModel> get copyWith => __$ProductTribeCategoryModelCopyWithImpl<_ProductTribeCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductTribeCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductTribeCategoryModel&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._subtypes, _subtypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_subtypes));

@override
String toString() {
  return 'ProductTribeCategoryModel(title: $title, subtypes: $subtypes)';
}


}

/// @nodoc
abstract mixin class _$ProductTribeCategoryModelCopyWith<$Res> implements $ProductTribeCategoryModelCopyWith<$Res> {
  factory _$ProductTribeCategoryModelCopyWith(_ProductTribeCategoryModel value, $Res Function(_ProductTribeCategoryModel) _then) = __$ProductTribeCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 String? title, List<ProductSubtypeModel>? subtypes
});




}
/// @nodoc
class __$ProductTribeCategoryModelCopyWithImpl<$Res>
    implements _$ProductTribeCategoryModelCopyWith<$Res> {
  __$ProductTribeCategoryModelCopyWithImpl(this._self, this._then);

  final _ProductTribeCategoryModel _self;
  final $Res Function(_ProductTribeCategoryModel) _then;

/// Create a copy of ProductTribeCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? subtypes = freezed,}) {
  return _then(_ProductTribeCategoryModel(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtypes: freezed == subtypes ? _self._subtypes : subtypes // ignore: cast_nullable_to_non_nullable
as List<ProductSubtypeModel>?,
  ));
}


}


/// @nodoc
mixin _$ProductSubtypeModel {

 String? get title; String? get description;
/// Create a copy of ProductSubtypeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSubtypeModelCopyWith<ProductSubtypeModel> get copyWith => _$ProductSubtypeModelCopyWithImpl<ProductSubtypeModel>(this as ProductSubtypeModel, _$identity);

  /// Serializes this ProductSubtypeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSubtypeModel&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'ProductSubtypeModel(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $ProductSubtypeModelCopyWith<$Res>  {
  factory $ProductSubtypeModelCopyWith(ProductSubtypeModel value, $Res Function(ProductSubtypeModel) _then) = _$ProductSubtypeModelCopyWithImpl;
@useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class _$ProductSubtypeModelCopyWithImpl<$Res>
    implements $ProductSubtypeModelCopyWith<$Res> {
  _$ProductSubtypeModelCopyWithImpl(this._self, this._then);

  final ProductSubtypeModel _self;
  final $Res Function(ProductSubtypeModel) _then;

/// Create a copy of ProductSubtypeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSubtypeModel].
extension ProductSubtypeModelPatterns on ProductSubtypeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSubtypeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSubtypeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSubtypeModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductSubtypeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSubtypeModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSubtypeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSubtypeModel() when $default != null:
return $default(_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _ProductSubtypeModel():
return $default(_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _ProductSubtypeModel() when $default != null:
return $default(_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductSubtypeModel implements ProductSubtypeModel {
   _ProductSubtypeModel({this.title, this.description});
  factory _ProductSubtypeModel.fromJson(Map<String, dynamic> json) => _$ProductSubtypeModelFromJson(json);

@override final  String? title;
@override final  String? description;

/// Create a copy of ProductSubtypeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSubtypeModelCopyWith<_ProductSubtypeModel> get copyWith => __$ProductSubtypeModelCopyWithImpl<_ProductSubtypeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSubtypeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSubtypeModel&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description);

@override
String toString() {
  return 'ProductSubtypeModel(title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$ProductSubtypeModelCopyWith<$Res> implements $ProductSubtypeModelCopyWith<$Res> {
  factory _$ProductSubtypeModelCopyWith(_ProductSubtypeModel value, $Res Function(_ProductSubtypeModel) _then) = __$ProductSubtypeModelCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description
});




}
/// @nodoc
class __$ProductSubtypeModelCopyWithImpl<$Res>
    implements _$ProductSubtypeModelCopyWith<$Res> {
  __$ProductSubtypeModelCopyWithImpl(this._self, this._then);

  final _ProductSubtypeModel _self;
  final $Res Function(_ProductSubtypeModel) _then;

/// Create a copy of ProductSubtypeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,}) {
  return _then(_ProductSubtypeModel(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
