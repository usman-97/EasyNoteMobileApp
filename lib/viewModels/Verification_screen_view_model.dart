import 'package:note_taking_app/models/user_authentication.dart';

class VerificationScreenViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();

  String getCurrentUserEmail() {
    // var currentUser = _userAuthentication.getCurrentUser();
    // String userEmail = '';
    // if (currentUser != null) {
    //   userEmail = currentUser.email!;
    // }
    // return userEmail;
    return _userAuthentication.getCurrentUserEmail();
  }
}
