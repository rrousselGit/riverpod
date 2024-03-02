// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:todos/main.dart';

const firstItemText = 'Buy cookies';
const secondItemText = 'Star Riverpod';
const thirdItemText = 'Have a walk';

void main() {
  final addTodoInput = find.byKey(addTodoKey);
  final activeFilterButton = find.byKey(activeFilterKey);
  final firstItem = find.byKey(const Key('todo-0'));
  final firstCheckbox = find.descendant(
    of: firstItem,
    matching: find.byType(Checkbox),
  );
  final secondItem = find.byKey(const Key('todo-1'));
  final secondCheckbox = find.descendant(
    of: secondItem,
    matching: find.byType(Checkbox),
  );
  final thirdItem = find.byKey(const Key('todo-2'));
  final thirdCheckbox = find.descendant(
    of: thirdItem,
    matching: find.byType(Checkbox),
  );

  testWidgets(
    'Render the default todos',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(
        find.descendant(of: firstItem, matching: find.text(firstItemText)),
        findsOneWidget,
      );
      expect(
        tester.widget(firstCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );
      expect(
        find.descendant(of: secondItem, matching: find.text(secondItemText)),
        findsOneWidget,
      );
      expect(
        tester.widget(secondCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );
      expect(
        find.descendant(of: thirdItem, matching: find.text(thirdItemText)),
        findsOneWidget,
      );
      expect(
        tester.widget(thirdCheckbox),
        isA<Checkbox>().having((s) => s.value, 'value', false),
      );

      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('initial_state.png'),
      );
    },
    skip: !Platform.isMacOS,
  );

  testWidgets('Clicking on checkbox toggles the todo', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(
      tester.widget(firstCheckbox),
      isA<Checkbox>().having((s) => s.value, 'value', false),
    );
    expect(find.text('3 items left'), findsOneWidget);
    expect(find.text('2 items left'), findsNothing);

    await tester.tap(firstCheckbox);
    await tester.pump();

    expect(
      tester.widget(firstCheckbox),
      isA<Checkbox>().having((s) => s.value, 'value', true),
    );
    expect(find.text('2 items left'), findsOneWidget);
    expect(find.text('3 items left'), findsNothing);
  });

  testWidgets('Editing the todo on unfocus', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(
      find.descendant(of: firstItem, matching: find.text(firstItemText)),
      findsOneWidget,
    );

    await tester.tap(firstItem);
    // wait for the textfield to appear
    await tester.pump();

    // don't use tester.enterText to check that the textfield is auto-focused
    tester.testTextInput.enterText('new description');
    tester.testTextInput.closeConnection();

    await tester.pump();

    expect(
      find.descendant(of: firstItem, matching: find.text(firstItemText)),
      findsNothing,
    );
    expect(
      find.descendant(of: firstItem, matching: find.text('new description')),
      findsOneWidget,
    );
  });

  testWidgets('Editing the todo on done', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(
      find.descendant(of: firstItem, matching: find.text(firstItemText)),
      findsOneWidget,
    );

    await tester.tap(firstItem);
    // wait for the textfield to appear
    await tester.pump();

    // don't use tester.enterText to check that the textfield is auto-focused
    tester.testTextInput.enterText('new description');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    await tester.pump();

    expect(
      find.descendant(of: firstItem, matching: find.text(firstItemText)),
      findsNothing,
    );
    expect(
      find.descendant(of: firstItem, matching: find.text('new description')),
      findsOneWidget,
    );
  });

  testWidgets('Dismissing the todo', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(firstItem, findsOneWidget);

    // dismiss the item
    await tester.drag(firstItem, const Offset(1000, 0));

    // wait for animation to finish
    await tester.pumpAndSettle();

    expect(firstItem, findsNothing);
  });

  testWidgets('Clicking on Active shows only incomplete todos', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(firstItem, findsOneWidget);
    expect(secondItem, findsOneWidget);
    expect(thirdItem, findsOneWidget);

    await tester.tap(firstCheckbox);
    await tester.tap(activeFilterButton);

    await tester.pump();

    expect(firstItem, findsNothing);
    expect(secondItem, findsOneWidget);
    expect(thirdItem, findsOneWidget);
  });

  testWidgets(
    'The input allows adding todos',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      expect(find.text('Newly added todo'), findsNothing);
      expect(find.text('3 items left'), findsOneWidget);
      expect(find.text('4 items left'), findsNothing);

      await tester.enterText(addTodoInput, 'Newly added todo');

      expect(
        find.descendant(
          of: addTodoInput,
          matching: find.text('Newly added todo'),
        ),
        findsOneWidget,
      );

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // clears the input
      expect(
        find.descendant(
          of: addTodoInput,
          matching: find.text('Newly added todo'),
        ),
        findsNothing,
      );

      await expectLater(
        find.byType(MyApp),
        matchesGoldenFile('new_todo.png'),
      );

      expect(find.text('Newly added todo'), findsOneWidget);
      expect(find.text('4 items left'), findsOneWidget);
      expect(find.text('3 items left'), findsNothing);
    },
    skip: !Platform.isMacOS,
  );
}
