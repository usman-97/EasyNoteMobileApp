import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/login_screen.dart';

class LoadingScreenViewModel {
  UserAuthentication _userAuthentication = UserAuthentication();

  void appLoading(BuildContext context) {
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      bool isUserSignedIn = _userAuthentication.isUserAlreadySignedIn();
      if (isUserSignedIn) {
        Navigator.pushNamed(context, HomeScreen.id);
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    });
  }
}
