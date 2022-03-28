import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_taking_app/components/notification_card.dart';
import 'package:note_taking_app/models/data/sharing_request_data.dart';
import 'package:note_taking_app/models/note_notification.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/models/user_shared_notes.dart';

class NotificationsViewModel {
  final NoteNotification _noteNotification = NoteNotification();
  // final UserManagement _userManagement = UserManagement();
  // final UserNote _userNote = UserNote();
  final UserSharedNotes _userSharedNotes = UserSharedNotes();
  final UserAuthentication _userAuthentication = UserAuthentication();

  Stream<List<SharingRequestData>> getAllSharingRequests() {
    return _noteNotification.fetchReceivedSharingRequests();
  }

  // String getUserFullName(String email) {
  //   String userFullName = '';
  //   StreamController<String> controller =
  //       _userManagement.fetchUserFullName(email: email);
  //   controller.stream.listen((event) {
  //     print(event);
  //     userFullName = event;
  //   });
  //   print(userFullName);
  //
  //   return userFullName;
  // }
  //
  // String getNoteTitle(String documentID, String email) {
  //   String noteTitle = '';
  //   _userNote.fetchNoteTitle(documentID, email: email).listen((event) {
  //     noteTitle = event;
  //   });
  //
  //   return noteTitle;
  // }

  Future<void> deleteRequestCard(
      String sender, String recipient, String noteID, String access) async {
    await _noteNotification.deleteSharingRequest(sender, noteID, access);
    await _noteNotification.deleteSharingNotePendingRequest(
        sender, recipient, noteID, access);
  }

  List<NotificationCard> buildNotificationCards(
      AsyncSnapshot<dynamic> snapshot) {
    List<NotificationCard> notificationCardList = [];
    final data = snapshot.data;

    for (final requestData in data) {
      // String senderName = getUserFullName(requestData.sender);
      // String noteTile = getNoteTitle(requestData.note, requestData.sender);
      String sender = requestData.sender;
      String noteID = requestData.note;
      String currentUserEmail = _userAuthentication.getCurrentUserEmail();

      notificationCardList.add(NotificationCard(
        user: requestData.senderName,
        noteTile: requestData.noteTitle,
        access: requestData.access,
        onAccept: () async {
          await _userSharedNotes.addSharedNoteData(noteID, sender);
          await _userSharedNotes.addUsers(sender, requestData.access, noteID);
          await _userSharedNotes.updateNoteStatus(noteID, sender);
        },
        onDecline: () async {
          await deleteRequestCard(
              sender, requestData.recipient, noteID, requestData.access);
        },
      ));
    }

    return notificationCardList;
  }
}
