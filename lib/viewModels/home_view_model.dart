import 'package:note_taking_app/models/user_management.dart';
import 'package:intl/intl.dart';

class HomeViewModel {
  final UserManagement _userManagement = UserManagement();
  String _userFirstname = '';

  get userFirstname => _userFirstname;

  Stream<String> setUserFirstName() {
    return _userManagement.fetchCurrentUserFirstname();
  }

  String getTodayData() {
    DateTime date = DateTime.now().toLocal();
    String weekDay = DateFormat.EEEE().format(date);
    String day = date.day.toString();
    String month = DateFormat.MMMM().format(date);
    String year = date.year.toString();
    String todayDate = '$weekDay, $day $month $year';

    return todayDate;
  }
}
