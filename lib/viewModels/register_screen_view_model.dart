import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';

class RegisterScreenViewModel {
  late final UserAuthentication _userAuthentication;
  late final UserManagement _userManagement;
  late String _error;
  late bool _isRegistered;

  RegisterScreenViewModel() {
    _userAuthentication = UserAuthentication();
    _userManagement = UserManagement();
    _error = '';
    _isRegistered = false;
  }

  Future<void> registerUser(
      String email, String password, String confirmPassword) async {
    if (email.isNotEmpty) {
      if (password.isNotEmpty && isPasswordStrong(password)) {
        if (isConfirmPasswordMatch(password, confirmPassword)) {
          bool isUserRegistered = await _userAuthentication.registerUser(
              email: email, password: password);
          if (!isUserRegistered) {
            _error = _userAuthentication.getUserErrorCode();
          } else {
            _isRegistered = true;
            await _userAuthentication.sendEmailVerification();
            _error = '';
          }
        } else {
          _error = 'Password does not match.';
        }
      } else {
        _error =
            'Your password should contain 8 or more characters including at least one uppercase letter, a number and a special character (!£€^@)';
      }
    } else {
      _error = 'Invalid email';
    }
  }

  Future<void> addUserData(
      String email, String firstname, String lastname) async {
    await _userManagement.addUserData(email, firstname, lastname);
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

  bool isFirstNameValid(String firstname) {
    if (firstname.isNotEmpty) {
      _error = '';
      return true;
    } else {
      _error = 'Please type your first name.';
      return false;
    }
  }

  bool isLastNameValid(String lastname) {
    if (lastname.isNotEmpty) {
      _error = '';
      return true;
    } else {
      _error = 'Please type your last name';
      return false;
    }
  }

  String getRegistrationError() {
    return _error;
  }

  bool isUserRegistered() {
    return _isRegistered;
  }
}
