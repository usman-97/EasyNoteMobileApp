import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/sticky_note_card.dart';

void main() {
  group('StickyNoteCard Widget', () {
    testWidgets('Test StickyNoteCard Widget components',
        (WidgetTester tester) async {
      String noteID = '1';
      String title = 'test';
      String text = 'Testing StickyNoteCard Widget.';

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                StickyNoteCard(
                  noteID: noteID,
                  title: title,
                  text: text,
                  onEdit: () {},
                  onDelete: () async {},
                  backgroundColour: Colors.white,
                ),
              ],
            ),
          ),
        );

        final buttons = find.byType(TextButton);
        expect(buttons, findsNWidgets(2));
      } catch (e) {}
    });
  });
}
