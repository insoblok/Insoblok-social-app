import 'package:insoblok/models/models.dart';

extension ProductExtension on ProductModel {
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'tags': tags,
      'avatar_image': avatarImage,
      'model_image': modelImage,
      'old_price': oldPrice,
      'price': price,
      'off': off,
      'delivery': delivery,
      'category': category,
      'category_name': categoryName,
      'type': type,
      'uid': uid,
      'likes': likes,
      'rates': rates,
      'selles': selles,
      'medias': (medias ?? []).map((e) => e.toJson()).toList(),
    };
  }
}
