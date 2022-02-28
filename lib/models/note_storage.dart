import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_taking_app/services/cloud_storage.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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
    Reference fileRef =
        _firebaseStorage.ref('$_userEmail/notes/$filename/$filename');

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
    Directory appDirectory = await getTemporaryDirectory();
    // print(appDirectory.path);

    String path = '${appDirectory.path}/files';
    if (!await Directory(path).exists()) {
      await Directory('${appDirectory.path}/files').create(recursive: false);
    }
    // print(await Directory(path).exists());

    File fileToDownload = File('$path/$filename.json');
    // print(fileToDownload.path);

    try {
      await _firebaseStorage
          .ref('$_userEmail/notes/$filename.json/$filename.json')
          .writeToFile(fileToDownload);
    } on FirebaseException catch (e) {
      // print(e);
    }
    // print(fileToDownload.path);

    return fileToDownload;
  }

  Future<void> uploadAttachmentToCloud(
      String documentID, String document) async {
    Directory tempDir = await getTemporaryDirectory();
    List<FileSystemEntity> allTempDirContent = await tempDir.list().toList();

    if (allTempDirContent.isNotEmpty) {
      for (FileSystemEntity entity in allTempDirContent) {
        if (entity is File) {
          String filename = basename(entity.path);
          File attachmentFile = entity;
          Reference attachmentRef = _firebaseStorage
              .ref('$_userEmail/notes/$documentID/attachments/$filename');
          // print(document.contains(filename));
          if (!document.contains(filename)) {
            ListResult allFilesInCloudRef = await _firebaseStorage
                .ref('$_userEmail/notes/$documentID/attachments')
                .listAll();
            for (var element in allFilesInCloudRef.items) {
              if (element.name == filename) {
                await attachmentRef.delete();
              }
            }
          } else {
            try {
              attachmentRef.putFile(attachmentFile);
            } on FirebaseException catch (e) {}
          }
        }
      }
    }
  }

  Future<void> downloadAttachmentFilesFromCloud(String documentID) async {
    // print(documentID);
    Directory tempDir = await getTemporaryDirectory();
    try {
      ListResult allFilesInCloudRef = await _firebaseStorage
          .ref('$_userEmail/notes/$documentID.json/attachments')
          .listAll();

      for (var element in allFilesInCloudRef.items) {
        // print(element.name);
        File attachmentFile = File('${tempDir.path}/${element.name}');
        await _firebaseStorage
            .ref(
                '$_userEmail/notes/$documentID.json/attachments/${element.name}')
            .writeToFile(attachmentFile);
        // print(await attachmentFile.exists());
      }
    } on FirebaseException catch (e) {
      print(e);
    }
    // print(await File('${tempDir.path}/image_picker1786613033710753713.jpg')
    //     .exists());
  }
}
