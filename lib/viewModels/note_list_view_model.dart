import 'dart:async';

import 'package:flutter/material.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/utilities/custom_date.dart';
import 'package:note_taking_app/utilities/navigation.dart';
import 'package:note_taking_app/views/note_screen/create_note_screen.dart';
import 'package:note_taking_app/views/note_list_screen.dart';
import 'package:note_taking_app/views/share_note_screen.dart';
import '../models/note_storage.dart';
import '../models/user_shared_notes.dart';

class NoteListViewModel with ChangeNotifier {
  final UserNote _userNote = UserNote();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserSharedNotes _sharedUserNotes = UserSharedNotes();
  final NoteStorage _noteStorage = NoteStorage();
  final CustomDate _date = CustomDate();

  Stream<List<UserNoteData>> fetchAllUserNotes() {
    return _userNote.fetchAllUserNoteData();
  }

  List<NoteCard> buildUserNoteCards(
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    List<NoteCard> _userNoteCards = [];
    final notesData = snapshot.data;
    final String userAndAuthor = _userAuthentication.getCurrentUserEmail();

    for (var noteData in notesData) {
      String noteID = noteData.documentID;
      String noteTitle = noteData.noteTitle;
      String dateCreated =
          _date.getMediumFormatDate(customDate: noteData.dateCreated);
      String lastModified = _date.getLastModifiedDateTime(
          noteData.lastModified, noteData.lastModifiedTime);
      IconData status = getStatusIcon(noteData.status);
      // if (noteData.status == 'shared') {
      //   status = Icons.visibility_off_rounded;
      // }

      _userNoteCards.add(NoteCard(
        noteID: noteID,
        title: noteTitle,
        dateCreated: dateCreated,
        lastModified: lastModified,
        status: status,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateNoteScreen(
              isEditable: false,
              documentID: noteID,
              title: noteTitle,
              user: userAndAuthor,
              author: userAndAuthor,
            );
          }));
        },
        onShare: (context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ShareNoteScreen(
              noteID: noteID,
            );
          }));
        },
        onDelete: (context) async {
          await _userNote.deleteUserNote(noteID);
          await _noteStorage.deleteUserNoteFiles(noteID);
          bool isNoteShared = await _sharedUserNotes.isNotAlreadyShared(noteID);
          if (isNoteShared) {
            await _sharedUserNotes.deleteSharedNoteReference(noteID);
          }
        },
      ));
    }

    return _userNoteCards;
  }

  IconData getStatusIcon(String status) {
    IconData statusIcon = Icons.lock_rounded;
    if (status == 'shared') {
      statusIcon = Icons.share_rounded;
    }

    return statusIcon;
  }

  // void _deleteNote(String documentID) async {
  //   await _userNote.deleteUserNote(documentID);
  // }
}
