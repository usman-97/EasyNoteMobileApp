import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import '../services/firestore_cloud.dart';

class UserNote {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final Note _noteFireStore = Note();
  late String _userEmail;

  UserNote() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  // Add note data to Firebase FireStore
  Future<void> addNote(String noteTitle, String date) async {
    // bool isDocExist = await _isNotesDocumentExist(noteTitle);
    int totalNotes = await _noteFireStore
        .fetchTotalNotes(); // Fetch total number of created notes
    String documentID = '$noteTitle${totalNotes + 1}';
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .doc(documentID)
          .set({
        'id': documentID,
        'title': noteTitle,
        'date_created': date,
        'last_modified': date,
        'status': 'private',
      });
      await _noteFireStore
          .updateTotalNotes(); // Update the total notes after adding new note to FireStore
    } on FirebaseException catch (e) {}
  }

  // Checks if given note exist in the database
  Future<bool> isNotesDocumentExist(String documentID) async {
    bool isDocExist = true;
    try {
      var notesCollectionRef =
          _firestore.collection('notes').doc(_userEmail).collection('notes');
      var notesDoc = await notesCollectionRef.doc(documentID).get();
      isDocExist = notesDoc.exists;
    } on FirebaseException catch (e) {
      isDocExist = false;
    }
    return isDocExist;
  }

  // Updates last modified date and time in the database
  Future<void> updateLastModified(String documentID, String date) async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .doc(documentID)
          .update({
        'last_modified': date,
      });
    } on FirebaseException catch (e) {}
  }

  Future<Map<String, dynamic>?> fetchAllUserNoteData() async {
    Map<String, dynamic>? dataSet;
    try {
      await for (var snapshot in _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .snapshots()) {
        for (var noteData in snapshot.docs) {
          dataSet = UserNoteData(noteData) as Map<String, dynamic>?;
        }
      }
    } on FirebaseException catch (e) {}
    return dataSet;
  }
}