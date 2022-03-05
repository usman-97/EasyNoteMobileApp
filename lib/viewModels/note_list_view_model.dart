import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/views/create_note_screen.dart';

import '../components/note_pop_up_menu.dart';

class NoteListViewModel with ChangeNotifier {
  final UserNote _userNote = UserNote();
  final List<DropdownMenuItem<String>> _cardMenuOptions = [
    DropdownMenuItem(
      value: 'Share',
      child: GestureDetector(
        onTap: () {
          print('share');
        },
        child: const Text('Share'),
      ),
    ),
    DropdownMenuItem(
      value: 'Delete',
      child: GestureDetector(
        onTap: () {
          print('delete');
        },
        child: const Text('Delete'),
      ),
    ),
  ];
  String noteMenuValue = 'Share';

  List<DropdownMenuItem<String>> get cardMenuOptions => _cardMenuOptions;

  Stream<List<UserNoteData>> fetchAllUserNotes() {
    return _userNote.fetchAllUserNoteData();
  }

  List<NoteCard> buildUserNoteCards(
      AsyncSnapshot<dynamic> snapshot, BuildContext context,
      {required NotePopUpMenu popupMenuButton}) {
    List<NoteCard> _userNoteCards = [];
    final notesData = snapshot.data;

    for (var noteData in notesData) {
      _userNoteCards.add(NoteCard(
        title: noteData.note_title,
        date_created: noteData.date_created,
        last_modified: noteData.last_modified,
        status: noteData.status,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateNoteScreen(
              isEditable: false,
              documentID: noteData.documentID,
              title: noteData.note_title,
            );
          }));
        },
        notePopUpMenu: popupMenuButton,
      ));
    }

    return _userNoteCards;
  }
}
