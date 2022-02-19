import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_app/services/cloud_storage.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

class NoteStorage {
  final FirebaseStorage _firebaseStorage =
      CloudStorage.firebaseStorageInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  // Reference _root = CloudStorage.fileReference();

  // Upload note file the Firebase Storage
  Future<bool> uploadFileToCloud(String file, String filename) async {
    bool isUploaded = false;
    // Use current user email as document ID
    String userEmail = _userAuthentication.getCurrentUserEmail();

    // Convert json string to base64
    List<int> encodedFile = utf8.encode(file);
    Uint8List data = Uint8List.fromList(encodedFile);

    // Create path for the file
    Reference fileRef = _firebaseStorage.ref('$userEmail/$filename');

    try {
      // Upload file on created path in Firebase Storage
      await fileRef.putData(data);
      isUploaded = true;
    } on FirebaseException catch (e) {
      print(e);
    }
    return isUploaded;
  }
}
