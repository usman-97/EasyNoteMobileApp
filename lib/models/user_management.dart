import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_taking_app/services/firestore_cloud.dart';

class UserManagement {
  final FirebaseFirestore _firestore = FirestoreCloud.firebaseCloudInstance();

  Future<void> addUserData(
      String email, String firstname, String lastname) async {
    _firestore.collection('users').doc(email).set({
      'firstname': firstname,
      'lastname': lastname,
    });
  }
}