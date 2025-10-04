import 'package:intl/intl.dart';

var kFirebaseFormatter = DateFormat("MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z");
var kFullFormatter = DateFormat('yyyyMMddHHmmss');
var kFullDateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
var kDateYMDFormatter = DateFormat('yyyy-MM-dd');
var kDateMDFormatter = DateFormat('MM-dd');
var kDateHMFormatter = DateFormat('HH:mm');

var kDateMDYFormatter = DateFormat("MMM dd");
var kDateHMMDYFormatter = DateFormat('HH:mm • MM/dd/yy');

var kDateMMMMYYFormatter = DateFormat('MMMM yyyy');
var kDateWeekFormatter = DateFormat('EEE');
var kDateCounterFormatter = DateFormat('ddd');

int getWeekNumber(DateTime date) {
  // Clone the date and reset time to midnight
  final thursday = date.toUtc().add(Duration(days: (4 - date.weekday) % 7));
  final firstThursday = DateTime.utc(thursday.year, 1, 4);

  // Calculate the week number
  final weekNumber =
      ((thursday.difference(firstThursday).inDays) / 7).floor() + 1;
  return weekNumber;
}
