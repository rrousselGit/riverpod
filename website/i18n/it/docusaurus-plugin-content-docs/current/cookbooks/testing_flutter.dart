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
          // Sovrascrive il comportamento di repositoryProvider per restituire
          // FakeRepository al posto di Repository.
          /* highlight-start */
          repositoryProvider.overrideWithValue(FakeRepository()),
          /* highlight-end */
          // Non dobbiamo sovrascrivere `todoListProvider`,
          // utilizzerà automaticamente il repositoryProvider sovrascritto
        ],
        child: MyApp(),
      ),
    );
  });
/* SNIPPET END */
}
