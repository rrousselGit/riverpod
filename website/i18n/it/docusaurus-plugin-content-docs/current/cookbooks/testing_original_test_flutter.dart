// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// Un contatore implementato e testato usando Flutter

// Abbiamo dichiarato un provider globalmente e lo useremo in due test
// per vedere se lo stato si resetta correttamente a `0` tra i test.

final counterProvider = StateProvider((ref) => 0);

// Renderizza lo stato corrente e un bottone che incrementa lo stato
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

    // Il valore di default è `0`, come dichiarato nel provider
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Incrementa lo stato e ri-renderizza
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Lo stato si è incrementato correttamente
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // Lo stato è `0` di nuovo, con nessun metodo tearDown/setUp necessario
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
