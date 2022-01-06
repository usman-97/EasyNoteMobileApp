import 'package:flutter/material.dart';
import 'package:note_taking_app/views/login_screen.dart';

class RegisterScreenViewModel {
  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.id);
  }
}
