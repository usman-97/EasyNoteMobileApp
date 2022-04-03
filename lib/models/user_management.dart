import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';

import '../services/firestore_cloud.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  late String _currentUserEmail;
  String _error = '';

  UserManagement() {
    _currentUserEmail = _userAuthentication.getCurrentUserEmail();
  }

  String get error => _error;

  /// Add user data to database
  Future<void> addUserData(
      String email, String firstname, String lastname) async {
    _firestore.collection('users').add({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    });
  }

  /// Check if a user exist having [email]
  Future<bool> doesUserExist(String email) async {
    bool doesUserExist = false;
    final user = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (user.docs.isNotEmpty) {
      doesUserExist = true;
    }

    return doesUserExist;
  }

  Stream<String> fetchCurrentUserFirstname() {
    StreamController<String> firstname = StreamController.broadcast();
    try {
      _firestore
          .collection('users')
          .where('email', isEqualTo: _currentUserEmail)
          .snapshots()
          .listen((value) {
        if (value.docs.isNotEmpty) {
          _firestore
              .collection('users')
              .doc(value.docs.first.id)
              .snapshots()
              .listen((value) {
            if (value.exists) {
              firstname.add(value.get('firstname'));
            }
          });
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return firstname.stream;
  }

  Future<String> fetchUserFullName({String email = ''}) async {
    if (email.isEmpty) {
      email = _currentUserEmail;
    }

    // StreamController<String> _controller = StreamController.broadcast();
    String userFullName = '';
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((event) {
        if (event.docs.isNotEmpty) {
          userFullName =
              '${event.docs.first.get('firstname')} ${event.docs.first.get('lastname')}';
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return userFullName;
  }

  Future<bool> isUserExist(String email) async {
    bool isUserExist = true;
    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          isUserExist = false;
        }
      });
    } on FirebaseException catch (e) {
      _error = e.code;
    }

    return isUserExist;
  }
}
