import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

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
          // 覆盖 repositoryProvider 的行为，以返回 FakeRepository 而不是 Repository。
          /* highlight-start */
          repositoryProvider.overrideWithValue(FakeRepository())
          /* highlight-end */
          // 我们不需要覆盖 `todoListProvider`，它将自动使用覆盖的 repositoryProvider
        ],
        child: MyApp(),
      ),
    );
  });

/* SNIPPET END */
}
