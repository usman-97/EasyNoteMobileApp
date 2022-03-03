import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/noteCard.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/views/create_note_screen.dart';

class NoteListViewModel with ChangeNotifier {
  final UserNote _userNote = UserNote();

  Stream<List<UserNoteData>> fetchAllUserNotes() {
    return _userNote.fetchAllUserNoteData();
  }

  List<NoteCard> buildUserNoteCards(
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
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
      ));
    }

    return _userNoteCards;
  }
}
