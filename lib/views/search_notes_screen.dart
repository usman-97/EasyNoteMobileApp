import 'package:flutter/material.dart';
import 'package:note_taking_app/utilities/constants.dart';

class SearchNoteScreen extends StatefulWidget {
  static const String id = 'search_note_screen';

  const SearchNoteScreen({Key? key}) : super(key: key);

  @override
  _SearchNoteScreenState createState() => _SearchNoteScreenState();
}

class _SearchNoteScreenState extends State<SearchNoteScreen> {
  final TextEditingController _searchTextFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: kTextIconColour,
            size: 30.0,
          ),
        ),
        title: TextField(
          controller: _searchTextFieldController,
          style: kAppBarTextFieldStyle.copyWith(color: kTextIconColour),
          decoration: kNoteTitleInputDecoration.copyWith(
            hintText: 'Search ...',
            hintStyle: const TextStyle(color: kTextIconColour),
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {},
              child: const Icon(
                Icons.search_rounded,
                color: kTextIconColour,
                size: 40.0,
              ))
        ],
      ),
    );
  }
}
