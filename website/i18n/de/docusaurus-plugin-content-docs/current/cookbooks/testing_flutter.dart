import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final repositoryProvider = Provider((ref) => FakeRepository());

class FakeRepository {}

void main() {
/* SNIPPET START */

  testWidgets('override repositoryProvider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Überschreiben Sie das Verhalten von repositoryProvider, um
          // FakeRepository anstelle von Repository zurückzugeben.
          /* highlight-start */
          repositoryProvider.overrideWithValue(FakeRepository())
          /* highlight-end */
          // Wir müssen den `todoListProvider` nicht überschreiben, er wird
          // automatisch den überschriebenen repositoryProvider verwenden
        ],
        child: MyApp(),
      ),
    );
  });

/* SNIPPET END */
}
