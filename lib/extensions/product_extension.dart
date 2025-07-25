import 'package:insoblok/extensions/extensions.dart';
import 'package:insoblok/models/models.dart';

extension ProductExtension on ProductModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'user_id': userId,
      'name': name,
      'description': description,
      'avatar_image': avatarImage,
      'model_image': modelImage,
      'old_price': oldPrice,
      'price': price,
      'off': off,
      'delivery': delivery,
      'category': category,
      'category_name': categoryName,
      'type': type,
      'selles': selles,
      'tags': (tags),
      'likes': (likes),
      'rates': (rates),
      'medias': ((medias ?? []).map((e) => e.toMap()).toList()),
      'update_date': updateDate?.toUtc().toIso8601String(),
      'timestamp': timestamp?.toUtc().toIso8601String(),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension ProductTribeCategoryModelExt on ProductTribeCategoryModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {
      'title': title,
      'subtypes': ((subtypes ?? []).map((e) => e.toMap()).toList()),
    };
    result.removeWhere((k, v) => v == null);
    return result;
  }
}

extension ProductSubtypeModelExt on ProductSubtypeModel {
  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {'title': title, 'description': description};
    result.removeWhere((k, v) => v == null);
    return result;
  }
}
