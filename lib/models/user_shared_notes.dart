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
  String _userEmail = '', _error = '';

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
  get error => _error;

  /// Add user shared note data to shared notes collection using
  /// notes [documentID]
  Future<void> addSharedNoteData(String documentID, String author) async {
    try {
      // Get note id
      await _firestore
          .collection('notes')
          .doc(author)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          // Get note reference
          DocumentReference noteRef = _firestore
              .collection('notes')
              .doc(author)
              .collection('notes')
              .doc(noteID);

          // Add note to shared_notes collection
          _firestore.collection('shared_notes').add({
            'author': author,
            'note_id': documentID,
            'note': noteRef,
          });
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }
  }

  /// Add user [email] which has access to shared note using note [documentID]
  /// Give user [userAccess] for the shared note.
  Future<void> addUsers(
      String email, String userAccess, String documentID) async {
    DocumentReference noteRef = await getNoteReference(documentID, email);
    try {
      await _firestore
          .collection('shared_notes')
          .where('note_id', isEqualTo: documentID)
          .where('author', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          _firestore
              .collection('shared_notes')
              .doc(noteID)
              .collection('user_with_access')
              .add({
            'user': _userEmail,
            'access': userAccess,
            'note': noteRef,
          });
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }
  }

  /// Gets note document by [documentID] reference
  Future<DocumentReference> getNoteReference(
      String documentID, String email) async {
    DocumentReference noteRef = _firestore.collection('notes').doc(email);
    try {
      await _firestore
          .collection('notes')
          .doc(email)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((event) {
        if (event.docs.isNotEmpty) {
          noteRef = _firestore
              .collection('notes')
              .doc(email)
              .collection('notes')
              .doc(event.docs.first.id);
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return noteRef;
  }

  /// Update shared note [documentID] status from private to shared
  Future<void> updateNoteStatus(String documentID, String author) async {
    try {
      final noteColRef =
          _firestore.collection('notes').doc(author).collection('notes');
      await noteColRef.where('id', isEqualTo: documentID).get().then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          noteColRef.doc(noteID).update({
            'status': 'shared',
          });
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }
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
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return isNoteSharedWithUser;
  }

  /// Fetch all user shared notes to other users
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
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return _sharedNotesController;
  }

  /// Fetch all shared notes which were shared by other users with current user
  StreamController<List<SharedNoteUsersData>> fetchOtherSharedNotes() {
    try {
      // Get all documents in shared notes collection
      _firestore.collection('shared_notes').snapshots().listen((event) async {
        if (event.docs.isNotEmpty) {
          List<SharedNoteUsersData> sharedNoteUserData = [];
          for (final doc in event.docs) {
            // Fetch the notes which were shared with current user
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
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return _otherSharedNotesController;
  }

  /// Fetch the note document with [noteRef] reference
  /// use reference to fetch the note from the database
  Future<UserNoteData?> fetchOtherUserSharedNote(
      DocumentReference noteRef) async {
    UserNoteData? userNoteData;
    try {
      await noteRef.get().then((event) {
        if (event.exists) {
          userNoteData = UserNoteData.fromDocumentSnapshot(event);
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return userNoteData;
  }

  /// Get the shared note author name with [email]
  Future<String> fetchSharedNoteAuthorFullName(String? email) async {
    String fullname = '';
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await _firestore
              .collection('users')
              .doc(value.docs.first.id)
              .get()
              .then((value) {
            // print(value.get('firstname'));
            fullname = '${value.get('firstname')} ${value.get('lastname')}';
          });
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }
    // print(fullname);

    return fullname;
  }
}
