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

    expect(find.byType(RoundButton), findsOneWidget); // Find login button
    expect(find.text('EasyNote'), findsOneWidget); // Find main heading
    expect(find.text('Capture your ideas'), findsOneWidget); // find subtitle
    expect(find.byType(TextField), findsWidgets); // find textfields
  });
}
