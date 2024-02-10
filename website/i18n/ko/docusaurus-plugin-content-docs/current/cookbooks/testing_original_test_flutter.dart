// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// A Counter implemented and tested using Flutter

// We declared a provider globally, and we will use it in two tests, to see
// if the state correctly resets to `0` between tests.

final counterProvider = StateProvider((ref) => 0);

// Renders the current state and a button that allows incrementing the state
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer(builder: (context, ref, _) {
        final counter = ref.watch(counterProvider);
        return ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('$counter'),
        );
      }),
    );
  }
}

void main() {
  testWidgets('update the UI when incrementing the state', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // The default value is `0`, as declared in our provider
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Increment the state and re-render
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // The state have properly incremented
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // The state is `0` once again, with no tearDown/setUp needed
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
