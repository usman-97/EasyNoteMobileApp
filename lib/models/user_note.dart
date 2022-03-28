import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _currentNoteID = '';

  // StreamController to store all user notes
  final StreamController<List<UserNoteData>> _noteDataStreamController =
      StreamController.broadcast();

  UserNote() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  String get currentNoteID => _currentNoteID;

  /// Add note data to Firebase FireStore
  Future<void> addNote(String noteTitle, String date) async {
    // int totalNotes =
    //     await getTotalUserNotes(); // Fetch total number of created notes
    // String documentID = 'Note0${totalNotes + 1}';
    _currentNoteID = await generateNewNoteID();
    try {
      _firestore.collection('notes').doc(_userEmail).collection('notes').add({
        'id': _currentNoteID,
        'title': noteTitle,
        'date_created': date,
        'last_modified': date,
        'status': 'private',
      });
      int currentTotalNotes = await _note.fetchTotalNotes();
      await _note.updateTotalNotes(currentTotalNotes +
          1); // Update the total notes after adding new note to FireStore
    } on FirebaseException catch (e) {}
  }

  /// Generate new user note id
  Future<String> generateNewNoteID() async {
    int totalNotes =
        await getTotalUserNotes(); // Fetch total number of created notes
    return 'Note0${totalNotes + 1}';
  }

  /// Fetch total number of user created notes
  Future<int> getTotalUserNotes() async {
    int totalNotes = 0;

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String lastNoteID = value.docs.last.data()['id'];
          String lastNoteNumStr = lastNoteID.replaceAll(RegExp(r'[^0-9]'), '');
          totalNotes = int.parse(lastNoteNumStr);
        }
      });
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
              .map((snapshot) => UserNoteData.fromJson(snapshot.data()))
              .toList();
          _noteDataStreamController.add(noteData);
        }
      });
    } on FirebaseException catch (e) {}
    return _noteDataStreamController.stream;
  }

  Future<String> fetchNoteTitle(String documentID, {String email = ''}) async {
    if (email.isEmpty) {
      email = _userEmail;
    }

    String noteTitle = '';
    try {
      await _firestore
          .collection('notes')
          .doc(email)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((event) {
        if (event.docs.isNotEmpty) {
          noteTitle = event.docs.first.get('title');
        }
      });
    } on FirebaseException catch (e) {}

    return noteTitle;
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
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await _firestore
              .collection('notes')
              .doc(_userEmail)
              .collection('notes')
              .doc(value.docs.first.id)
              .delete();
        }
      });
      int totalNotes = await _note.fetchTotalNotes();
      if (totalNotes > 0) {
        await _note.updateTotalNotes(totalNotes - 1);
      }
    } on FirebaseException catch (e) {}
  }
}
