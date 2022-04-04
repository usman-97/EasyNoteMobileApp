import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserStickyNotes {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  String _userEmail = '';

  UserStickyNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  Future<void> addUserStickyNote(String noteTitle, String date) async {
    String newStickyNoteID = await _generateNewID();

    try {
      await _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('sticky_notes')
          .add({
        'id': newStickyNoteID,
        'title': noteTitle,
        'date_created': date,
        'last_modified': date,
      });
    } on FirebaseException catch (e) {}
  }

  Future<String> _generateNewID() async {
    int lastIDNumber = await _getLastIDNumber();
    return 'StickyNote0${lastIDNumber + 1}';
  }

  Future<int> _getLastIDNumber() async {
    int lastIDNumber = 0;

    try {
      await _firestore.collection('sticky_notes').get().then((value) {
        if (value.docs.isNotEmpty) {
          String lastNoteID = value.docs.last.data()['id'];
          String lastNoteNumStr = lastNoteID.replaceAll(RegExp(r'[^0-9]'), '');
          lastIDNumber = int.parse(lastNoteNumStr);
        }
      });
    } on FirebaseException catch (e) {}

    return lastIDNumber;
  }

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
}
