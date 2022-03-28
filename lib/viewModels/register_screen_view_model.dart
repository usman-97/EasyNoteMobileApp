import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';

import '../models/note.dart';

class RegisterScreenViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserManagement _userManagement = UserManagement();
  late final Note _note = Note();
  String _error = '';
  bool _isRegistered = false;

  String email = '',
      password = '',
      confirmPassword = '',
      firstname = '',
      lastname = '';

  Future<void> registerUser() async {
    if (email.isNotEmpty) {
      if (password.isNotEmpty && isPasswordStrong()) {
        if (isConfirmPasswordMatch()) {
          bool isUserRegistered = await _userAuthentication.registerUser(
              email: email, password: password);
          if (!isUserRegistered) {
            _error = _userAuthentication.getUserErrorCode();
          } else {
            _isRegistered = true;
            await _note.addUserNoteInfo(email);
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
    await _userManagement.addUserData(email, firstname, lastname);
  }

  bool isConfirmPasswordMatch() {
    if (password == confirmPassword) {
      return true;
    } else {
      return false;
    }
  }

  bool isPasswordStrong() {
    if (doesPasswordContainsUppercase() &&
        doesPasswordContainNumber() &&
        doesPasswordContainSymbol() &&
        password.length >= 8) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainsUppercase() {
    RegExp uppercaseMatch = RegExp(r'[A-Z]');
    if (uppercaseMatch.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainNumber() {
    RegExp findNumber = RegExp(r'[0-9]');
    if (findNumber.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool doesPasswordContainSymbol() {
    RegExp findSymbol = RegExp(r'[!£€^&@]');
    if (findSymbol.firstMatch(password) != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isFirstNameValid() {
    if (firstname.isNotEmpty) {
      _error = '';
      return true;
    } else {
      _error = 'Please type your first name.';
      return false;
    }
  }

  bool isLastNameValid() {
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
