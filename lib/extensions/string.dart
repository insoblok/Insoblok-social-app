import 'package:insoblok/services/services.dart';
import 'package:insoblok/utils/utils.dart';

extension StringExt on String {
  bool get isEmailValid => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(this);

  String get newsTimeago {
    try {
      var date = DateTime.parse(this).toLocal();
      return date.timeago;
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }

  String get pageSpeedThumbnail {
    return 'https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=${Uri.encodeComponent(this)}&screenshot=true';
  }

  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');
}

extension DateTimeExt on DateTime {
  String get timeago {
    try {
      var duration = DateTime.now().difference(this);
      if (duration.inSeconds < 60) return 'Less 1m ago';
      if (duration.inMinutes < 60) return '${duration.inMinutes}m ago';
      if (duration.inHours < 24) return '${duration.inHours}h ago';
      if (duration.inHours < 48) return 'Yesterday';
      if (duration.inDays < 7) return kDateWeekFormatter.format(this);
      return kDateMDYFormatter.format(this);
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }

  String get mdyFormatter {
    try {
      return kDateMDYFormatter.format(this);
    } catch (e) {
      logger.e(e);
    }
    return '---';
  }
}

extension MapExt on Map<String, dynamic> {
  Map<String, dynamic> get toFirebaseJson {
    Map<String, dynamic> result = {};

    for (var key in keys) {
      if (key == 'id') continue;
      var value = this[key];

      if (value == null) continue;

      if ((value is double) ||
          (value is String) ||
          (value is int) ||
          (value is bool)) {
      } else {
        if (value is DateTime) {
          logger.d('$key --- ${kFirebaseFormatter.format(value)}');
          value = kFirebaseFormatter.format(value.toUtc());
        } else if (value.runtimeType.toString().contains('List')) {
          if (value.runtimeType.toString() != 'List<String>') {
            value = value.map((e) => e.toMap()).toList();
          }
        } else {
          value = value.toMap();
        }
      }

      result[key] = value;
    }
    return result;
  }
}
