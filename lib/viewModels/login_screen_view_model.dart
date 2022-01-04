import 'package:flutter/material.dart';
import 'package:note_taking_app/views/register_screen.dart';

class LoginScreenViewModel {
  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, RegisterScreen.id);
  }
}
