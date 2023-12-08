// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/* SNIPPET START */

// Un compteur implémenté et testé avec Flutter

// Nous avons déclaré un provider globalement, et nous allons l'utiliser dans deux tests,
// pour voir si l'état se réinitialise correctement à `0` entre les tests.

final counterProvider = StateProvider((ref) => 0);

// Rend l'état actuel et un bouton qui permet d'incrémenter l'état
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

    // La valeur par défaut est `0`, comme déclaré dans notre provider
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Incrémenter l'état et refaire le rendu
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // L'État a correctement incrémenté
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // L'état est à nouveau `0`, sans qu'il soit nécessaire de procéder à un démontage (tearDown)/réinstallation (setUp).
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
