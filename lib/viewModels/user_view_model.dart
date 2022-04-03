import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';

class UserViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserManagement _userManagement = UserManagement();

  Future<String> getUserFullName() {
    return _userManagement.fetchUserFullName();
  }

  void signOutUser() {
    _userAuthentication.signOutUser();
  }
}
