import 'dart:convert';

import 'package:note_taking_app/models/note/user_sticky_notes.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/utilities/custom_date.dart';

class CreateStickyNoteViewModel {
  final UserStickyNotes _userStickyNotes = UserStickyNotes();
  final NoteStorage _noteStorage = NoteStorage();
  final CustomDate _date = CustomDate();
  String _currentDocumentID = '', _error = '';

  String get currentDocumentID => _currentDocumentID;
  String get error => _error;

  /// Add new sticky note with new [noteID] and [newNoteTitle]
  /// if sticky note already exist then update the last modified date
  /// check if [noteTitle] and [newNoteTitle] are same
  /// if not then update sticky note title
  Future<void> addUserStickyNote(
      String noteID, String noteTitle, String newNoteTitle) async {
    String date = _date.getShortFormatDate();
    bool isStickyNoteAlreadyExist =
        await _userStickyNotes.isStickyNoteAlreadyExist(noteID);

    if (isStickyNoteAlreadyExist) {
      _userStickyNotes.updateLastModified(noteID, date);
      if (noteTitle == newNoteTitle) {
        _userStickyNotes.updateNoteTitle(noteID, newNoteTitle);
      }
    } else {
      await _userStickyNotes.addUserStickyNote(newNoteTitle, date);
      _currentDocumentID = _userStickyNotes.currentStickyNoteID;
    }
  }

  Future<void> uploadStickyNoteToCloud(
      Object object, String currentDocumentID, String type) async {
    String filename = currentDocumentID;
    if (currentDocumentID.isEmpty) {
      filename = _currentDocumentID;
    }

    final jsonFile = jsonEncode(object);
    bool isUploaded =
        await _noteStorage.uploadFileToCloud(jsonFile, filename, type);
    if (!isUploaded) {
      _error = 'File is not uploaded';
    }
  }
}
