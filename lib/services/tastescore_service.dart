import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

class TastescoreService {
  int loginScore(UserModel user) {
    try {
      var reward = user.rewardDate ?? 0;
      var loginedDate = user.updateDate ?? DateTime.now();
      logger.d(kDateYMDFormatter.format(user.updateDate!));

      var logined = DateTime(
        loginedDate.year,
        loginedDate.month,
        loginedDate.day,
      );
      var current = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      if (current.difference(logined) == Duration(days: 1)) {
        reward = reward + 1;
      } else if (current.difference(logined) > Duration(days: 1)) {
        reward = 0;
      }

      return reward;
    } catch (e) {
      logger.e(e);
    }
    return 0;
  }
}
