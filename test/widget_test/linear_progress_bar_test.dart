import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_app/components/linear_progress_bar.dart';

void main() {
  group('linear_progress_bar', () {
    testWidgets('check if bar is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: LinearProgressBar(),
      ));

      final container = find.byKey(const Key('fillBar'));

      expect(find.byWidgetPredicate((widget) {
        if (widget is Container) {
          BoxConstraints? width = widget.constraints?.widthConstraints();
          return (width?.minWidth == width?.maxWidth) && (width?.minWidth == 0);
        } else {
          return false;
        }
      }), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.byWidgetPredicate((widget) {
        if (widget is Container) {
          BoxConstraints? width = widget.constraints?.widthConstraints();
          return (width?.minWidth == width?.maxWidth) &&
              (width?.minWidth == 300.0);
        } else {
          return false;
        }
      }), findsWidgets);
    });
  });
}
