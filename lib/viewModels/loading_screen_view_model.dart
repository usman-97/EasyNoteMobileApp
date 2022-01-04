import 'package:flutter/material.dart';
import 'package:note_taking_app/views/login_screen.dart';

class LoadingScreenViewModel {
  void navigateToLoginScreen(BuildContext context) {
    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      Navigator.pushNamed(context, LoginScreen.id);
    });
  }
}
