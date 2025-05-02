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

  List<Map<String, String>> get linkInfo => [
    if (source != null) ...{
      {'type': 'domain', 'title': '${source?.domain}', 'icon': AIImages.icLink},
      {
        'type': 'location',
        'title':
            '${source?.location?.city} / ${source?.location?.country?.toUpperCase()}',
        'icon': AIImages.icLocation,
      },
    },
    {'type': 'since', 'title': 'Pub $pubStr', 'icon': AIImages.icCalendar},
    if (companies?.isNotEmpty ?? false) ...{
      {
        'type': 'company',
        'title': '${companies!.first['name']}',
        'icon': AIImages.icBottomHome,
      },
    },
  ];
}
