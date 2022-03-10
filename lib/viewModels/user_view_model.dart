import 'package:note_taking_app/models/user_authentication.dart';

class UserViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();

  void signOutUser() {
    _userAuthentication.signOutUser();
  }
}
