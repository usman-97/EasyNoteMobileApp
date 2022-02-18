import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  CloudStorage._();

  FirebaseStorage firebaseStorageInstance() {
    return FirebaseStorage.instance;
  }
}
