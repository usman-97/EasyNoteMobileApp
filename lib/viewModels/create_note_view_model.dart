import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:note_taking_app/models/note_firestore.dart';
import 'package:note_taking_app/models/note_storage.dart';

class CreateNoteViewModel {
  final ImagePicker _imagePicker = ImagePicker();
  final NoteStorage _noteStorage = NoteStorage();
  final NoteFireStore _noteFireStore = NoteFireStore();
  String _error = '';

  Future<String> onImagePickCallback(File file) async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    return image!.path;
  }

  Future<String> onVideoPickCallBack(File file) async {
    final XFile? video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    return video!.path;
  }

  Future<void> uploadNoteToCloud(Object obj, String filename) async {
    var jsonFile = jsonEncode(obj);
    bool isUploaded = await _noteStorage.uploadFileToCloud(jsonFile, filename);
    if (!isUploaded) {
      _error = 'File not uploaded';
    }
  }

  Future<void> addNoteToFirestore(String noteTitle) async {
    String date = _getDate();
    print(date);
    bool isDocExist = await _noteFireStore.isNotesDocumentExist(noteTitle);
    if (isDocExist) {
      await _noteFireStore.updateLastModified(noteTitle, date);
    } else {
      await _noteFireStore.addNote(noteTitle, date);
    }
  }

  String _getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.day, now.month, now.year);
    return date.toString();
  }

  String get getError => _error;
}
