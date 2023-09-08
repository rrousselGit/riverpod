// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state++;
}

final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);
