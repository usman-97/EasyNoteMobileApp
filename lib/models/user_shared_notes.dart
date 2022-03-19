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
  final StreamController<List<SharedNoteUsersData>>
      _otherSharedNotesController = StreamController.broadcast();
  final StreamController<List<UserNoteData>> _otherUserSharedNotesController =
      StreamController.broadcast();

  UserSharedNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  StreamController<List<UserNoteData>> get sharedNotesController =>
      _sharedNotesController;
  StreamController<List<SharedNoteUsersData>> get otherSharedNotesController =>
      _otherSharedNotesController;
  StreamController<List<UserNoteData>> get otherUserSharedNotesController =>
      _otherUserSharedNotesController;

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
    late DocumentReference noteRef;
    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((event) {
        if (event.docs.isNotEmpty) {
          noteRef = _firestore
              .collection('notes')
              .doc(_userEmail)
              .collection('notes')
              .doc(event.docs.first.id);
        }
      });
    } on FirebaseException catch (e) {}

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

  StreamController<List<UserNoteData>> fetchUserSharedNotes() {
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

    return _sharedNotesController;
  }

  StreamController<List<SharedNoteUsersData>> fetchOtherSharedNotes() {
    // List<SharedNoteUsersData> sharedNoteUserData = [];
    try {
      _firestore.collection('shared_notes').snapshots().listen((event) async {
        // print(event.docs.length);
        if (event.docs.isNotEmpty) {
          List<SharedNoteUsersData> sharedNoteUserData = [];
          for (final doc in event.docs) {
            await _firestore
                .collection('shared_notes')
                .doc(doc.id)
                .collection('user_with_access')
                .where('user', isEqualTo: _userEmail)
                .get()
                .then((event) {
              // print(event.docs.length);
              if (event.docs.isNotEmpty) {
                sharedNoteUserData.add(
                    SharedNoteUsersData.fromDocumentSnapshot(event.docs.first));
              }
            });
          }
          _otherSharedNotesController.add(sharedNoteUserData);
        }
      });
    } on FirebaseException catch (e) {}

    // print(sharedNoteUserData.length);
    // return sharedNoteUserData;
    return _otherSharedNotesController;
  }

  Future<UserNoteData?> fetchOtherUserSharedNote(
      DocumentReference noteRef) async {
    UserNoteData? userNoteData;
    try {
      await noteRef.get().then((event) {
        if (event.exists) {
          userNoteData = UserNoteData.fromDocumentSnapshot(event);
        }
      });
    } on FirebaseException catch (e) {}

    return userNoteData;
  }
}
