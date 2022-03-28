import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/data/sharing_request_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class Notification {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  late String _userEmail;

  Notification() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  Future<void> sendSharingRequest(
      String recipientEmail, String documentID, String access) async {
    try {
      _firestore
          .collection('notifications')
          .doc(recipientEmail)
          .collection('sharing_requests')
          .add({
        'sender': _userEmail,
        'recipient': recipientEmail,
        'note': documentID,
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
}
