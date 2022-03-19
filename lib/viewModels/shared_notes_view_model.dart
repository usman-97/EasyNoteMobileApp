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
  List<SharedNoteUsersData> _otherUsersSharedNotesDataList = [];

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
  List<SharedNoteUsersData> get otherUsersSharedNotesDataList =>
      _otherUsersSharedNotesDataList;

  Stream<List<UserNoteData>> getUserSharedNotes() {
    _sharedNotesController = _userSharedNotes.fetchUserSharedNotes();
    return _sharedNotesController.stream;
  }

  // Stream<List<SharedNoteUsersData>> getSharedNoteData() {
  //   _otherSharedNoteData = _userSharedNotes.fetchOtherSharedNotes();
  //   return _otherSharedNoteData.stream;
  // }

  Stream<List<UserNoteData>> getOtherSharedNotes() {
    _otherSharedNoteData = _userSharedNotes.fetchOtherSharedNotes();
    // return _otherSharedNoteData.stream;
    // if (_otherUsersSharedNotesDataList.isNotEmpty) {
    //   _otherUsersSharedNotesDataList.clear();
    // }
    _otherSharedNoteData.stream.listen((event) async {
      _otherUsersSharedNotesDataList = event;

      List<UserNoteData> sharedNotesList = [];
      if (event.isNotEmpty) {
        for (final note in event) {
          UserNoteData? userNoteData =
              await _userSharedNotes.fetchOtherUserSharedNote(note.noteRef);
          if (userNoteData != null) {
            sharedNotesList.add(userNoteData);
          }
        }
      }
      _otherUserSharedNotes.add(sharedNotesList);
    });

    return _otherUserSharedNotes.stream;
  }

  // Future<void> getOtherUserSharedNoteData() async {
  //   await _userSharedNotes.fetchOtherUserSharedNote();
  //   _otherUserSharedNotes = _userSharedNotes.otherUserSharedNotesController;
  //   // return _otherUserSharedNotes.stream;
  // }

  List<NoteCard> buildOtherUserSharedNotes(AsyncSnapshot<dynamic> snapshot) {
    List<NoteCard> otherUserSharedNotes = [];
    final noteData = snapshot.data;
    if (_otherUsersSharedNotesDataList.isNotEmpty) {
      for (int i = 0; i < noteData.length; i++) {
        otherUserSharedNotes.add(NoteCard(
          title: noteData[i].note_title,
          date_created: noteData[i].date_created,
          last_modified: noteData[i].last_modified,
          status: _otherUsersSharedNotesDataList[i].access,
          onTap: () {},
        ));
      }
    }

    return otherUserSharedNotes;
  }
}
