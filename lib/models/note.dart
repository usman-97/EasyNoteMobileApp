import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class Note {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  late String _userEmail;

  Note() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  // Add note data to Firebase FireStore
  // Future<void> addNote(String noteTitle, String date) async {
  //   // bool isDocExist = await _isNotesDocumentExist(noteTitle);
  //   int totalNotes =
  //       await fetchTotalNotes(); // Fetch total number of created notes
  //   String documentID = '$noteTitle${totalNotes + 1}';
  //   try {
  //     _firestore
  //         .collection('notes')
  //         .doc(_userEmail)
  //         .collection('notes')
  //         .doc(documentID)
  //         .set({
  //       'id': documentID,
  //       'title': noteTitle,
  //       'date_created': date,
  //       'last_modified': date,
  //       'status': 'private',
  //     });
  //     await updateTotalNotes(); // Update the total notes after adding new note to FireStore
  //   } on FirebaseException catch (e) {}
  // }
  //
  // // Checks if given note exist in the database
  // Future<bool> isNotesDocumentExist(String documentID) async {
  //   bool isDocExist = true;
  //   try {
  //     var notesCollectionRef =
  //         _firestore.collection('notes').doc(_userEmail).collection('notes');
  //     var notesDoc = await notesCollectionRef.doc(documentID).get();
  //     isDocExist = notesDoc.exists;
  //   } on FirebaseException catch (e) {
  //     isDocExist = false;
  //   }
  //   return isDocExist;
  // }
  //
  // // Updates last modified date and time in the database
  // Future<void> updateLastModified(String documentID, String date) async {
  //   try {
  //     _firestore
  //         .collection('notes')
  //         .doc(_userEmail)
  //         .collection('notes')
  //         .doc(documentID)
  //         .update({
  //       'last_modified': date,
  //     });
  //   } on FirebaseException catch (e) {}
  // }

  Future<void> addUserNoteInfo(String author) async {
    try {
      _firestore.collection('notes').doc(author).set({
        'author': author,
        'total_notes': 0,
      });
    } on FirebaseException catch (e) {}
  }

  Future<Map<String, dynamic>?> fetchNoteData() async {
    Map<String, dynamic>? notesData;
    try {
      var notesDocuments =
          await _firestore.collection('notes').doc(_userEmail).get();
      if (notesDocuments.exists) notesData = notesDocuments.data();
    } on FirebaseException catch (e) {}
    return notesData;
  }

  // Fetch total number of notes created by user.
  Future<int> fetchTotalNotes() async {
    var notesData = await fetchNoteData();
    return notesData!['total_notes'];
  }

  // Update total number of notes created by user.
  Future<void> updateTotalNotes() async {
    int totalNotes = await fetchTotalNotes();
    int updatedTotalNotes = totalNotes + 1;
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .update({'total_notes': updatedTotalNotes});
    } on FirebaseException catch (e) {}
  }
}
