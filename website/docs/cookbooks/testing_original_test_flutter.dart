// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// Ein Zähler implementiert und getestet mit Flutter

// Wir haben einen Provider global deklariert und werden ihn in zwei Tests
// verwenden, um zu sehen, ob der Zustand zwischen den Tests korrekt auf `0`
// zurückgesetzt wird.

final counterProvider = StateProvider((ref) => 0);

// Zeigt den aktuellen Status und eine Schaltfläche an, mit der der Status erhöht werden kann
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

    // Der Standardwert ist `0`, wie in unserem Provider definiert
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Inkrementiere den Zustand und re-rendern
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Der Zustand wurde ordnungsgemäß inkrementiert
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // Der Zustand ist wieder `0`, auch ohne tearDown/setUp
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
