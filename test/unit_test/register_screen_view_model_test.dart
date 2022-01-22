import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/viewModels/register_screen_view_model.dart';

void main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  group('Password', () {
    RegisterScreenViewModel registerScreenViewModel = RegisterScreenViewModel();
    const String weakPassword = 'password';

    // setUpAll(() async {
    //   await Firebase.initializeApp();
    // });

    test('check if password contain an uppercase letter', () {
      const String strongPassword = 'Password';

      expect(
          registerScreenViewModel.doesPasswordContainerUppercase(weakPassword),
          false);
      expect(
          registerScreenViewModel
              .doesPasswordContainerUppercase(strongPassword),
          true);
    });

    test('check if password contain a number', () {
      const String strongPassword = 'pas5word';

      expect(registerScreenViewModel.doesPasswordContainNumber(weakPassword),
          false);
      expect(registerScreenViewModel.doesPasswordContainNumber(strongPassword),
          true);
    });

    test('check if password contain a special character', () {
      const String strongPassword = 'pass!word';

      expect(registerScreenViewModel.doesPasswordContainSymbol(weakPassword),
          false);
      expect(registerScreenViewModel.doesPasswordContainSymbol(strongPassword),
          true);
    });

    test('check if user password is strong', () {
      const String strongPassword = 'Pass5word@';

      expect(registerScreenViewModel.isPasswordStrong(weakPassword), false);
      expect(registerScreenViewModel.isPasswordStrong(strongPassword), true);
    });
  });
}
