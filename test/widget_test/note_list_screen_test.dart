import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/models/user_authentication.dart';
import 'package:note_taking_app/models/note/user_note.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/views/note_list_screen.dart';

void main() {
  setupFirebaseAuthMocks();

  group('Note List Screen', () {
    setUpAll(() async {
      await Firebase.initializeApp();
    });

    testWidgets('Note list screen widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: NoteListScreen(),
      ));

      final appBar = find.byType(CustomAppBar);
      final addNoteButton = find.byType(CircleButton);
      final backButton = find.byKey(const Key('note_list_back_button'));
      final mainHeading = find.byKey(const Key('note_list_screen_heading'));

      expect(appBar, findsOneWidget);
      expect(addNoteButton, findsOneWidget);
      expect(backButton, findsOneWidget);
      expect(mainHeading, findsOneWidget);
    });
  });
}
