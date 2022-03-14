import 'package:note_taking_app/models/user_shared_notes.dart';

class ShareNoteViewModel {
  final UserSharedNotes _userSharedNotes = UserSharedNotes();

  void shareUserNote(String documentID, String email, String userAccess) async {
    bool isNotAlreadySharedWithUser = await _userSharedNotes
        .isNoteAlreadyBeenSharedWithUser(documentID, email);
    // print(isNotAlreadySharedWithUser);
    if (email.isNotEmpty && !isNotAlreadySharedWithUser) {
      await _userSharedNotes.addSharedNoteData(documentID);
      await _userSharedNotes.addUsers(email, userAccess, documentID);
      await _userSharedNotes.updateNoteStatus(documentID);
    }
  }
}
