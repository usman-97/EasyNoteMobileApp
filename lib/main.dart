import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/views/create_note_screen.dart';
import 'package:note_taking_app/views/home_screen.dart';
import 'package:note_taking_app/views/login_screen.dart';
import 'package:note_taking_app/views/note_list_screen.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/views/verification_screen.dart';
import 'views/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
        CreateNoteScreen.id: (context) => CreateNoteScreen(
              cameraDescription: cameras[0],
            ),
      },
    );
  }
}
