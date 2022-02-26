import 'dart:convert';
import 'dart:io';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/models/user_note.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class CreateNoteViewModel {
  final ImagePicker _imagePicker = ImagePicker();
  final NoteStorage _noteStorage = NoteStorage();
  final UserNote _userNote = UserNote();
  final Note _note = Note();
  String _error = '';
  String attachmentName = '';

  String get getError => _error;

  void listAllFiles() async {
    Directory dir = await getTemporaryDirectory();
    List<FileSystemEntity> list = await dir.list().toList();
    for (var element in list) {
      print(element);
      // if (element is File) {
      // await element.delete(recursive: false);
      // }
    }

    // await Directory('${dir.path}/test').create(recursive: false);
    // await File('${dir.path}/test/testFile.txt').create(recursive: false);
    // List<FileSystemEntity> dirFileList =
    //     await Directory('${dir.path}/test').list().toList();
    // dirFileList.forEach((e) {
    //   print(e.toString());
    //   e.delete();
    // });
    // print(await Directory('${dir.path}/test').exists());
  }

  Future<String> onImagePickCallback(File file) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    attachmentName = image!.name;

    return image.path;
  }

  Future<String> onVideoPickCallBack(File file) async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);

    return video!.path;
  }

  // Future<void> uploadNoteToCloud(
  //     Object obj, String currentDocumentID, String newDocumentID) async {
  //   String documentName =
  //       await _generateDocumentName(currentDocumentID, newDocumentID);
  //   // String documentID =
  //   //     await _generateDocumentID(currentDocumentID, newDocumentID);
  //
  //   await _uploadNote(obj, documentName);
  //   // await _addNote(documentID);
  // }

  Future<void> uploadNoteToCloud(
      Object obj, String currentDocumentID, String newDocumentID) async {
    String filename =
        await _generateDocumentName(currentDocumentID, newDocumentID);
    var jsonFile = jsonEncode(obj);
    bool isUploaded = await _noteStorage.uploadFileToCloud(jsonFile, filename);
    if (!isUploaded) {
      _error = 'File not uploaded';
    }
  }

  Future<String> _generateDocumentName(
      String currentDocumentID, String newDocumentID) async {
    String noteDocId = '$currentDocumentID.json';
    int totalNotes = await getTotalNotes();
    if (currentDocumentID.isEmpty) {
      noteDocId = '$newDocumentID${totalNotes + 1}.json';
    }

    return noteDocId;
  }

  Future<Document> downloadNoteFromCloud(String filename) async {
    Document doc;
    try {
      final File noteFilePath =
          await _noteStorage.downloadFileFromCloud(filename);
      final String fileAsString = await noteFilePath.readAsString();
      doc = Document.fromJson(jsonDecode(fileAsString));
    } catch (e) {
      doc = Document();
    }
    // print(doc);

    return doc;
  }

  Future<void> addNote(String currentDocumentID, String newDocumentID) async {
    String id = await _generateDocumentID(currentDocumentID, newDocumentID);
    String date = _getDate();
    bool isDocExist = await _userNote.isNotesDocumentExist(id);
    if (isDocExist) {
      await _userNote.updateLastModified(id, date);
    } else {
      await _userNote.addNote(id, date);
    }
  }

  Future<String> _generateDocumentID(
      String currentDocumentID, String newDocumentID) async {
    String finalID = currentDocumentID;
    if (finalID.isEmpty) {
      finalID = newDocumentID;
    }

    return finalID;
  }

  Future<int> getTotalNotes() async {
    return await _note.fetchTotalNotes();
  }

  String _getDate() {
    DateTime now = DateTime.now().toLocal();
    String date = '${now.day}/${now.month}/${now.year}';

    return date;
  }

  void uploadUserAttachment(
      String currentDocumentID, String newDocumentID) async {
    String documentName =
        await _generateDocumentName(currentDocumentID, newDocumentID);
    await _noteStorage.uploadAttachmentToCloud(documentName);
  }

  void downloadAttachmentFiles(
      String currentDocumentID, String newDocumentID) async {
    String documentName =
        await _generateDocumentName(currentDocumentID, newDocumentID);
    await _noteStorage.downloadAttachmentFilesFromCloud(documentName);
  }

  void clearCache() async {
    // Directory tempDir = await getTemporaryDirectory();
    // List<FileSystemEntity> allTempDirContent = await tempDir.list().toList();
    // for (var element in allTempDirContent) {
    //   await element.delete(recursive: true);
    // }
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    dir.create();
  }
}
