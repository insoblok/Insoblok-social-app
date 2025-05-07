// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  String? get id;
  String? get name;
  String? get description;
  List<String>? get tags;
  String? get avatarImage;
  String? get modelImage;
  double? get oldPrice;
  double? get price;
  String? get off;
  String? get delivery;
  String? get category;
  String? get categoryName;
  String? get type;
  String? get uid;
  List<String>? get likes;
  List<int>? get rates;
  int? get selles;
  String? get regdate;
  String? get timestamp;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<ProductModel> get copyWith =>
      _$ProductModelCopyWithImpl<ProductModel>(
          this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.tags, tags) &&
            (identical(other.avatarImage, avatarImage) ||
                other.avatarImage == avatarImage) &&
            (identical(other.modelImage, modelImage) ||
                other.modelImage == modelImage) &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.off, off) || other.off == off) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other.likes, likes) &&
            const DeepCollectionEquality().equals(other.rates, rates) &&
            (identical(other.selles, selles) || other.selles == selles) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        const DeepCollectionEquality().hash(tags),
        avatarImage,
        modelImage,
        oldPrice,
        price,
        off,
        delivery,
        category,
        categoryName,
        type,
        uid,
        const DeepCollectionEquality().hash(likes),
        const DeepCollectionEquality().hash(rates),
        selles,
        regdate,
        timestamp
      ]);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, tags: $tags, avatarImage: $avatarImage, modelImage: $modelImage, oldPrice: $oldPrice, price: $price, off: $off, delivery: $delivery, category: $category, categoryName: $categoryName, type: $type, uid: $uid, likes: $likes, rates: $rates, selles: $selles, regdate: $regdate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) _then) =
      _$ProductModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      List<String>? tags,
      String? avatarImage,
      String? modelImage,
      double? oldPrice,
      double? price,
      String? off,
      String? delivery,
      String? category,
      String? categoryName,
      String? type,
      String? uid,
      List<String>? likes,
      List<int>? rates,
      int? selles,
      String? regdate,
      String? timestamp});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res> implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? tags = freezed,
    Object? avatarImage = freezed,
    Object? modelImage = freezed,
    Object? oldPrice = freezed,
    Object? price = freezed,
    Object? off = freezed,
    Object? delivery = freezed,
    Object? category = freezed,
    Object? categoryName = freezed,
    Object? type = freezed,
    Object? uid = freezed,
    Object? likes = freezed,
    Object? rates = freezed,
    Object? selles = freezed,
    Object? regdate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _self.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      avatarImage: freezed == avatarImage
          ? _self.avatarImage
          : avatarImage // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImage: freezed == modelImage
          ? _self.modelImage
          : modelImage // ignore: cast_nullable_to_non_nullable
              as String?,
      oldPrice: freezed == oldPrice
          ? _self.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      off: freezed == off
          ? _self.off
          : off // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: freezed == likes
          ? _self.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rates: freezed == rates
          ? _self.rates
          : rates // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      selles: freezed == selles
          ? _self.selles
          : selles // ignore: cast_nullable_to_non_nullable
              as int?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProductModel implements ProductModel {
  _ProductModel(
      {this.id,
      this.name,
      this.description,
      final List<String>? tags,
      this.avatarImage,
      this.modelImage,
      this.oldPrice,
      this.price,
      this.off,
      this.delivery,
      this.category,
      this.categoryName,
      this.type,
      this.uid,
      final List<String>? likes,
      final List<int>? rates,
      this.selles,
      this.regdate,
      this.timestamp})
      : _tags = tags,
        _likes = likes,
        _rates = rates;
  factory _ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? avatarImage;
  @override
  final String? modelImage;
  @override
  final double? oldPrice;
  @override
  final double? price;
  @override
  final String? off;
  @override
  final String? delivery;
  @override
  final String? category;
  @override
  final String? categoryName;
  @override
  final String? type;
  @override
  final String? uid;
  final List<String>? _likes;
  @override
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<int>? _rates;
  @override
  List<int>? get rates {
    final value = _rates;
    if (value == null) return null;
    if (_rates is EqualUnmodifiableListView) return _rates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? selles;
  @override
  final String? regdate;
  @override
  final String? timestamp;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductModelCopyWith<_ProductModel> get copyWith =>
      __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.avatarImage, avatarImage) ||
                other.avatarImage == avatarImage) &&
            (identical(other.modelImage, modelImage) ||
                other.modelImage == modelImage) &&
            (identical(other.oldPrice, oldPrice) ||
                other.oldPrice == oldPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.off, off) || other.off == off) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality().equals(other._rates, _rates) &&
            (identical(other.selles, selles) || other.selles == selles) &&
            (identical(other.regdate, regdate) || other.regdate == regdate) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        const DeepCollectionEquality().hash(_tags),
        avatarImage,
        modelImage,
        oldPrice,
        price,
        off,
        delivery,
        category,
        categoryName,
        type,
        uid,
        const DeepCollectionEquality().hash(_likes),
        const DeepCollectionEquality().hash(_rates),
        selles,
        regdate,
        timestamp
      ]);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, tags: $tags, avatarImage: $avatarImage, modelImage: $modelImage, oldPrice: $oldPrice, price: $price, off: $off, delivery: $delivery, category: $category, categoryName: $categoryName, type: $type, uid: $uid, likes: $likes, rates: $rates, selles: $selles, regdate: $regdate, timestamp: $timestamp)';
  }
}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(
          _ProductModel value, $Res Function(_ProductModel) _then) =
      __$ProductModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      List<String>? tags,
      String? avatarImage,
      String? modelImage,
      double? oldPrice,
      double? price,
      String? off,
      String? delivery,
      String? category,
      String? categoryName,
      String? type,
      String? uid,
      List<String>? likes,
      List<int>? rates,
      int? selles,
      String? regdate,
      String? timestamp});
}

/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? tags = freezed,
    Object? avatarImage = freezed,
    Object? modelImage = freezed,
    Object? oldPrice = freezed,
    Object? price = freezed,
    Object? off = freezed,
    Object? delivery = freezed,
    Object? category = freezed,
    Object? categoryName = freezed,
    Object? type = freezed,
    Object? uid = freezed,
    Object? likes = freezed,
    Object? rates = freezed,
    Object? selles = freezed,
    Object? regdate = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_ProductModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _self._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      avatarImage: freezed == avatarImage
          ? _self.avatarImage
          : avatarImage // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImage: freezed == modelImage
          ? _self.modelImage
          : modelImage // ignore: cast_nullable_to_non_nullable
              as String?,
      oldPrice: freezed == oldPrice
          ? _self.oldPrice
          : oldPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      off: freezed == off
          ? _self.off
          : off // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _self.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: freezed == likes
          ? _self._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rates: freezed == rates
          ? _self._rates
          : rates // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      selles: freezed == selles
          ? _self.selles
          : selles // ignore: cast_nullable_to_non_nullable
              as int?,
      regdate: freezed == regdate
          ? _self.regdate
          : regdate // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _self.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
