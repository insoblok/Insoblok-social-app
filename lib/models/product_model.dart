import 'package:freezed_annotation/freezed_annotation.dart';

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
    String? updatedDate,
    String? timestamp,
  }) = _ProductModel;
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
