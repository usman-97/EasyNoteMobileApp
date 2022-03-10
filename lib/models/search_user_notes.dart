import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_note.dart';
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

  StreamController<List<UserNoteData>> get searchedNotesStreamController =>
      _searchedNotesStreamController;

  Future<void> fetchUserSearchedNoteData(String keyword) async {
    // List<UserNoteData> _searchNotes = [];

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
              .map((snapshot) =>
                  UserNoteData.fromDocumentSnapshot(snapshot.data()))
              .toList();
          _searchedNotesStreamController.add(_searchNotes);
        }
      });
    } on FirebaseException catch (e) {}
    // return _searchedNotesStreamController;
  }
}
