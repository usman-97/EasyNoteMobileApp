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
  String currentDocumentID = '';

  String get getError => _error;

  void listAllFiles() async {
    Directory dir = await getTemporaryDirectory();
    print(dir.path);
    List<FileSystemEntity> list = await dir.list().toList();
    for (var element in list) {
      print(element);
      // if (element is File) {
      // await element.delete(recursive: false);
      // }
    }
  }

  Future<String> onImagePickCallback(File file) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    attachmentName = image!.name;
    String imagePath = image.path;

    if (Platform.isIOS) {
      Directory cacheDir = await getTemporaryDirectory();
      File imageFile = File(image.path);
      File newImageFile =
          await imageFile.copy('${cacheDir.path}/${image.name}');
      await imageFile.delete();
      imagePath = newImageFile.path;
      // print(newImageFile.path);
    }

    // print(image.path);
    return imagePath;
  }

  Future<String> onVideoPickCallBack(File file) async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);

    return video!.path;
  }

  Future<void> addNote(String currentDocumentID, String newNoteTitle,
      String currentNoteTitle) async {
    String newDocID = await _generateNewDocumentID(
        currentDocumentID, newNoteTitle, currentNoteTitle);
    // print(currentDocumentID);
    // print(newNoteTitle);
    // print(currentNoteTitle);
    print(newDocID);
    String date = _getDate();
    bool isDocExist = await _userNote.isNoteDocumentExist(currentDocumentID);
    // print(isDocExist);
    if (isDocExist) {
      await _userNote.updateLastModified(newDocID, date);
      if (currentNoteTitle != newNoteTitle) {
        // await _userNote.updateNoteID(currentDocumentID, newDocID);
        await _userNote.updateNoteTitle(currentDocumentID, newNoteTitle);
      }
    } else {
      await _userNote.addNote(newDocID, date);
    }
  }

  Future<String> _generateNewDocumentID(String currentDocumentID,
      String newNoteTitle, String currentNoteTitle) async {
    String finalID = currentDocumentID;
    if (finalID.isEmpty) {
      finalID = newNoteTitle;
    }
    // else if (currentNoteTitle != newNoteTitle) {
    //   final idPattern = RegExp(r'[0-9]+$');
    //   final match = idPattern.firstMatch(currentDocumentID);
    //   // print(match);
    //   if (match != null) {
    //     String oldDocumentIDNumbers = match.group(0).toString();
    //     finalID = '${newNoteTitle}Note$oldDocumentIDNumbers';
    //   }
    // }
    //
    this.currentDocumentID = finalID;
    return finalID;
  }

  Future<void> uploadNoteToCloud(
      Object obj, String currentDocumentID, String newDocumentID) async {
    String filename =
        await _generateNewDocumentName(currentDocumentID, newDocumentID);
    if (filename != currentDocumentID && currentDocumentID.isNotEmpty) {
      await _noteStorage.deleteUserNoteFiles(currentDocumentID);
    }
    var jsonFile = jsonEncode(obj);
    bool isUploaded = await _noteStorage.uploadFileToCloud(jsonFile, filename);
    if (!isUploaded) {
      _error = 'File not uploaded';
    }
  }

  Future<Document> downloadNoteFromCloud(String filename) async {
    Document doc;
    try {
      final File noteFilePath =
          await _noteStorage.downloadFileFromCloud(filename);
      final String fileAsString = await noteFilePath.readAsString();
      final String fileAsStringPlatformCompatible =
          _checkImagePlatformCompatibility(fileAsString);
      // print(fileAsStringPlatformCompatible);
      doc = Document.fromJson(jsonDecode(fileAsStringPlatformCompatible));
    } catch (e) {
      doc = Document();
    }
    // print(doc);

    return doc;
  }

  void uploadUserAttachment(
      String currentDocumentID, String newDocumentID, String document) async {
    String documentName =
        await _generateNewDocumentName(currentDocumentID, newDocumentID);
    await _noteStorage.uploadAttachmentToCloud(documentName, document);
  }

  Future<void> downloadAttachmentFiles(String documentID) async {
    // String documentName =
    //     await _generateDocumentName(currentDocumentID, newDocumentID);
    await _noteStorage.downloadAttachmentFilesFromCloud(documentID);
  }

  Future<String> _generateNewDocumentName(
      String currentDocumentID, String newDocumentName) async {
    String noteDocId = currentDocumentID;
    int totalNotes = await getTotalNotes();
    if (currentDocumentID.isEmpty) {
      noteDocId = '$newDocumentName${totalNotes + 1}';
    }
    // else if (noteTitle != newDocumentName) {
    //   noteDocId = await _generateNewDocumentID(
    //       currentDocumentID, newDocumentName, noteTitle);
    // }

    return noteDocId;
  }

  String _checkImagePlatformCompatibility(String fileAsString) {
    const String androidTempDir = '/data/user/0/com.usk.easynote/cache';
    const String iosTempDir =
        '/Users/usmanshabir/Library/Developer/CoreSimulator/Devices/B73BA5CC-A266-455E-9D64-E769FA80258F/data/Containers/Data/Application/4F02287D-242B-4F4C-B7EB-DEDB3F7C3ACE/Library/Caches';
    String file = fileAsString;

    if (Platform.isIOS) {
      file = file.replaceAll(androidTempDir, iosTempDir);
    }

    if (Platform.isAndroid) {
      file = file.replaceAll(iosTempDir, androidTempDir);
    }

    return file;
  }

  Future<int> getTotalNotes() async {
    return await _note.fetchTotalNotes();
  }

  String _getDate() {
    DateTime now = DateTime.now().toLocal();
    String date = '${now.day}/${now.month}/${now.year}';

    return date;
  }

  void clearCache() async {
    // Directory tempDir = await getTemporaryDirectory();
    // List<FileSystemEntity> allTempDirContent = await tempDir.list().toList();
    // for (var element in allTempDirContent) {
    //   await element.delete(recursive: true);
    // }
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    await dir.create();
  }
}
