import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/home_screen.dart';
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

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, HomeScreen.id);
  }

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    if (email.isNotEmpty) {
      if (password.isNotEmpty) {
        bool isUserSignedIn =
            await _userAuthentication.signInUser(email, password);
        if (isUserSignedIn) {
          bool isUserEmailVerified =
              await _userAuthentication.isUserEmailVerified();
          // print(_userAuthentication.getCurrentUser()?.email);
          // if (isUserEmailVerified) {
          //   print('Email verified');
          // } else {
          //   print('Email not verified');
          // }
          _error = '';
          // Navigator.pushNamed(context, VerificationScreen.id);
          if (isUserEmailVerified) {
            navigateToHomeScreen(context);
          } else {
            await _userAuthentication.sendEmailVerification();
            Navigator.pushNamed(context, VerificationScreen.id);
          }
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

  Future<bool> isUserEmailVerified() async {
    return await _userAuthentication.isUserEmailVerified();
  }

  String getLoginError() {
    return _error;
  }
}
