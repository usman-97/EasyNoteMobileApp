import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/views/verification_screen.dart';

class LoginScreenViewModel {
  late final UserAuthentication _userAuthentication;
  late String _error;

  LoginScreenViewModel() {
    _userAuthentication = UserAuthentication();
    _error = '';
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, RegisterScreen.id);
  }

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    bool isUserSignedIn = await _userAuthentication.signInUser(email, password);
    if (isUserSignedIn) {
      Navigator.pushNamed(context, VerificationScreen.id);
    } else {
      print(isUserSignedIn);
    }
  }

  String getLoginError() {
    return _error;
  }
}
