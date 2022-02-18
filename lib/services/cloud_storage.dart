import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  CloudStorage._();

  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  static FirebaseStorage firebaseStorageInstance() {
    return _firebaseStorage;
  }

  static Reference fileReference({String? path}) {
    return _firebaseStorage.ref(path);
  }
}
