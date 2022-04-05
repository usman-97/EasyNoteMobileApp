import 'package:note_taking_app/models/note/user_sticky_notes.dart';
import 'package:note_taking_app/utilities/custom_date.dart';

class CreateStickyNoteViewModel {
  final UserStickyNotes _userStickyNotes = UserStickyNotes();
  final CustomDate _date = CustomDate();

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
      _userStickyNotes.addUserStickyNote(newNoteTitle, date);
    }
  }
}
