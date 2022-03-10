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

  void shareUserNote(String documentID, String otherUserEmail) async {
    // print('$documentID $otherUserEmail');

    bool doesUserExist = await _userManagement.doesUserExist(otherUserEmail);
    bool hasNoteAlreadyShared = await _hasUserAlreadySharedTheNote(documentID);

    if (doesUserExist && !hasNoteAlreadyShared) {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('shared')
          .doc()
          .collection('notes')
          .add({
        'document': documentID,
        'owner': _userEmail,
      });

      _firestore
          .collection('notes')
          .doc(otherUserEmail)
          .collection('shared')
          .doc()
          .collection('notes')
          .add({
        'document': documentID,
        'owner': _userEmail,
      });
    }
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
}
