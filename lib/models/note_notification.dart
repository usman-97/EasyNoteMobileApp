import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_taking_app/models/data/sharing_request_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class NoteNotification {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserManagement _userManagement = UserManagement();
  final UserNote _userNote = UserNote();
  late String _userEmail;

  NoteNotification() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  Future<void> sendSharingRequest(
      String recipientEmail, String documentID, String access) async {
    String userName = await _userManagement.fetchUserFullName();
    String noteTitle = await _userNote.fetchNoteTitle(documentID);

    print('name: $userName title: $noteTitle');

    try {
      _firestore
          .collection('notifications')
          .doc(recipientEmail)
          .collection('sharing_requests')
          .add({
        'sender': _userEmail,
        'sender_name': userName,
        'recipient': recipientEmail,
        'note': documentID,
        'note_title': noteTitle,
        'access': access,
        'status': 'unread',
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> addSharingRequest(
      String recipientEmail, String documentID, String access) async {
    try {
      _firestore
          .collection('notifications')
          .doc(_userEmail)
          .collection('sharing_requests')
          .add({
        'sender': _userEmail,
        'recipient': recipientEmail,
        'note': documentID,
        'access': access,
        'status': 'pending',
      });
    } on FirebaseException catch (e) {}
  }

  Stream<List<SharingRequestData>> fetchReceivedSharingRequests() {
    StreamController<List<SharingRequestData>> controller =
        StreamController.broadcast();

    try {
      _firestore
          .collection('notifications')
          .doc(_userEmail)
          .collection('sharing_requests')
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          List<SharingRequestData> data = event.docs
              .map((snapshot) => SharingRequestData.fromJson(snapshot.data()))
              .toList();
          controller.add(data);
        }
      });
    } on FirebaseException catch (e) {}

    return controller.stream;
  }

  Future<void> deleteSharingRequest(
      String sender, String note, String access) async {
    CollectionReference sharingRequestColRef = _firestore
        .collection('notifications')
        .doc(_userEmail)
        .collection('sharing_requests');
    try {
      await sharingRequestColRef
          .where('sender', isEqualTo: sender)
          .where('recipient', isEqualTo: _userEmail)
          .where('note', isEqualTo: note)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await sharingRequestColRef.doc(value.docs.first.id).delete();
        }
      });
    } on FirebaseException catch (e) {}
  }

  Future<void> deleteSharingNotePendingRequest(
      String sender, String recipient, String note, String access) async {
    CollectionReference sharingRequestColRef = _firestore
        .collection('notifications')
        .doc(sender)
        .collection('sharing_requests');
    try {
      await sharingRequestColRef
          .where('sender', isEqualTo: sender)
          .where('note', isEqualTo: note)
          .where('recipient', isEqualTo: recipient)
          .where('access', isEqualTo: access)
          .get()
          .then((value) async {
        if (value.docs.isNotEmpty) {
          await sharingRequestColRef.doc(value.docs.first.id).delete();
        }
      });
    } on FirebaseException catch (e) {}
  }
}
