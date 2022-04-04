import 'package:flutter/material.dart';
import 'package:note_taking_app/views/note_screen/create_note_screen.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/login_screen.dart';
import 'package:note_taking_app/views/note_list_screen.dart';
import 'package:note_taking_app/views/note_screen/create_sticky_note_screen.dart';
import 'package:note_taking_app/views/notifications_screen.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/views/search_notes_screen.dart';
import 'package:note_taking_app/views/share_note_screen.dart';
import 'package:note_taking_app/views/shared_notes_screen.dart';
import 'package:note_taking_app/views/verification_screen.dart';

class Navigation {
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamed(context, HomeScreen.id);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.popAndPushNamed(context, LoginScreen.id);
  }

  static void navigateToRegister(BuildContext context) {
    Navigator.popAndPushNamed(context, RegisterScreen.id);
  }

  static void navigateToVerification(BuildContext context) {
    Navigator.popAndPushNamed(context, VerificationScreen.id);
  }

  static void navigateToNoteList(BuildContext context) {
    Navigator.pushNamed(context, NoteListScreen.id);
  }

  static void navigateToCreateNote(BuildContext context) {
    Navigator.popAndPushNamed(context, CreateNoteScreen.id);
  }

  static void navigateToSearchNotesScreen(BuildContext context) {
    Navigator.pushNamed(context, SearchNoteScreen.id);
  }

  static void navigateToSharedNotesScreen(BuildContext context) {
    Navigator.pushNamed(context, SharedNoteScreen.id);
  }

  static void navigateToShareNoteScreen(BuildContext context) {
    Navigator.pushNamed(context, ShareNoteScreen.id);
  }

  static void navigateToNotificationsScreen(BuildContext context) {
    Navigator.pushNamed(context, NotificationsScreen.id);
  }

  static void navigateToCreateStickyNoteScreen(BuildContext context) {
    Navigator.pushNamed(context, CreateStickyNoteScreen.id);
  }
}
