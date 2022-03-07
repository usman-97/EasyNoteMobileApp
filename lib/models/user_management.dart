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

  Future<void> doesUserExist(String email) async {
    print(_currentUserEmail);
    _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty &&
          event.docs.first.toString() != _currentUserEmail) {
        print('Not Empty');
      } else {
        print('Empty');
      }
    });

    // if (await otherUser.length > 0) {
    //   print('Not Empty');
    // } else {
    //   print('Empty');
    // }
  }
}
