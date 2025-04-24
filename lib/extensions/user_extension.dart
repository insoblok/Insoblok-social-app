import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';

extension UserModelExt on UserModel {
  bool isLike() {
    var like = likes ?? [];
    return like.contains(AuthHelper.user!.uid);
  }

  bool isFollow() {
    var follow = follows ?? [];
    return follow.contains(AuthHelper.user!.uid);
  }
}
