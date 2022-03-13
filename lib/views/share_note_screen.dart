import 'package:flutter/material.dart';

class ShareNoteScreen extends StatefulWidget {
  const ShareNoteScreen({Key? key}) : super(key: key);

  static const String id = 'share_note_screen';

  @override
  State<ShareNoteScreen> createState() => _ShareNoteScreenState();
}

class _ShareNoteScreenState extends State<ShareNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
