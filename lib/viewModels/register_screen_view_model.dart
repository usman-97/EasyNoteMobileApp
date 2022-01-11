import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/login_screen.dart';

class RegisterScreenViewModel {
  late final UserAuthentication _userControl;
  late String _error;

  RegisterScreenViewModel() {
    _userControl = UserAuthentication();
    _error = '';
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.id);
  }

  bool _isEmailValid({required String email}) {
    if (email.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> registerUser(
      {required String email, required String password}) async {
    if (_isEmailValid(email: email)) {
      bool isUserRegistered =
          await _userControl.registerUser(email: email, password: password);
      if (!isUserRegistered) {
        _error = 'Invalid Email/Password';
      }
    }
  }

  String getRegistrationError() {
    return _error;
  }
}
