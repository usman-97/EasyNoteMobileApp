import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/viewModels/note_list_view_model.dart';

Future<void> main() async {
  setupFirebaseAuthMocks();
  await Firebase.initializeApp();

  // setUpAll(() async {
  //   await Firebase.initializeApp();
  // });

  test('Get today date', () {
    NoteListViewModel noteListViewModel = NoteListViewModel();

    IconData privateStatusIcon = noteListViewModel.getStatusIcon('private');
    IconData privateIcon = Icons.lock_rounded;

    IconData sharedStatusIcon = noteListViewModel.getStatusIcon('shared');
    IconData sharedIcon = Icons.share_rounded;

    expect(privateStatusIcon, privateIcon);
    expect(sharedStatusIcon, sharedIcon);
  });
}
