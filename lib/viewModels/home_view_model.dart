import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_taking_app/components/custom_alert_dialog.dart';
import 'package:note_taking_app/components/sticky_note_cards.dart';
import 'package:note_taking_app/models/data/user_sticky_note_data.dart';
import 'package:note_taking_app/models/note/user_sticky_notes.dart';
import 'package:note_taking_app/models/note_notification.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:note_taking_app/utilities/custom_date.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/views/note_screen/create_sticky_note_screen.dart';

class HomeViewModel {
  final UserManagement _userManagement = UserManagement();
  final NoteNotification _noteNotification = NoteNotification();
  final UserStickyNotes _userStickyNotes = UserStickyNotes();
  final NoteStorage _noteStorage = NoteStorage();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  final CustomDate _customDate = CustomDate();
  String _userFirstname = '', _currentStickyNoteText = '';
  // StreamController<String> _controller = StreamController.broadcast();

  get userFirstname => _userFirstname;

  Stream<String> setUserFirstName() {
    return _userManagement.fetchCurrentUserFirstname();
  }

  String getTodayDate() {
    return _customDate.getLongFormatDateWithDay();
  }

  Stream<int> getTotalUnreadNotification() {
    return _noteNotification.fetchTotalUnreadNotification();
  }

  Future<void> readAllNotification() async {
    await _noteNotification.updateUnreadStatus();
  }

  Stream<List<UserStickyNoteData>> getAllUserStickyNotes() {
    return _userStickyNotes.fetchAllUserStickyNotes();
  }

  Future<List<Row>> buildStickyNoteCards(
      BuildContext context, AsyncSnapshot<dynamic> snapshot) async {
    List<Row> stickyNotesRow = [];

    final data = snapshot.data;
    List<StickyNoteCard> userStickyNoteDataList = [];
    int index = 0;
    for (int i = 0; i < data.length; i++) {
      String noteID = data[i].noteID;
      String noteTitle = data[i].noteTitle;
      String noteText = await getStickyNoteFile(noteID);

      userStickyNoteDataList.add(StickyNoteCard(
        noteID: noteID,
        title: noteTitle,
        text: noteText,
        backgroundColour: getStickyNoteColour(),
        onEdit: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateStickyNoteScreen(
              isEditable: false,
              documentID: noteID,
              title: noteTitle,
            );
          }));
        },
        onDelete: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                  noteTitle: 'Delete $noteTitle',
                  message: 'Are you sure?',
                  onAccept: () async {
                    await _userStickyNotes.deleteStickyNoteCard(noteID);
                    await _noteStorage.deleteUserStickyNote(noteID);
                    Navigator.of(context).pop();
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

      if ((i + 1) % 2 == 0 ||
          data.length == 1 ||
          (data.length % 2 != 0 && i == (data.length - 1))) {
        // List<StickyNoteCard> tempList = userStickyNoteDataList;
        stickyNotesRow.add(Row(
          children: userStickyNoteDataList,
        ));
        index = 0;

        userStickyNoteDataList = [];
      } else {
        index++;
      }
    }

    return stickyNotesRow;
  }

  Color getStickyNoteColour() {
    List<Color> colours = [
      Colors.redAccent,
      Colors.lightGreenAccent,
      Colors.lightBlueAccent,
      Colors.yellowAccent,
      Colors.pinkAccent
    ];

    Random random = Random();
    Color chosenColour = colours[random.nextInt(colours.length)];
    return chosenColour;
  }

  Future<String> getStickyNoteFile(String filename) async {
    Document doc = await _createNoteViewModel.downloadNoteFromCloud(
        filename, 'sticky_notes');
    return doc.toPlainText();
  }
}
