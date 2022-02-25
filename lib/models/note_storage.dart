import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_app/services/cloud_storage.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;

class NoteStorage {
  final FirebaseStorage _firebaseStorage =
      CloudStorage.firebaseStorageInstance();
  final UserAuthentication _userAuthentication = UserAuthentication();
  late String _userEmail;
  // Reference _root = CloudStorage.fileReference();

  NoteStorage() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  // Upload note file the Firebase Storage
  Future<bool> uploadFileToCloud(String file, String filename) async {
    bool isUploaded = false;
    // Use current user email as document ID
    // String userEmail = _userAuthentication.getCurrentUserEmail();

    // Convert json string to base64
    List<int> encodedFile = utf8.encode(file);
    Uint8List data = Uint8List.fromList(encodedFile);

    // Create path for the file
    Reference fileRef = _firebaseStorage.ref('$_userEmail/$filename');

    try {
      // Upload file on created path in Firebase Storage
      await fileRef.putData(data);
      isUploaded = true;
    } on FirebaseException catch (e) {
      // print(e);
    }
    return isUploaded;
  }

  Future<File> downloadFileFromCloud(String filename) async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    // print(appDirectory.path);
    File fileToDownload = File('${appDirectory.path}/$filename.json');
    // print(fileToDownload.path);

    try {
      await _firebaseStorage
          .ref('$_userEmail/$filename.json')
          .writeToFile(fileToDownload);
    } on FirebaseException catch (e) {
      print(e);
    }

    return fileToDownload;
  }
}
