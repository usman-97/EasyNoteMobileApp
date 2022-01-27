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
    if (email.isNotEmpty) {
      if (password.isNotEmpty) {
        bool isUserSignedIn =
            await _userAuthentication.signInUser(email, password);
        if (isUserSignedIn) {
          bool isUserEmailVerified =
              await _userAuthentication.isUserEmailVerified(email);
          // print(_userAuthentication.getCurrentUser()?.email);
          // if (isUserEmailVerified) {
          //   print('Email verified');
          // } else {
          //   print('Email not verified');
          // }
          _error = '';
          Navigator.pushNamed(context, VerificationScreen.id);
        } else {
          _error = 'Invalid email/password.';
        }
      } else {
        _error = 'Password is not correct';
      }
    } else {
      _error = 'Invalid email';
    }
    // print(_error);
  }

  String getLoginError() {
    return _error;
  }
}
