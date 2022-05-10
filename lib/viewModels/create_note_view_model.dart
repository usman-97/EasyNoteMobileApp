import 'dart:convert';
import 'dart:io';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/models/note.dart';
import 'package:note_taking_app/utilities/custom_date.dart';
import 'package:note_taking_app/utilities/file_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';

class CreateNoteViewModel {
  final ImagePicker _imagePicker = ImagePicker();
  final NoteStorage _noteStorage = NoteStorage();
  final UserNote _userNote = UserNote();
  final Note _note = Note();
  final CustomDate _date = CustomDate();
  final FileHandler _fileHandler = FileHandler();
  String _error = '';
  String attachmentName = '';
  String currentDocumentID = '';

  String get getError => _error;

  void listAllFiles() async {
    Directory dir = await getTemporaryDirectory();
    print('Directory path: ${dir.path}');
    List<FileSystemEntity> list = await dir.list().toList();
    for (var element in list) {
      print(element);
      // if (element is File) {
      // await element.delete(recursive: false);
      // }
    }
  }

  /// Open phone gallery for user and get image path to add into
  /// the document
  /// [file] is image picked by user from photo gallery
  Future<String> onImagePickCallback(File file) async {
    Directory cacheDir = await getTemporaryDirectory();
    String filePath = file.path;

    // If platform is iOS
    if (Platform.isIOS) {
      // Copy the file the app cache folder
      File copiedFile =
          await file.copy('${cacheDir.path}/${basename(file.path)}');
      filePath = copiedFile.path;
    }

    return filePath;
  }

  /// Open gallery to allow user to pick video
  Future<String> onVideoPickCallBack(File file) async {
    Directory cacheDir = await getTemporaryDirectory();
    String filePath = file.path;

    // If platform is iOS
    if (Platform.isIOS) {
      // Copy the file the app cache folder
      File copiedFile =
          await file.copy('${cacheDir.path}/${basename(file.path)}');
      filePath = copiedFile.path;
    }

    return filePath;
  }

  /// Add new or existing note, if user note with [currentDocumentID] does not
  /// exist then add it to database
  /// otherwise update last modified time and
  /// check if [currentNoteTitle] and [newNoteTitle] are not same then
  /// update note title with [currentDocumentID]
  Future<void> addNote(String currentDocumentID, String newNoteTitle,
      String currentNoteTitle) async {
    String date = _date.getShortFormatDate();
    String time = _date.getTime();
    bool isDocExist = await _userNote.isNoteDocumentExist(currentDocumentID);
    if (isDocExist) {
      await _userNote.updateLastModified(currentDocumentID, date, time);
      if (currentNoteTitle != newNoteTitle) {
        await _userNote.updateNoteTitle(currentDocumentID, newNoteTitle);
      }
    } else {
      await _userNote.addNote(newNoteTitle, date, time);
      this.currentDocumentID = _userNote.currentNoteID;
    }
  }

  /// Upload new or existing user note file to cloud storage
  Future<void> uploadNoteToCloud(
      Object obj, String currentDocumentID, String type) async {
    // Existing note filename
    String filename = currentDocumentID;
    if (filename.isEmpty) {
      // New note filename
      filename = _userNote.currentNoteID;
    }

    // Convert note file to json
    var jsonFile = jsonEncode(obj);
    // Finally upload json file to cloud storage
    bool isUploaded =
        await _noteStorage.uploadFileToCloud(jsonFile, filename, type);
    if (!isUploaded) {
      _error = 'File not uploaded';
    }
  }

  /// Download file with [filename] from cloud storage
  /// and return [doc]
  Future<Document> downloadNoteFromCloud(String filename, String type) async {
    Document doc;
    try {
      final File noteFilePath =
          await _noteStorage.downloadFileFromCloud(filename, type);
      final String fileAsString = await noteFilePath.readAsString();
      // Check for attachment file path because Android and iOS temp folder path
      // is different
      final String fileAsStringPlatformCompatible =
          await checkImagePlatformCompatibility(fileAsString);
      doc = Document.fromJson(jsonDecode(fileAsStringPlatformCompatible));
    } catch (e) {
      doc = Document();
    }

    return doc;
  }

  /// Check attachment files path
  Future<String> checkImagePlatformCompatibility(String fileAsString) async {
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

  /// Get total number of existing user notes
  Future<int> getTotalUserNotes() async {
    return await _userNote.getTotalUserNotes();
  }

  Future<int> getTotalNotes() async {
    return await _note.fetchTotalNotes();
  }

  /// Clear temp directory
  void clearCache() async {
    try {
      Directory dir = await getTemporaryDirectory();
      dir.deleteSync(recursive: true);
      await dir.create();
    } catch (e) {}
  }

  void setAuthor(String author) {
    _noteStorage.userEmail = author;
  }

  void shareNoteAsJson(String noteID) async {
    _fileHandler.shareNoteAsJson(noteID);
  }

  Future<void> saveNoteAsJson(String file, String filename) async {
    await _fileHandler.saveFileAsJson(file, filename);
  }
}
