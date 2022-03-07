import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/views/verification_screen.dart';
import 'package:note_taking_app/utilities/navigation.dart';

class LoginScreenViewModel {
  late final UserAuthentication _userAuthentication;
  late String _error;
  String email = '', password = '';

  LoginScreenViewModel() {
    _userAuthentication = UserAuthentication();
    _error = '';
  }

  Future<void> loginUser(BuildContext context) async {
    if (email.isNotEmpty) {
      if (password.isNotEmpty) {
        bool isUserSignedIn =
            await _userAuthentication.signInUser(email, password);
        if (isUserSignedIn) {
          bool isUserEmailVerified =
              await _userAuthentication.isUserEmailVerified();
          _error = '';
          if (isUserEmailVerified) {
            Navigation.navigateToHome(context);
          } else {
            await _userAuthentication.sendEmailVerification();
            Navigation.navigateToVerification(context);
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
  }

  Future<bool> isUserEmailVerified() async {
    return await _userAuthentication.isUserEmailVerified();
  }

  String getLoginError() {
    return _error;
  }
}
