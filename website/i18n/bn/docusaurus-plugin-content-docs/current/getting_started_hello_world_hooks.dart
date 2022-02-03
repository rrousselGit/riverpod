// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types

/* SNIPPET START */

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// আমরা একটি "প্রভাইডার" তৈরি করি, যা একটি মান সংরক্ষণ করবে (এখানে "Hello World")।
// একটি প্রভাইডার ব্যবহার করে, এটি আমাদের উন্মুক্ত মানকে মক/ওভাররাইড করতে দেয়।
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // উইজেটগুলি প্রভাইডার রিড করতে সক্ষম হওয়ার জন্য, আমাদের পুরোটাই এ্যাপ
    // একটি "ProviderScope" উইজেটে মোড়ানো (Wrap) দরকার।
    // এখানে আমাদের প্রভাইডারদের স্টেট সংরক্ষণ করা হবে।
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// নোট: MyApp একটি HookConsumerWidget, যেটি flutter_hooks থেকে নেওয়া.
class MyApp extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // আমাদের প্রভাইডার পড়তে, আমরা hook এর "ref.watch(" ব্যবহার করতে পারি।
    // এটি শুধুমাত্র সম্ভব কারণ MyApp একটি HookConsumerWidget।
    final String value = ref.watch(helloWorldProvider);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
