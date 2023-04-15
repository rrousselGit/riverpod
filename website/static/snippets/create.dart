// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final counterProvider = StateNotifierProvider<Counter, int>((ref) {
  return Counter();
});

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  void increment() => state++;
}
