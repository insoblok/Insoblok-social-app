import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StringExt on String {
  String get timeago {
    try {
      var date = kFullDateTimeFormatter.parse(this, true).toLocal();
      var duration = DateTime.now().difference(date);
      if (duration.inSeconds < 60) return 'Less 1m ago';
      if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
      if (duration.inHours < 24) return '${duration.inHours}h ago';
      if (duration.inHours < 48) return 'Yesterday';
      if (duration.inDays < 7) return kDateWeekFormatter.format(date);
      return kDateMDYFormatter.format(date);
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }

  String get mdyFormatter {
    try {
      var date = kFullDateTimeFormatter.parse(this, true).toLocal();
      return kDateMDYFormatter.format(date);
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }

  bool get isEmailValid => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(this);
}
