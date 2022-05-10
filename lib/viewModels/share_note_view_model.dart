import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/models/note_notification.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/models/user_shared_notes.dart';

class ShareNoteViewModel {
  final UserSharedNotes _userSharedNotes = UserSharedNotes();
  final UserManagement _userManagement = UserManagement();
  final NoteNotification _notification = NoteNotification();
  String _error = '';

  get error => _error;

  // Future<void> shareUserNote(
  //     String documentID, String email, String userAccess) async {
  //   bool isNotAlreadySharedWithUser = await _userSharedNotes
  //       .isNoteAlreadyBeenSharedWithUser(documentID, email);
  //   bool isUserExist = await _userManagement.isUserExist(email);
  //   // print(isUserExist);
  //   if (email.isNotEmpty && isUserExist) {
  //     if (!isNotAlreadySharedWithUser) {
  //       _error = '';
  //       await _userSharedNotes.addSharedNoteData(documentID);
  //       await _userSharedNotes.addUsers(email, userAccess, documentID);
  //       await _userSharedNotes.updateNoteStatus(documentID);
  //     } else {
  //       _error = 'This note has already been shared with $email';
  //     }
  //   } else {
  //     _error = 'Invalid email';
  //   }
  // }

  Future<void> sendNoteSharingRequest(String recipient, String documentID,
      String access, BuildContext context) async {
    bool doesRecipientExist = await _userManagement.doesUserExist(recipient);
    if (doesRecipientExist) {
      await _notification.sendSharingRequest(recipient, documentID, access);
      await _notification.addSharingRequest(recipient, documentID, access);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sharing request has been sent to $recipient'),
        ),
      );
    } else {
      _error = "Invalid email.";
    }
  }
}
