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

    testWidgets('Register Screen', (WidgetTester tester) async {
      // Build RegisterScreen widget
      await tester.pumpWidget(const MaterialApp(
        home: RegisterScreen(),
      ));

      final heading = find.text('EasyNote');
      final subtitle = find.text('Capture your ideas');
      final registerButton = find.byType(RoundButton);
      final textField = find.byType(TextField);

      expect(heading, findsOneWidget); // Find main heading
      expect(subtitle, findsOneWidget); // Find subtitle
      expect(registerButton, findsOneWidget); // Find register button
      expect(textField, findsNWidgets(3)); // Find all textfields
    });
  });
}
