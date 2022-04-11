import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:note_taking_app/components/custom_alert_dialog.dart';
import 'package:note_taking_app/components/note_card.dart';
import 'package:note_taking_app/models/data/user_note_data.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/utilities/custom_date.dart';
import 'package:note_taking_app/utilities/file_handler.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/views/note_screen/create_note_screen.dart';
import 'package:note_taking_app/views/share_note_screen.dart';
import '../models/note_storage.dart';
import '../models/user_shared_notes.dart';

class NoteListViewModel with ChangeNotifier {
  final UserNote _userNote = UserNote();
  final UserAuthentication _userAuthentication = UserAuthentication();
  final UserSharedNotes _sharedUserNotes = UserSharedNotes();
  final NoteStorage _noteStorage = NoteStorage();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  final CustomDate _date = CustomDate();
  final FileHandler _fileHandler = FileHandler();

  Stream<List<UserNoteData>> fetchAllUserNotes() {
    return _userNote.fetchAllUserNoteData();
  }

  /// Build user note cards using [context] and data [snapshot]
  List<NoteCard> buildUserNoteCards(
      AsyncSnapshot<dynamic> snapshot, BuildContext context) {
    List<NoteCard> _userNoteCards = []; // List to store all use note cards
    final notesData = snapshot.data; // Note data
    final String userAndAuthor = _userAuthentication.getCurrentUserEmail();

    for (var noteData in notesData) {
      String noteID = noteData.documentID;
      String noteTitle = noteData.noteTitle;
      String dateCreated =
          _date.getMediumFormatDate(customDate: noteData.dateCreated);
      String lastModified = _date.getLastModifiedDateTime(
          noteData.lastModified, noteData.lastModifiedTime);
      IconData status = getStatusIcon(noteData.status);

      _userNoteCards.add(NoteCard(
        noteID: noteID,
        title: noteTitle,
        dateCreated: dateCreated,
        lastModified: lastModified,
        status: status,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateNoteScreen(
              isEditable: false,
              documentID: noteID,
              title: noteTitle,
              user: userAndAuthor,
              author: userAndAuthor,
            );
          }));
        },
        onShare: (context) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ShareNoteScreen(
              noteID: noteID,
            );
          }));
        },
        onDelete: (context) async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  noteTitle: ' Delete $noteTitle',
                  message: 'Are you sure?',
                  onAccept: () async {
                    await _userNote.deleteUserNote(noteID);
                    await _noteStorage.deleteUserNoteFiles(noteID);
                    bool isNoteShared =
                        await _sharedUserNotes.isNotAlreadyShared(noteID);
                    if (isNoteShared) {
                      await _sharedUserNotes.deleteSharedNoteReference(noteID);
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$noteTitle has been deleted.'),
                      ),
                    );
                  },
                  onRefuse: () {
                    Navigator.of(context).pop();
                  },
                  acceptIcon: const Icon(Icons.check_rounded),
                  refuseIcon: const Icon(
                    Icons.close_rounded,
                    color: Colors.redAccent,
                  ),
                );
              });
        },
      ));
    }

    return _userNoteCards;
  }

  /// Get note status icon using its [status]
  IconData getStatusIcon(String status) {
    IconData statusIcon = Icons.lock_rounded;
    if (status == 'shared') {
      statusIcon = Icons.share_rounded;
    }

    return statusIcon;
  }

  /// Import note with json format using [context]
  Future<void> importNote(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['json'],
        );
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      final fileAsString = await file.readAsString();
      final String deviceCompatibleFile = await _createNoteViewModel
          .checkImagePlatformCompatibility(fileAsString);
      final filename = _fileHandler.getFilename(file.path);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CreateNoteScreen(
          title: filename,
          jsonDocument: deviceCompatibleFile,
        );
      }));
    } else {}
  }
}
