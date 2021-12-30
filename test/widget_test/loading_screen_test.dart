import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/views/loading_screen.dart';

void main() {
  testWidgets('Test if loading screen has on linear progress bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: LoadingScreen(),
    ));

    final linearProgressBar = find.byKey(const Key('linearProgressBar'));
    expect(linearProgressBar, findsOneWidget);
  });
}
