import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class SearchUserNotes {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final StreamController<List<UserNoteData>> _searchedNotesStreamController =
      StreamController.broadcast();
  String _userEmail = '';

  SearchUserNotes() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  // Store stream of searched notes
  StreamController<List<UserNoteData>> get searchedNotesStreamController =>
      _searchedNotesStreamController;

  /// Fetch all notes using user typed [keyword]
  Future<void> fetchUserSearchedNoteData(String keyword) async {
    try {
      _firestore
          .collection('notes')
          .doc(_userEmail)
          .collection('notes')
          .where('title', isGreaterThanOrEqualTo: keyword)
          .where('title', isLessThanOrEqualTo: '$keyword\uf7ff')
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          List<UserNoteData> _searchNotes = event.docs
              .map((snapshot) => UserNoteData.fromJson(snapshot.data()))
              .toList();
          // Add all searched notes to the stream
          _searchedNotesStreamController.add(_searchNotes);
        }
      });
    } on FirebaseException catch (e) {}
  }
}
