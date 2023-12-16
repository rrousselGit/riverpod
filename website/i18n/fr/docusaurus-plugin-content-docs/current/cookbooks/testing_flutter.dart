import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          // Surcharge le comportement de repositoryProvider pour qu'il renvoie
          // FakeRepository au lieu de Repository.
          /* highlight-start */
          repositoryProvider.overrideWithValue(FakeRepository())
          /* highlight-end */
          // Il n'est pas nécessaire de surcharger `todoListProvider`,
          // il utilisera automatiquement le repositoryProvider surchargé.
        ],
        child: const MyApp(),
      ),
    );
  });

/* SNIPPET END */
}
