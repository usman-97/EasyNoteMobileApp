import 'package:intl/intl.dart';

class CustomDate {
  /// Get current date
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

  String getMediumFormatDate({String customDate = ''}) {
    DateTime now = customDate.isEmpty
        ? DateTime.now().toLocal()
        : getDateFromString(customDate);
    String month = DateFormat.MMM().format(now);
    String day = now.day.toString();
    String date = '$day $month';

    String year = now.year.toString();
    int currentYear = getCurrentYear();

    if (customDate.isNotEmpty && currentYear > int.parse(year)) {
      // String year = now.year.toString();
      date = '$date $year';
    }

    return date;
  }

  DateTime getDateFromString(String customDate) {
    List<String> customDateList = customDate.split('/');
    int year = int.parse(customDateList[2]);
    int months = int.parse(customDateList[1]);
    int day = int.parse(customDateList[0]);
    return DateTime(year, months, day);
  }

  String getTime() {
    DateTime now = DateTime.now().toLocal();
    String hour = now.hour.toString();
    String minute = now.minute.toString();
    String seconds = now.second.toString();

    String time = '$hour:$minute:$seconds';

    return time;
  }

  int getCurrentYear() {
    DateTime now = DateTime.now().toLocal();
    return now.year;
  }

  String getLastModifiedDateTime(String date, String time) {
    DateTime now = DateTime.now().toLocal();
    String noteLastModifiedDateTime = '';

    List<String> dateList = date.split('/');
    int day = int.parse(dateList[0]);
    int month = int.parse(dateList[1]);
    int year = int.parse(dateList[2]);

    List<String> timeList = time.split(':');
    int hour = int.parse(timeList[0]);
    int minutes = int.parse(timeList[1]);
    int seconds = int.parse(timeList[2]);

    bool isToday = this.isToday(date);
    if (isToday) {
      if (hour < now.hour) {
        int hourDifference = now.hour - hour;
        noteLastModifiedDateTime =
            hourDifference == 1 ? 'An hour ago' : '$hourDifference hours ago';
      } else if (minutes < now.minute) {
        int minuteDifference = now.minute - minutes;
        noteLastModifiedDateTime = minuteDifference == 1
            ? 'A minute ago'
            : '$minuteDifference minutes ago';
      } else {
        noteLastModifiedDateTime = 'Some seconds ago';
      }
    } else {
      if (year < now.year) {
        int yearDifference = now.year - year;
        noteLastModifiedDateTime =
            yearDifference == 1 ? 'A year ago' : '$yearDifference years ago';
      } else if (month < now.month) {
        int monthDifference = now.month - month;
        noteLastModifiedDateTime = monthDifference == 1
            ? 'A month ago'
            : '$monthDifference months ago';
      } else {
        int dayDifference = now.day - day;
        noteLastModifiedDateTime =
            dayDifference == 1 ? 'A day ago' : '$dayDifference days ago';
      }
    }

    return noteLastModifiedDateTime;
  }

  bool isToday(String date) {
    DateTime todayDate = DateTime.now().toLocal();
    bool isToday = false;

    List<String> dateList = date.split('/');
    int day = int.parse(dateList[0]);
    int month = int.parse(dateList[1]);
    int year = int.parse(dateList[2]);

    if (todayDate.year == year &&
        todayDate.month == month &&
        todayDate.day == day) {
      isToday = true;
    }

    return isToday;
  }
}
