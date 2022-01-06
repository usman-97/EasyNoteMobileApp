import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/views/login_screen.dart';
import 'package:note_taking_app/components/round_button.dart';

void main() {
  testWidgets('Login Screen', (WidgetTester tester) async {
    // Build LoginScreen Widget
    await tester.pumpWidget(const MaterialApp(
      home: LoginScreen(),
    ));

    final heading = find.text('EasyNote');
    final subtitle = find.text('Capture your ideas');
    final loginButton = find.byType(RoundButton);
    final textField = find.byType(TextField);

    expect(loginButton, findsOneWidget); // Find login button
    expect(heading, findsOneWidget); // Find main heading
    expect(subtitle, findsOneWidget); // find subtitle
    expect(textField, findsNWidgets(2)); // find 2 textfields
  });
}
