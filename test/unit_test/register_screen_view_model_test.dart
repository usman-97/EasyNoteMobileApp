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

      registerScreenViewModel.password = weakPassword;
      expect(registerScreenViewModel.doesPasswordContainerUppercase(), false);

      registerScreenViewModel.password = strongPassword;
      expect(registerScreenViewModel.doesPasswordContainerUppercase(), true);
    });

    test('check if password contain a number', () {
      const String strongPassword = 'pas5word';

      registerScreenViewModel.password = weakPassword;
      expect(registerScreenViewModel.doesPasswordContainNumber(), false);

      registerScreenViewModel.password = strongPassword;
      expect(registerScreenViewModel.doesPasswordContainNumber(), true);
    });

    test('check if password contain a special character', () {
      const String strongPassword = 'pass!word';

      registerScreenViewModel.password = weakPassword;
      expect(registerScreenViewModel.doesPasswordContainSymbol(), false);

      registerScreenViewModel.password = strongPassword;
      expect(registerScreenViewModel.doesPasswordContainSymbol(), true);
    });

    test('check if user password is strong', () {
      const String strongPassword = 'Pass5word@';

      registerScreenViewModel.password = weakPassword;
      expect(registerScreenViewModel.isPasswordStrong(), false);

      registerScreenViewModel.password = strongPassword;
      expect(registerScreenViewModel.isPasswordStrong(), true);
    });
  });
}
