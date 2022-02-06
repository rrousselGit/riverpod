// ignore_for_file: avoid_print

/* SNIPPET START */

import 'package:riverpod/riverpod.dart';

// আমরা একটি "প্রভাইডার" তৈরি করি, যা একটি মান সংরক্ষণ করবে (এখানে "Hello World")।
// একটি প্রভাইডার ব্যবহার করে, এটি আমাদের উন্মুক্ত মানকে মক/ওভাররাইড করতে দেয়।
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  // এখানে আমাদের প্রভাইডারদের স্টেট সংরক্ষণ করা হবে।
  final container = ProviderContainer();

  // ধন্যবাদ "container" কে, যেটি আমাদের প্রভাইডারসগুলা পড়তে দেই.
  final value = container.read(helloWorldProvider);

  print(value); // Hello world
}
