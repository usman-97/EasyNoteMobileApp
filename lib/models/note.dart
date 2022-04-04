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

  /// Add information about user into note collection
  /// [author] is the new user
  Future<void> addUserNoteInfo(String author) async {
    try {
      _firestore.collection('notes').doc(author).set({
        'author': author,
        'total_notes': 0,
      });
    } on FirebaseException catch (e) {}
  }

  /// Fetch all note collection data of user from database
  Future<Map<String, dynamic>?> fetchNoteData() async {
    Map<String, dynamic>? notesData;
    try {
      var notesDocuments =
          await _firestore.collection('notes').doc(_userEmail).get();
      if (notesDocuments.exists) notesData = notesDocuments.data();
    } on FirebaseException catch (e) {}
    return notesData;
  }

  /// Fetch total number of notes created by user.
  Future<int> fetchTotalNotes() async {
    var notesData = await fetchNoteData();
    return notesData!['total_notes'];
  }

  /// Update total number of notes created by user.
  Future<void> updateTotalNotes(int totalNotes) async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .update({'total_notes': totalNotes});
    } on FirebaseException catch (e) {}
  }
}
