import 'package:flutter/material.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/login_screen.dart';
import 'package:note_taking_app/views/note_list_screen.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/views/verification_screen.dart';

class Navigation {
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, HomeScreen.id);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.id);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, RegisterScreen.id);
  }

  static void navigateToVerification(BuildContext context) {
    Navigator.pushNamed(context, VerificationScreen.id);
  }

  static void navigateToNoteList(BuildContext context) {
    Navigator.pushNamed(context, NoteListScreen.id);
  }
}
