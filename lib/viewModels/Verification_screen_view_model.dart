import 'package:note_taking_app/models/user_authentication.dart';

class VerificationScreenViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();

  String getCurrentUserEmail() {
    return _userAuthentication.getCurrentUserEmail();
  }

  Future<void> sendUserEmailVerification() async {
    await _userAuthentication.sendEmailVerification();
  }
}
