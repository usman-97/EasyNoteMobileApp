import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserData {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();

  void addUserData(String email, String firstname, String lastname) {
    _firestore.collection('users').add({
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    });
  }
}
