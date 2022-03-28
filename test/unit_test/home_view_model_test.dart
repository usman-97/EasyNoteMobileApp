import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/viewModels/home_view_model.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  // setUpAll(() async {
  //   await Firebase.initializeApp();
  // });

  test('Get today date', () {
    HomeViewModel homeViewModel = HomeViewModel();

    DateTime date = DateTime.now().toLocal();
    String weekDay = DateFormat.EEEE().format(date);
    String day = date.day.toString();
    String month = DateFormat.MMMM().format(date);
    String year = date.year.toString();
    String todayDate = '$weekDay, $day $month $year';

    expect(homeViewModel.getTodayData(), todayDate);
  });
}
