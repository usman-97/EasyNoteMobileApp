import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/app_menu.dart';
import 'package:note_taking_app/components/circle_button.dart';
import 'package:note_taking_app/components/custom_app_bar.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';
import 'package:note_taking_app/views/home_screen.dart';

void main() {
  setupFirebaseAuthMocks();

  group('Home Screen', () {
    setUpAll(() async {
      await Firebase.initializeApp();
    });

    testWidgets('Home screen widgets', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(),
      ));
      await tester.pump(const Duration(seconds: 30));

      final appBar = find.byType(CustomAppBar);
      final addNoteButton = find.byType(CircleButton);

      expect(appBar, findsOneWidget);
      expect(addNoteButton, findsOneWidget);
    });
  });
}
