import 'package:insoblok/models/models.dart';
import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension NewsModelExt on NewsModel {
  String get pubStr {
    try {
      var date = DateTime.parse(pubDate!);
      return kDateMMMMYYFormatter.format(date);
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }
}
