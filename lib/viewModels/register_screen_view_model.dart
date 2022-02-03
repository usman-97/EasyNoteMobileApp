import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';

class RegisterScreenViewModel {
  late final UserAuthentication _userAuthentication;
  late final UserManagement _userManagement;
  late String _error;
  late bool _isRegistered;

  String _email = '',
      _password = '',
      _confirmPassword = '',
      _firstname = '',
      _lastname = '';

  RegisterScreenViewModel() {
    _userAuthentication = UserAuthentication();
    _userManagement = UserManagement();
    _error = '';
    _isRegistered = false;
  }

  Future<void> registerUser() async {
    if (_email.isNotEmpty) {
      if (_password.isNotEmpty && isPasswordStrong()) {
        if (isConfirmPasswordMatch()) {
          bool isUserRegistered = await _userAuthentication.registerUser(
              email: _email, password: _password);
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

  Future<void> addUserData() async {
    await _userManagement.addUserData(_email, _firstname, _lastname);
  }

  bool isConfirmPasswordMatch() {
    if (_password == _confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  bool isPasswordStrong() {
    if (doesPasswordContainerUppercase() &&
        doesPasswordContainNumber() &&
        doesPasswordContainSymbol() &&
        _password.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainerUppercase() {
    RegExp uppercaseMatch = RegExp(r'[A-Z]');
    if (uppercaseMatch.firstMatch(_password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainNumber() {
    RegExp findNumber = RegExp(r'[0-9]');
    if (findNumber.firstMatch(_password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainSymbol() {
    RegExp findSymbol = RegExp(r'[!£€^&@]');
    if (findSymbol.firstMatch(_password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isFirstNameValid() {
    if (_firstname.isNotEmpty) {
      _error = '';
      return true;
    } else {
      _error = 'Please type your first name.';
      return false;
    }
  }

  bool isLastNameValid() {
    if (_lastname.isNotEmpty) {
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

  String get email => _email;

  get password => _password;

  get confirmPassword => _confirmPassword;

  get firstname => _firstname;

  get lastname => _lastname;

  set lastname(value) {
    _lastname = value;
  }

  set firstname(value) {
    _firstname = value;
  }

  set confirmPassword(value) {
    _confirmPassword = value;
  }

  set password(value) {
    _password = value;
  }

  set email(String value) {
    _email = value;
  }
}
