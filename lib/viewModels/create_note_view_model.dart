import 'dart:convert';
import 'dart:io';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/utilities/custom_date.dart';
import 'package:path_provider/path_provider.dart';

class CreateNoteViewModel {
  final ImagePicker _imagePicker = ImagePicker();
  final NoteStorage _noteStorage = NoteStorage();
  final UserNote _userNote = UserNote();
  final Note _note = Note();
  final CustomDate _date = CustomDate();
  String _error = '';
  String attachmentName = '';
  String currentDocumentID = '';

  String get getError => _error;

  // void listAllFiles() async {
  //   Directory dir = await getTemporaryDirectory();
  //   print(dir.path);
  //   List<FileSystemEntity> list = await dir.list().toList();
  //   for (var element in list) {
  //     print(element);
  //     // if (element is File) {
  //     // await element.delete(recursive: false);
  //     // }
  //   }
  // }

  /// Open phone gallery for user and get image path to add into
  /// the document
  /// [file] is image picked by user from photo gallery
  Future<String> onImagePickCallback(File file) async {
    // Cross platform file
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    attachmentName = image!.name;
    String imagePath = image.path;

    // If platform is iOS
    if (Platform.isIOS) {
      // Then move the image file to temp directory;
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

  /// Open gallery to allow user to pick video
  Future<String> onVideoPickCallBack(File file) async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);

    return video!.path;
  }

  /// Add new or existing note, if user note with [currentDocumentID] does not
  /// exist then add it to database
  /// otherwise update last modified time and
  /// check if [currentNoteTitle] and [newNoteTitle] are not same then
  /// update note title with [currentDocumentID]
  Future<void> addNote(String currentDocumentID, String newNoteTitle,
      String currentNoteTitle) async {
    String date = _date.getShortFormatDate();
    bool isDocExist = await _userNote.isNoteDocumentExist(currentDocumentID);
    if (isDocExist) {
      await _userNote.updateLastModified(currentDocumentID, date);
      if (currentNoteTitle != newNoteTitle) {
        await _userNote.updateNoteTitle(currentDocumentID, newNoteTitle);
      }
    } else {
      await _userNote.addNote(newNoteTitle, date);
      this.currentDocumentID = _userNote.currentNoteID;
    }
  }

  /// Get current data
  // String _getDate() {
  //   DateTime now = DateTime.now().toLocal();
  //   String date = '${now.day}/${now.month}/${now.year}';
  //
  //   return date;
  // }

  // Future<String> _generateNewDocumentID(String currentDocumentID,
  //     String newNoteTitle, String currentNoteTitle) async {
  //   String finalID = currentDocumentID;
  //   if (finalID.isEmpty) {
  //     finalID = newNoteTitle;
  //   }
  //   this.currentDocumentID = finalID;
  //   return finalID;
  // }

  /// Upload new or existing user note file to cloud storage
  Future<void> uploadNoteToCloud(
      Object obj, String currentDocumentID, String newDocumentID) async {
    // String filename =
    //     await _generateNewDocumentName(currentDocumentID, newDocumentID);

    // if (filename != currentDocumentID && currentDocumentID.isNotEmpty) {
    //   await _noteStorage.deleteUserNoteFiles(currentDocumentID);
    // }
    // Existing note filename
    String filename = currentDocumentID;
    if (filename.isEmpty) {
      // New note filename
      filename = _userNote.currentNoteID;
    }

    // Convert note file to json
    var jsonFile = jsonEncode(obj);
    // Finally upload json file to cloud storage
    bool isUploaded = await _noteStorage.uploadFileToCloud(jsonFile, filename);
    if (!isUploaded) {
      _error = 'File not uploaded';
    }
  }

  /// Download file with [filename] from cloud storage
  /// and return [doc]
  Future<Document> downloadNoteFromCloud(String filename) async {
    Document doc;
    try {
      final File noteFilePath =
          await _noteStorage.downloadFileFromCloud(filename);
      final String fileAsString = await noteFilePath.readAsString();
      // Check for attachment file path because Android and iOS temp folder path
      // is different
      final String fileAsStringPlatformCompatible =
          await _checkImagePlatformCompatibility(fileAsString);
      doc = Document.fromJson(jsonDecode(fileAsStringPlatformCompatible));
    } catch (e) {
      doc = Document();
    }

    return doc;
  }

  /// Check attachment files path
  Future<String> _checkImagePlatformCompatibility(String fileAsString) async {
    Directory localTempDir = await getTemporaryDirectory();
    const String androidTempDir = '/data/user/0/com.usk.easynote/cache';
    const String iosTempDir =
        '/Users/usmanshabir/Library/Developer/CoreSimulator/Devices/B73BA5CC-A266-455E-9D64-E769FA80258F/data/Containers/Data/Application/4F02287D-242B-4F4C-B7EB-DEDB3F7C3ACE/Library/Caches';
    String file = fileAsString;

    if (Platform.isIOS) {
      file = file.replaceAll(androidTempDir, localTempDir.path);
    }

    if (Platform.isAndroid) {
      file = file.replaceAll(iosTempDir, localTempDir.path);
    }

    return file;
  }

  /// Upload all attachments files to cloud storage
  void uploadUserAttachment(
      String currentDocumentID, String newDocumentID, String document) async {
    // String documentName =
    //     await _generateNewDocumentName(currentDocumentID, newDocumentID);
    // Existing note file attachments
    String documentName = currentDocumentID;
    if (documentName.isEmpty) {
      // New note file attachments
      documentName = _userNote.currentNoteID;
    }
    await _noteStorage.uploadAttachmentToCloud(documentName, document);
  }

  /// Download all note with name [documentID] attachments files to temp directory
  Future<void> downloadAttachmentFiles(String documentID) async {
    await _noteStorage.downloadAttachmentFilesFromCloud(documentID);
  }

  // Future<String> _generateNewDocumentName(
  //     String currentDocumentID, String newDocumentName) async {
  //   String noteDocId = currentDocumentID;
  //   int totalNotes = await getTotalUserNotes();
  //   if (currentDocumentID.isEmpty) {
  //     noteDocId = '$newDocumentName${totalNotes + 1}';
  //   }
  //   // else if (noteTitle != newDocumentName) {
  //   //   noteDocId = await _generateNewDocumentID(
  //   //       currentDocumentID, newDocumentName, noteTitle);
  //   // }
  //
  //   return noteDocId;
  // }

  /// Get total number of existing user notes
  Future<int> getTotalUserNotes() async {
    return await _userNote.getTotalUserNotes();
  }

  Future<int> getTotalNotes() async {
    return await _note.fetchTotalNotes();
  }

  /// Clear temp directory
  void clearCache() async {
    Directory dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
    await dir.create();
  }

  void setAuthor(String author) {
    _noteStorage.userEmail = author;
  }
}
