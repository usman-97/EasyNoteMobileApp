import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/round_button.dart';
import 'package:note_taking_app/views/register_screen.dart';
import 'package:note_taking_app/services/initialise_firebase_mock.dart';

void main() {
  setupFirebaseAuthMocks();

  group('Register Screen', () {
    setUpAll(() async {
      // WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
    });

    testWidgets('check screen main heading and subtitle',
        (WidgetTester tester) async {
      // Build RegisterScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: RegisterScreen(),
      ));

      final heading = find.text('EasyNote');
      final subtitle = find.text('Capture your ideas');

      expect(heading, findsOneWidget); // Find main heading
      expect(subtitle, findsOneWidget); // Find subtitle
    });

    testWidgets('Test first section of registration',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: RegisterScreen(),
      ));

      final nextButton = find.byType(RoundButton);
      final textField = find.byType(TextField);

      expect(nextButton, findsNWidgets(1)); // Find register button
      expect(textField, findsNWidgets(2)); // Find all textfields
    });

    testWidgets('Test second section of registration',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: RegisterScreen(),
      ));

      final nextButton = find.byType(RoundButton);
      final textField = find.byType(TextField);

      await tester.tap(nextButton);
      await tester.pump();

      final buttons = find.byType(RoundButton);
      final secondSectionTextFields = find.byType(TextField);

      expect(buttons, findsNWidgets(2)); // Find register button
      expect(secondSectionTextFields, findsNWidgets(3)); // Find all textfields
    });
  });
}
