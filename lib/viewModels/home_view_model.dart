import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_taking_app/components/sticky_note_cards.dart';
import 'package:note_taking_app/models/data/user_sticky_note_data.dart';
import 'package:note_taking_app/models/note/user_sticky_notes.dart';
import 'package:note_taking_app/models/note_notification.dart';
import 'package:note_taking_app/models/note_storage.dart';
import 'package:note_taking_app/models/user_management.dart';
import 'package:intl/intl.dart';
import 'package:note_taking_app/viewModels/create_note_view_model.dart';
import 'package:note_taking_app/views/note_screen/create_sticky_note_screen.dart';
import 'package:path_provider/path_provider.dart';

class HomeViewModel {
  final UserManagement _userManagement = UserManagement();
  final NoteNotification _noteNotification = NoteNotification();
  final UserStickyNotes _userStickyNotes = UserStickyNotes();
  final NoteStorage _noteStorage = NoteStorage();
  final CreateNoteViewModel _createNoteViewModel = CreateNoteViewModel();
  String _userFirstname = '', _currentStickyNoteText = '';
  // StreamController<String> _controller = StreamController.broadcast();

  get userFirstname => _userFirstname;

  Stream<String> setUserFirstName() {
    return _userManagement.fetchCurrentUserFirstname();
  }

  String getTodayData() {
    DateTime date = DateTime.now().toLocal();
    String weekDay = DateFormat.EEEE().format(date);
    String day = date.day.toString();
    String month = DateFormat.MMMM().format(date);
    String year = date.year.toString();
    String todayDate = '$weekDay, $day $month $year';

    return todayDate;
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
      // print(noteText);

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
        // userStickyNoteDataList.removeAt(index);
        // if (userStickyNoteDataList.length > 1) {
        //   userStickyNoteDataList.removeAt(index + 1);
        // }
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
    // _currentStickyNoteText = doc.toPlainText();
    // _controller.add(doc.toPlainText());
    return doc.toPlainText();
  }
}
