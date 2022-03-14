import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserSharedNotes {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserManagement _userManagement = UserManagement();
  final UserAuthentication _userAuthentication = UserAuthentication();
  String _userEmail = '';

  UserSharedNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  Future<void> addSharedNoteData(String documentID) async {
    try {
      // String noteID = '';
      // late DocumentReference noteRef;
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('id', isEqualTo: documentID)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          String noteID = value.docs.first.id;
          DocumentReference noteRef = _firestore
              .collection('notes')
              .doc(_userEmail)
              .collection('notes')
              .doc(noteID);

          _firestore.collection('shared_notes').add({
            'author': _userEmail,
            'note_id': documentID,
            'note': noteRef,
          });
        }
        // noteID = value.docs.first.id;
      });

      // DocumentReference noteRef = _firestore
      //     .collection('notes')
      //     .doc(_userEmail)
      //     .collection('notes')
      //     .doc(noteID);

      // await _firestore.collection('shared_notes').add({
      //   'author': _userEmail,
      //   'note_id': documentID,
      //   'note': noteRef,
      // });
    } on FirebaseException catch (e) {}
  }

  Future<void> addUsers(
      String email, String userAccess, String documentID) async {
    try {
      // String noteID = '';
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
          });
        }
        // noteID = value.docs.first.id;
      });

      // await _firestore
      //     .collection('shared_notes')
      //     .doc(noteID)
      //     .collection('user_with_access')
      //     .add({
      //   'user': email,
      //   'access': userAccess,
      // });
    } on FirebaseException catch (e) {}
  }

  Future<bool> _hasUserAlreadySharedTheNote(String documentID) async {
    bool hasNoteAlreadyShared = false;
    final sharedNote = await _firestore
        .collection('notes')
        .doc(_userEmail)
        .collection('shared')
        .doc()
        .collection('notes')
        .where('documentID', isEqualTo: documentID)
        .where('owner', isEqualTo: _userEmail)
        .get();

    if (sharedNote.docs.isNotEmpty) {
      hasNoteAlreadyShared = true;
    }

    return hasNoteAlreadyShared;
  }

  Future<bool> isNoteAlreadyBeenSharedWithUser(
      String documentID, String email) async {
    bool isNoteSharedWithUser = false;
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

      await _firestore.collection('shared_notes').doc(noteID);
    } on FirebaseException catch (e) {}

    return isNoteSharedWithUser;
  }
}
