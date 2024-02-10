// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/legacy.dart';

/* SNIPPET START */

// একটি কাউন্টার ইমপ্লিমেন্ট এবং টেস্টেড ফ্লাটার ব্যবহার করে

// আমরা প্রভাইডার গ্লোবালি ডিক্লার করেছি, এবং আমরা এটি দুইটি টেস্ট এ ব্যবহার করব, এটি দেখার জন্য যে,
// স্টেটটা সঠিকভাবে '0' তে রিসেট হই কিনা, টেস্টগুলার মধ্যে

final counterProvider = StateProvider((ref) => 0);

// বর্তমান স্টেট রেন্ডার করে এবং একটি বাটন যেটি স্টেট বাড়ানোতে সহায়তা করে
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
      },),
    );
  }
}

void main() {
  testWidgets('update the UI when incrementing the state', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // ডিফল্ট মান হল `0`, যেটি প্রভাইডার দ্বারা ডিক্লার হয়েছে
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // স্টেট বাড়ান এবং আবার রেনডার করা
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // স্টেট সঠিকভাবে বেড়েছে
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('the counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // স্টেটকে আবার `0` করা হল, কিন্তু কোন tearDown/setUp ছাড়াই
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
