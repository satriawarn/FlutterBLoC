import 'package:flutter/material.dart';
import 'package:flutter_state_bloc/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('widget testing', () {
    testWidgets('Add and remove a todo', (tester) async {
      // Build the widget.
      await tester.pumpWidget(const TestingApp());

      // Enter 'hi' into the TextField.
      await tester.enterText(find.byType(TextField), 'hi');

      // Tap the add button.
      await tester.tap(find.byType(FloatingActionButton));

      // Rebuild the widget with the new item.
      await tester.pump();

      // Expect to find the item on screen.
      expect(find.text('hi'), findsOneWidget);

      // Swipe the item to dismiss it.
      await tester.drag(find.byType(Dismissible), const Offset(500.0, 0.0));

      // Build the widget until the dismiss animation ends.
      await tester.pumpAndSettle();

      // Ensure that the item is no longer on screen.
      expect(find.text('hi'), findsNothing);
    });
  });
}
