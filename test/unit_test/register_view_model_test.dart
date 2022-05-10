import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/viewModels/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:note_taking_app/viewModels/register_screen_view_model.dart';

Future<void> main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  // setUpAll(() async {
  //   await Firebase.initializeApp();
  // });

  test('Get today date', () {
    RegisterScreenViewModel registerViewModel = RegisterScreenViewModel();

    // Weak password
    registerViewModel.password = 'password';
    expect(registerViewModel.isPasswordStrong(), false);

    // Strong password with Uppercase letter, numbers and special characters
    registerViewModel.password = 'Password1!';
    expect(registerViewModel.isPasswordStrong(), true);
  });
}
