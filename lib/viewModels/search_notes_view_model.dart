import 'dart:async';

import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/search_user_notes.dart';

class SearchNotesViewModel {
  final SearchUserNotes _searchUserNotes = SearchUserNotes();
  late final StreamController<List<UserNoteData>> _streamController;
  String keyword = '';

  SearchNotesViewModel() {
    _streamController = _searchUserNotes.searchedNotesStreamController;
  }

  StreamController<List<UserNoteData>> get streamController =>
      _streamController;

  void getAllSearchUserNotes() {
    _searchUserNotes.fetchUserSearchedNoteData(keyword);
  }
}
