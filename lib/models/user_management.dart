import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/models/user_authentication.dart';

import '../services/firestore_cloud.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  late String _currentUserEmail;

  UserManagement() {
    _currentUserEmail = _userAuthentication.getCurrentUserEmail();
  }

  // Add user data to database
  Future<void> addUserData(
      String email, String firstname, String lastname) async {
    _firestore.collection('users').add({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    });
  }

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
}
