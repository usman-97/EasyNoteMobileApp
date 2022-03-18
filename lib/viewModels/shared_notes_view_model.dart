import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/models/data/shared_note_data.dart';
import 'package:note_taking_app/models/data/shared_note_users_data.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_shared_notes.dart';

class SharedNotesViewModel {
  final UserSharedNotes _userSharedNotes = UserSharedNotes();
  StreamController<List<UserNoteData>> _sharedNotesController =
      StreamController.broadcast();
  StreamController<List<SharedNoteUsersData>> _otherSharedNoteData =
      StreamController.broadcast();
  StreamController<List<UserNoteData>> _otherUserSharedNotes =
      StreamController.broadcast();

  SharedNotesViewModel() {
    _sharedNotesController = _userSharedNotes.sharedNotesController;
    _otherSharedNoteData = _userSharedNotes.otherSharedNotesController;
  }

  StreamController<List<UserNoteData>> get sharedNotesController =>
      _sharedNotesController;
  StreamController<List<SharedNoteUsersData>> get otherSharedNoteData =>
      _otherSharedNoteData;
  StreamController<List<UserNoteData>> get otherUserSharedNotes =>
      _otherUserSharedNotes;

  void getUserSharedNotes() async {
    await _userSharedNotes.fetchUserSharedNotes();
  }

  Stream<List<SharedNoteUsersData>> getOtherSharedNotes() {
    _otherSharedNoteData = _userSharedNotes.fetchOtherSharedNotes();
    return _otherSharedNoteData.stream;
  }

  Stream<List<UserNoteData>> getOtherUserSharedNoteData(
      List<SharedNoteUsersData> data) {
    _otherUserSharedNotes = _userSharedNotes.fetchOtherUserSharedNote(data);
    return _otherUserSharedNotes.stream;
  }

  List<NoteCard> getOtherSharedNote(AsyncSnapshot<dynamic> snapshot) {
    List<NoteCard> otherUserSharedNotes = [];
    final noteData = snapshot.data;
    for (final note in noteData) {
      otherUserSharedNotes.add(NoteCard(
          title: note.note_title,
          date_created: note.date_created,
          last_modified: note.last_modified,
          status: note.status,
          onTap: () {}));
    }

    // return NoteCard(
    //     title: userNoteData.note_title,
    //     date_created: userNoteData.date_created,
    //     last_modified: userNoteData.last_modified,
    //     status: userNoteData.status,
    //     onTap: () {});

    return otherUserSharedNotes;
  }
}
