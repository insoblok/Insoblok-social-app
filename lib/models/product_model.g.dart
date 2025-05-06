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
      updatedDate: json['updated_date'] as String?,
      timestamp: json['timestamp'] as String?,
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
      'updated_date': instance.updatedDate,
      'timestamp': instance.timestamp,
    };
