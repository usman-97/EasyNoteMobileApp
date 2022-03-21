import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/views/create_note_screen.dart';
import 'package:note_taking_app/views/share_note_screen.dart';
import '../models/user_shared_notes.dart';

class NoteListViewModel with ChangeNotifier {
  final UserNote _userNote = UserNote();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserSharedNotes _sharedUserNotes = UserSharedNotes();

  Stream<List<UserNoteData>> fetchAllUserNotes() {
    return _userNote.fetchAllUserNoteData();
  }

  List<NoteCard> buildUserNoteCards(
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    List<NoteCard> _userNoteCards = [];
    final notesData = snapshot.data;
    final String userAndAuthor = _userAuthentication.getCurrentUserEmail();

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
              user: userAndAuthor,
              author: userAndAuthor,
            );
          }));
        },
        onShare: (context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ShareNoteScreen(
              noteID: noteData.documentID,
            );
          }));
        },
        onDelete: (context) {},
      ));
    }

    return _userNoteCards;
  }

  void _deleteNote(String documentID) async {
    await _userNote.deleteUserNote(documentID);
  }
}
