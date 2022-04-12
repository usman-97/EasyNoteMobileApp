import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/user_sticky_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserStickyNotes {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  String _userEmail = '', _currentStickyNoteID = '';

  UserStickyNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  get currentStickyNoteID => _currentStickyNoteID;

  /// Add user sticky note data [noteTitle] and [date] to database
  Future<void> addUserStickyNote(String noteTitle, String date) async {
    _currentStickyNoteID = await _generateNewID();

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .add({
        'id': _currentStickyNoteID,
        'title': noteTitle,
        'date_created': date,
        'last_modified': date,
      });
    } on FirebaseException catch (e) {}
  }

  /// Generate new ID for new note in the database
  Future<String> _generateNewID() async {
    int lastIDNumber = await _getLastIDNumber();
    return 'StickyNote0${lastIDNumber + 1}';
  }

  /// Get the last number from the last note in the database
  Future<int> _getLastIDNumber() async {
    int lastIDNumber = 0;

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (final doc in value.docs) {
            String lastNoteID = doc.data()['id'];
            String lastNoteNumStr =
                lastNoteID.replaceAll(RegExp(r'[^0-9]'), '');
            int lastNoteNum = int.parse(lastNoteNumStr);
            if (lastNoteNum > lastIDNumber) {
              lastIDNumber = lastNoteNum;
            }
          }
        }
      });
    } on FirebaseException catch (e) {}

    return lastIDNumber;
  }

  /// Check if sticky note with [documentID] already exist
  Future<bool> isStickyNoteAlreadyExist(String documentID) async {
    bool isStickyNoteAlreadyExist = false;

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          isStickyNoteAlreadyExist = true;
        }
      });
    } on FirebaseException catch (e) {}

    return isStickyNoteAlreadyExist;
  }

  /// Update sticky note with [documentID] last modified date to [currentDate]
  Future<void> updateLastModified(String documentID, String currentDate) async {
    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .doc(documentID)
          .update({
        'last_modified': currentDate,
      });
    } on FirebaseException catch (e) {}
  }

  /// Update sticky note with [documentID] title to [newTitle]
  Future<void> updateNoteTitle(String documentID, String newTitle) async {
    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .doc(documentID)
          .update({
        'title': newTitle,
      });
    } on FirebaseException catch (e) {}
  }

  /// Fetch total number of user created sticky notes
  Future<int> fetchTotalStickyNotes() async {
    int totalStickyNotes = 0;

    try {
      await _firestore.collection('sticky_notes').get().then((value) {
        if (value.docs.isNotEmpty) {
          totalStickyNotes = value.docs.length;
        }
      });
    } on FirebaseException catch (e) {}

    return totalStickyNotes;
  }

  Stream<List<UserStickyNoteData>> fetchAllUserStickyNotes() {
    StreamController<List<UserStickyNoteData>> streamController =
        StreamController.broadcast();

    try {
      if (_userEmail.isNotEmpty) {
        _firestore
            .collection('notes')
            .doc(_userEmail)
            .collection('sticky_notes')
            .snapshots()
            .listen((event) {
          if (event.docs.isNotEmpty) {
            List<UserStickyNoteData> userStickyNoteList = event.docs
                .map((snapshot) => UserStickyNoteData.fromJson(snapshot.data()))
                .toList();
            streamController.add(userStickyNoteList);
          }
        });
      }
    } on FirebaseException catch (e) {}

    return streamController.stream;
  }

  Future<void> deleteStickyNoteCard(String noteID) async {
    CollectionReference stickyNoteColRef = _firestore
        .collection('notes')
        .doc(_userEmail)
        .collection('sticky_notes');
    try {
      await stickyNoteColRef
          .where('id', isEqualTo: noteID)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await stickyNoteColRef.doc(value.docs.first.id).delete();
        }
      });
    } on FirebaseException catch (e) {}
  }
}
