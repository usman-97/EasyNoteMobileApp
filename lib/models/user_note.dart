import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';
import '../services/firestore_cloud.dart';

class UserNote {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserManagement _userManagement = UserManagement();
  final Note _note = Note();
  late String _userEmail;

  // StreamController to store all user notes
  final StreamController<List<UserNoteData>> _noteDataStreamController =
      StreamController.broadcast();

  UserNote() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  /// Add note data to Firebase FireStore
  Future<void> addNote(String noteTitle, String date) async {
    int totalNotes =
        await _note.fetchTotalNotes(); // Fetch total number of created notes
    String documentID = 'Note0${totalNotes + 1}';
    try {
      _firestore.collection('notes').doc(_userEmail).collection('notes').add({
        'id': documentID,
        'title': noteTitle,
        'date_created': date,
        'last_modified': date,
        'status': 'private',
      });
      await _note.updateTotalNotes(totalNotes +
          1); // Update the total notes after adding new note to FireStore
    } on FirebaseException catch (e) {}
  }

  /// Fetch total number of user created notes
  Future<int> totalUserNotes() async {
    int totalNotes = 0;

    try {
      totalNotes = await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .snapshots()
          .length;
    } on FirebaseException catch (e) {}

    return totalNotes;
  }

  /// Fetch all user created notes from the database
  Stream<List<UserNoteData>> fetchAllUserNoteData() {
    List<UserNoteData> noteData;
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail.isNotEmpty ? _userEmail : ' ')
          .collection('notes')
          .snapshots()
          .listen((event) async {
        if (event.docs.isNotEmpty) {
          noteData = event.docs
              .map((snapshot) =>
                  UserNoteData.fromDocumentSnapshot(snapshot.data()))
              .toList();
          _noteDataStreamController.add(noteData);
        }
      });
    } on FirebaseException catch (e) {}
    return _noteDataStreamController.stream;
  }

  ///  Checks if given note exist in the database
  Future<bool> isNoteDocumentExist(String documentID) async {
    bool isDocExist = true;
    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          isDocExist = false;
        }
      });
      // isDocExist = notesDoc.exists;
    } on FirebaseException catch (e) {
      isDocExist = false;
    }
    return isDocExist;
  }

  // Future<void> updateNoteID(String oldDocumentID, String newDocumentID) async {
  //   final noteRef =
  //       _firestore.collection('notes').doc(_userEmail).collection('notes');
  //   try {
  //     await noteRef.where('id', isEqualTo: oldDocumentID).get().then((value) {
  //       if (value.docs.isNotEmpty) {
  //         noteRef.doc(value.docs.first.id).update({
  //           'id': newDocumentID,
  //         });
  //       }
  //     });
  //   } on FirebaseException catch (e) {}
  // }

  /// Update note title of [documentID], assign it with [newDocumentName]
  Future<void> updateNoteTitle(
      String documentID, String newDocumentName) async {
    final noteRef =
        _firestore.collection('notes').doc(_userEmail).collection('notes');
    try {
      await noteRef.where('id', isEqualTo: documentID).get().then((value) {
        if (value.docs.isNotEmpty) {
          noteRef.doc(value.docs.first.id).update({
            'title': newDocumentName,
          });
        }
      });
    } on FirebaseException catch (e) {}
  }

  /// Updates last modified date and time in the database
  Future<void> updateLastModified(String documentID, String date) async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (final value in value.docs) {
            _firestore
                .collection('notes')
                .doc(_userEmail)
                .collection('notes')
                .doc(value.id)
                .update({
              'last_modified': date,
            });
          }
        }
      });
    } on FirebaseException catch (e) {}
  }

  /// Delete user note which has [documentID]
  Future<void> deleteUserNote(String documentID) async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (final value in value.docs) {
            _firestore
                .collection('notes')
                .doc(_userEmail)
                .collection('notes')
                .doc(value.id)
                .delete();
          }
        }
      });
      int totalNotes = await _note.fetchTotalNotes();
      if (totalNotes > 0) {
        await _note.updateTotalNotes(totalNotes - 1);
      }
    } on FirebaseException catch (e) {}
  }
}
