// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      avatarImage: json['avatar_image'] as String?,
      modelImage: json['model_image'] as String?,
      oldPrice: (json['old_price'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      off: json['off'] as String?,
      delivery: json['delivery'] as String?,
      category: json['category'] as String?,
      categoryName: json['category_name'] as String?,
      type: json['type'] as String?,
      uid: json['uid'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      rates: (json['rates'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      selles: (json['selles'] as num?)?.toInt(),
      updateDate: json['update_date'] == null
          ? null
          : DateTime.parse(json['update_date'] as String),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      medias: (json['medias'] as List<dynamic>?)
          ?.map((e) => MediaStoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'avatar_image': instance.avatarImage,
      'model_image': instance.modelImage,
      'old_price': instance.oldPrice,
      'price': instance.price,
      'off': instance.off,
      'delivery': instance.delivery,
      'category': instance.category,
      'category_name': instance.categoryName,
      'type': instance.type,
      'uid': instance.uid,
      'likes': instance.likes,
      'rates': instance.rates,
      'selles': instance.selles,
      'update_date': instance.updateDate?.toIso8601String(),
      'timestamp': instance.timestamp?.toIso8601String(),
      'medias': instance.medias,
    };

_ProductTribeCategoryModel _$ProductTribeCategoryModelFromJson(
        Map<String, dynamic> json) =>
    _ProductTribeCategoryModel(
      title: json['title'] as String?,
      subtypes: (json['subtypes'] as List<dynamic>?)
          ?.map((e) => ProductSubtypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductTribeCategoryModelToJson(
        _ProductTribeCategoryModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtypes': instance.subtypes,
    };

_ProductSubtypeModel _$ProductSubtypeModelFromJson(Map<String, dynamic> json) =>
    _ProductSubtypeModel(
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ProductSubtypeModelToJson(
        _ProductSubtypeModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
