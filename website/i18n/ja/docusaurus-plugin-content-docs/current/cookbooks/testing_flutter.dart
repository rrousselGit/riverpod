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
        // repositoryProvider の挙動をオーバーライドして
        // Repository の代わりに FakeRepository を戻り値とする
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository())
        /* highlight-end */
        // `todoListProvider` はオーバーライドされた repositoryProvider を
        // 自動的に利用することになるため、オーバーライド不要
      ],
      child: MyApp(),
    ),
  );
});

/* SNIPPET END */
}
