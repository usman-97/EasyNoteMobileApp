import 'package:flutter/material.dart';
import 'package:note_taking_app/views/note_screen/note_screen.dart';
import 'package:note_taking_app/views/note_screen/note_screen_interface.dart';

class CreateStickyNoteScreen extends StatefulWidget {
  const CreateStickyNoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateStickyNoteScreen> createState() => _CreateStickyNoteScreenState();
}

class _CreateStickyNoteScreenState extends State<CreateStickyNoteScreen>
    implements INoteScreen {
  @override
  void loadDoc(String filename) {
    // TODO: implement loadFile
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
