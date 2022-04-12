import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

      final appBar = find.byType(CustomAppBar);
      final addNoteButton = find.byType(CircleButton);
      final notificationButton = find.byKey(const Key('notification_button'));

      expect(appBar, findsOneWidget);
      expect(addNoteButton, findsOneWidget);
      expect(notificationButton, findsOneWidget);
    });

    testWidgets('Open bottomNavBar when + button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      final bottomNavBar = find.byKey(const Key('choose_note_type'));

      await tester.tap(find.byType(CircleButton));
      await tester.pump(const Duration(seconds: 5));

      expect(bottomNavBar, findsOneWidget);
    });
  });
}
