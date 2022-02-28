import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();

  // Add user data to database
  Future<void> addUserData(
      String email, String firstname, String lastname) async {
    _firestore.collection('users').add({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    });
  }
}
