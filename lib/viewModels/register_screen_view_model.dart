import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> registerUser(
      String email, String password, String confirmPassword) async {
    if (email.isNotEmpty) {
      if (password.isNotEmpty && isPasswordStrong(password)) {
        if (isConfirmPasswordMatch(password, confirmPassword)) {
          bool isUserRegistered =
              await _userControl.registerUser(email: email, password: password);
          if (!isUserRegistered) {
            _error = 'Invalid Email/Password';
          } else {
            _error = '';
          }
        } else {
          _error = 'Password does not match.';
        }
      } else {
        _error =
            'Your password should contain 8 or more characters including at least an uppercase letter, a number and a special character (!£€^@)';
      }
    } else {
      _error = 'Invalid email';
    }
  }

  bool isConfirmPasswordMatch(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  bool isPasswordStrong(String password) {
    if (doesPasswordContainerUppercase(password) &&
        doesPasswordContainNumber(password) &&
        doesPasswordContainSymbol(password) &&
        password.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainerUppercase(String password) {
    RegExp uppercaseMatch = RegExp(r'[A-Z]');
    if (uppercaseMatch.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainNumber(String password) {
    RegExp findNumber = RegExp(r'[0-9]');
    if (findNumber.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainSymbol(String password) {
    RegExp findSymbol = RegExp(r'[!£€^&@]');
    if (findSymbol.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  String getRegistrationError() {
    return _error;
  }
}
