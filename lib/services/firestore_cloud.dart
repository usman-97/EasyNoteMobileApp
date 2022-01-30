import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCloud {
  FirestoreCloud._();

  static FirebaseFirestore firebaseCloudInstance() {
    return FirebaseFirestore.instance;
  }
}
