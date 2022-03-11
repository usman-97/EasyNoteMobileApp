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
  late String _userEmail; // Current signed in user email

  NoteStorage() {
    _userEmail = _userAuthentication.getCurrentUserEmail();
  }

  /// Upload note file to the Firebase Storage
  /// [filename] is the name of the file to upload
  /// [file] is the file to upload to Firebase Storage
  Future<bool> uploadFileToCloud(String file, String filename) async {
    bool isUploaded = false;

    // Convert json string to base64
    List<int> encodedFile = utf8.encode(file);
    // Create fixed size 8 bit Uint8List from encoded file
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

  /// Download the note file from Firebase Storage
  /// [filename] is the name of the file to download from cloud storage
  Future<File> downloadFileFromCloud(String filename) async {
    // Temp directory where file will be download and made available for user
    Directory appDirectory = await getTemporaryDirectory();

    // Download file will saved in the files folder
    String path = '${appDirectory.path}/files';
    // Check if files folder exist, if not then create
    if (!await Directory(path).exists()) {
      await Directory('${appDirectory.path}/files').create(recursive: false);
    }

    // Location of downloaded file
    File fileToDownload = File('$path/$filename');

    try {
      // Download file to given path
      await _firebaseStorage
          .ref('$_userEmail/notes/$filename/$filename')
          .writeToFile(fileToDownload);
    } on FirebaseException catch (e) {}

    return fileToDownload;
  }

  /// Upload note attachment files to cloud storage
  /// [documentID] is the document name
  /// [document] is the note document
  Future<void> uploadAttachmentToCloud(
      String documentID, String document) async {
    // Temp directory
    Directory tempDir = await getTemporaryDirectory();
    // Get all files in the temp directory
    List<FileSystemEntity> allTempDirContent = await tempDir.list().toList();

    // If temp directory is not empty
    if (allTempDirContent.isNotEmpty) {
      // Then get all files and directories in the temp directory
      for (FileSystemEntity entity in allTempDirContent) {
        // If entity is a file
        if (entity is File) {
          String filename = basename(entity.path);
          File attachmentFile = entity;
          // File reference in the cloud storage
          Reference attachmentRef = _firebaseStorage
              .ref('$_userEmail/notes/$documentID/attachments/$filename');
          // If file exist in the temp directory but not in the document
          if (!document.contains(filename)) {
            // Look for a file in the cloud storage, if file found then
            // then delete the file
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
              // If file not in the cloud storage then upload it
              attachmentRef.putFile(attachmentFile);
            } on FirebaseException catch (e) {}
          }
        }
      }
    }
  }

  /// Download all required attachments files for the note document
  /// Get all attachment files using [documentID]
  Future<void> downloadAttachmentFilesFromCloud(String documentID) async {
    Directory tempDir = await getTemporaryDirectory();
    try {
      // Get the list of all files in the cloud storage
      ListResult allFilesInCloudRef = await _firebaseStorage
          .ref('$_userEmail/notes/$documentID/attachments')
          .listAll();

      // Download all files in the temp directory
      for (var element in allFilesInCloudRef.items) {
        File attachmentFile = File('${tempDir.path}/${element.name}');
        await _firebaseStorage
            .ref('$_userEmail/notes/$documentID/attachments/${element.name}')
            .writeToFile(attachmentFile);
      }
    } on FirebaseException catch (e) {}
  }

  /// Delete all user note files from the cloud storage using [documentID]
  Future<void> deleteUserNoteFiles(String documentID) async {
    try {
      ListResult userNoteFiles =
          await _firebaseStorage.ref('$_userEmail/notes/$documentID').listAll();
      for (final file in userNoteFiles.items) {
        Reference fileRef =
            _firebaseStorage.ref('$_userEmail/notes/$documentID/${file.name}');
        await fileRef.delete();
      }

      ListResult attachmentFiles = await _firebaseStorage
          .ref('$_userEmail/notes/$documentID/attachments')
          .listAll();
      for (final attachment in attachmentFiles.items) {
        Reference attachmentFile = _firebaseStorage.ref(
            '$_userEmail/notes/$documentID.json/attachments/${attachment.name}');
        await attachmentFile.delete();
      }
    } on FirebaseException catch (e) {}
  }
}
