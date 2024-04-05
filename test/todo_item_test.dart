import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowunity_todo/pages/home/widgets/todo_item.dart';

void main() {
  //write a test for todo_item.dart

  group("Test - TodoItem Widget", () {
    Future<void> pumpTodoItem(WidgetTester tester, bool completed) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TodoItem(
            title: 'Test Todo',
            completed: completed,
          ),
        ),
      );
    }

    testWidgets(
        'TodoItem should display the title and open status. Checkmark should be unchecked',
        (WidgetTester tester) async {
      await pumpTodoItem(tester, false);

      final titleFinder = find.text('Test Todo');
      expect(titleFinder, findsOneWidget);

      final checkboxFinder = find.byType(Checkbox);
      final checkbox = tester.widget(checkboxFinder) as Checkbox;
      expect(checkbox.value, false);

      await tester.pump();
    });

    testWidgets(
        'TodoItem should display the title and completed status. Checkbox should be checked.',
        (WidgetTester tester) async {
      await pumpTodoItem(tester, true);

      final titleFinder = find.text('Test Todo');
      expect(titleFinder, findsOneWidget);

      final checkboxFinder = find.byType(Checkbox);
      final checkbox = tester.widget(checkboxFinder) as Checkbox;
      expect(checkbox.value, true);

      await tester.pump();
    });
  });
}
