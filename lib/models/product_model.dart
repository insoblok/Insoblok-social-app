import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ProductModel({
    String? id,
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
    DateTime? updateDate,
    DateTime? timestamp,
    List<MediaStoryModel>? medias,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(FirebaseHelper.fromConvertJson(json));
}

@freezed
abstract class ProductTribeCategoryModel with _$ProductTribeCategoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ProductTribeCategoryModel({
    String? title,
    List<ProductSubtypeModel>? subtypes,
  }) = _ProductTribeCategoryModel;

  factory ProductTribeCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTribeCategoryModelFromJson(json);
}

@freezed
abstract class ProductSubtypeModel with _$ProductSubtypeModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory ProductSubtypeModel({String? title, String? description}) =
      _ProductSubtypeModel;

  factory ProductSubtypeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSubtypeModelFromJson(json);
}
