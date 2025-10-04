import 'package:insoblok/models/models.dart';
import 'package:insoblok/utils/utils.dart';
import 'package:insoblok/services/services.dart';


class UserScoreModel {
  final String id;
  final List<TastescoreModel> scores;

  UserScoreModel({required this.id, required this.scores});

  set date(String s) {
    date = s;
  }

  int get xpDay {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (score.updateDate?.month == DateTime.now().month) &&
          (score.updateDate?.day == DateTime.now().day)) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpWeek {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (getWeekNumber(score.updateDate!) == getWeekNumber(DateTime.now()))) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpMonth {
    var result = 0;
    for (var score in scores) {
      if ((score.updateDate?.year == DateTime.now().year) &&
          (score.updateDate?.month == DateTime.now().month)) {
        result += score.bonus ?? 0;
      }
    }
    return result;
  }

  int get xpTotal {
    var result = 0;
    for (var score in scores) {
      result += score.bonus ?? 0;
    }
    return result;
  }

  List<UserLevelModel> get userLevels =>
      AppSettingHelper.appSettingModel?.userLevel ?? [];

  UserLevelModel get userLevel {
    for (var userLevel in userLevels) {
      if ((userLevel.min ?? 0) <= xpTotal &&
          xpTotal < (userLevel.max ?? 1000000000)) {
        return userLevel;
      }
    }
    return userLevels.first;
  }

  double get indicatorValue {
    var min = userLevel.min ?? 0;
    var max = userLevel.max ?? 0;
    return (xpTotal - min) / (max - min);
  }

}
