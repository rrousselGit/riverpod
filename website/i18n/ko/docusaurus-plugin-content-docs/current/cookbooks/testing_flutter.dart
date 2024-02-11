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
        // repositoryProvider의 행위를 오버라이드하여
        // Repository 대신 FakeRepository를 반환합니다.
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository()),
        /* highlight-end */
        // 오버라이드된 repositoryProvider를 자동적으로 사용하기 때문에
        // `todoListProvider`를 override하지 않아도 됩니다.
      ],
      child: MyApp(),
    ),
  );
});

/* SNIPPET END */
}
