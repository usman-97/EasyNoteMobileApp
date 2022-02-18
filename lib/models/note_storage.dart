import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_app/services/cloud_storage.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

class NoteStorage {
  FirebaseStorage _firebaseStorage = CloudStorage.firebaseStorageInstance();
  UserAuthentication _userAuthentication = UserAuthentication();
  Reference _root = CloudStorage.fileReference();

  // void storeNote(String filename)
  // {
  //   String userEmail = _userAuthentication.getCurrentUserEmail();
  //   _root.child(userEmail)
  //   .child()
  // }

  Future<bool> uploadFileToCloud(String file, String filename) async {
    bool isUploaded = false;
    String userEmail = _userAuthentication.getCurrentUserEmail();

    List<int> encodedFile = utf8.encode(file);
    Uint8List data = Uint8List.fromList(encodedFile);

    Reference fileRef = _firebaseStorage.ref('$userEmail/$filename');

    try {
      await fileRef.putData(data);
      isUploaded = true;
    } on FirebaseException catch (e) {
      print(e);
    }
    return isUploaded;
  }
}
