import 'package:intl/intl.dart';

class CustomDate {
  /// Get current data
  String getShortFormatDate() {
    DateTime now = DateTime.now().toLocal();
    String date = '${now.day}/${now.month}/${now.year}';

    return date;
  }

  String getLongFormatDateWithDay() {
    DateTime date = DateTime.now().toLocal();
    String weekDay = DateFormat.EEEE().format(date);
    String day = date.day.toString();
    String month = DateFormat.MMMM().format(date);
    String year = date.year.toString();
    String todayDate = '$weekDay, $day $month $year';

    return todayDate;
  }
}
