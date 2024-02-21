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
          //  repositoryProvider এর আচরণ পরিবর্তন করে
          //  FakeRepository রিটার্ন করবে আসল Repository এর বদলে
          /* highlight-start */
          repositoryProvider.overrideWithValue(FakeRepository()),
          /* highlight-end */
          // আমাদের `todoListProvider` প্রভাইডার ওভাররাইড করার প্রয়োজন নেই,
          // এটি অটোমেটিকলী ওভাররাইডেন repositoryProvider ব্যবহার করবে
        ],
        child: MyApp(),
      ),
    );
  });

/* SNIPPET END */
}
