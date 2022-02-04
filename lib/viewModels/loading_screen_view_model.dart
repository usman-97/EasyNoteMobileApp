import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/login_screen.dart';

class LoadingScreenViewModel {
  final UserAuthentication _userAuthentication = UserAuthentication();

  void appLoading(BuildContext context) {
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (_userAuthentication.getCurrentUser() == null) {
        Navigator.pushNamed(context, LoginScreen.id);
        // print('User has not been Signed in');
      } else {
        Navigator.pushNamed(context, HomeScreen.id);
        // print('User has been Signed in');
      }
    });
  }
}
