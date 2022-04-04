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
import 'views/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const EasyNote());
}

class EasyNote extends StatelessWidget {
  const EasyNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF388E3c),
        ),
      ),
      // home: const LoadingScreen(),
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => const LoadingScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        VerificationScreen.id: (context) => const VerificationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        NoteListScreen.id: (context) => const NoteListScreen(),
        CreateNoteScreen.id: (context) => const CreateNoteScreen(),
        CreateStickyNoteScreen.id: (context) => const CreateStickyNoteScreen(),
        SearchNoteScreen.id: (context) => const SearchNoteScreen(),
        SharedNoteScreen.id: (context) => const SharedNoteScreen(),
        ShareNoteScreen.id: (context) => const ShareNoteScreen(),
        NotificationsScreen.id: (context) => const NotificationsScreen(),
      },
    );
  }
}
