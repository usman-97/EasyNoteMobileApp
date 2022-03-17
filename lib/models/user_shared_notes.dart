import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/shared_note_data.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

import 'data/shared_note_users_data.dart';

class UserSharedNotes {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserManagement _userManagement = UserManagement();
  final UserAuthentication _userAuthentication = UserAuthentication();
  String _userEmail = '';

  final StreamController<List<UserNoteData>> _sharedNotesController =
      StreamController.broadcast();
  final StreamController<List<SharedNoteUsersData>> _otherSharedNotesController =
      StreamController.broadcast();

  UserSharedNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  StreamController<List<UserNoteData>> get sharedNotesController =>
      _sharedNotesController;
  StreamController<List<SharedNoteUsersData>> get otherSharedNotesController =>
      _otherSharedNotesController;

  /// Add user shared note data to shared notes collection using
  /// notes [documentID]
  Future<void> addSharedNoteData(String documentID) async {
    try {
      // Get note id
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          // Get note reference
          DocumentReference noteRef = _firestore
              .collection('notes')
              .doc(_userEmail)
              .collection('notes')
              .doc(noteID);

          // Add note to shared_notes collection
          _firestore.collection('shared_notes').add({
            'author': _userEmail,
            'note_id': documentID,
            'note': noteRef,
          });
        }
      });
    } on FirebaseException catch (e) {}
  }

  /// Add user [email] which has access to shared note using note [documentID]
  /// Give user [userAccess] for the shared note.
  Future<void> addUsers(
      String email, String userAccess, String documentID) async {
    DocumentReference noteRef = await getNoteReference(documentID);
    try {
      await _firestore
          .collection('shared_notes')
          .where('note_id', isEqualTo: documentID)
          .where('author', isEqualTo: _userEmail)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          _firestore
              .collection('shared_notes')
              .doc(noteID)
              .collection('user_with_access')
              .add({
            'user': email,
            'access': userAccess,
            'note': noteRef,
          });
        }
      });
    } on FirebaseException catch (e) {}
  }

  Future<DocumentReference> getNoteReference(String documentID) async {
    DocumentReference noteRef = _firestore.collection('notes').doc(_userEmail);
    try {
      _firestore.collection('notes').doc(_userEmail).collection('notes').where('id', isEqualTo: documentID).snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          noteRef = _firestore.collection('notes').doc(_userEmail).collection('notes').doc(event.docs.first.id);
        }
      });
    }
    on FirebaseException catch(e){

    }

    return noteRef;
  }

  /// Update shared note [documentID] status from private to shared
  Future<void> updateNoteStatus(String documentID) async {
    try {
      final noteColRef =
          _firestore.collection('notes').doc(_userEmail).collection('notes');
      await noteColRef.where('id', isEqualTo: documentID).get().then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          noteColRef.doc(noteID).update({
            'status': 'shared',
          });
        }
      });
    } on FirebaseException catch (e) {}
  }

  // Future<bool> _hasUserAlreadySharedTheNote(String documentID) async {
  //   bool hasNoteAlreadyShared = false;
  //   final sharedNote = await _firestore
  //       .collection('notes')
  //       .doc(_userEmail)
  //       .collection('shared')
  //       .doc()
  //       .collection('notes')
  //       .where('documentID', isEqualTo: documentID)
  //       .where('owner', isEqualTo: _userEmail)
  //       .get();
  //
  //   if (sharedNote.docs.isNotEmpty) {
  //     hasNoteAlreadyShared = true;
  //   }
  //
  //   return hasNoteAlreadyShared;
  // }

  /// Check if note with [documentID] has already been shared with
  /// user who have [email] email.
  Future<bool> isNoteAlreadyBeenSharedWithUser(
      String documentID, String email) async {
    bool isNoteSharedWithUser = false;

    // Get shared note id
    try {
      String noteID = '';
      await _firestore
          .collection('shared_notes')
          .where('author', isEqualTo: _userEmail)
          .where('note_id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          noteID = value.docs.first.id;
        }
      });

      // Check if note has already been shared with user
      if (noteID.isNotEmpty) {
        await _firestore
            .collection('shared_notes')
            .doc(noteID)
            .collection('user_with_access')
            .where('user', isEqualTo: email)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            isNoteSharedWithUser = true;
          }
        });
      }
    } on FirebaseException catch (e) {}

    return isNoteSharedWithUser;
  }

  Future<void> fetchUserSharedNotes() async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('status', isEqualTo: 'shared')
          .snapshots()
          .listen((value) {
        if (value.docs.isNotEmpty) {
          List<UserNoteData> sharedNoteData = value.docs
              .map((snapshot) => UserNoteData.fromJson(snapshot.data()))
              .toList();
          _sharedNotesController.add(sharedNoteData);
        }
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> fetchOtherSharedNotes() async {
    try {
      _firestore.collection('shared_notes').snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          for (final doc in event.docs) {
            _firestore.collection('shared_notes').doc(doc.id).collection('user_with_access').where('user', isEqualTo: _userEmail).snapshots().listen((event) {
              if (event.docs.isNotEmpty) {
                List<SharedNoteUsersData> sharedNoteUserData = event.docs.map((snapshot) => SharedNoteUsersData.fromJson(snapshot.data())).toList();
                _otherSharedNotesController.add(sharedNoteUserData);
              }
            });
          }
        }
      });
    } on FirebaseException catch (e) {}
  }
}

// if (event.docs.isNotEmpty) {
// for (final doc in event.docs) {
// String userDocID = doc.id;
// _firestore
//     .collection('collectionPath')
//     .doc()
//     .collection('user_with_access')
//     .doc(userDocID)
//     .parent
//     .snapshots()
//     .listen((event) {
// if (event.docs.isNotEmpty) {
// List<UserNoteData> sharedNotesData = event.docs
//     .map((snapshot) => UserNoteData.fromJson(snapshot.data()))
//     .toList();
// _otherSharedNotesController.add(sharedNotesData);
// }
// });
// }
// }
