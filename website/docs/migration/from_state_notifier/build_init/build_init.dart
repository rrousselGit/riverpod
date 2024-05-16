// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'build_init.g.dart';

/* SNIPPET START */
@riverpod
class CounterNotifier extends _$CounterNotifier {
  @override
  int build() => 0;

  void increment() => state++;
  void decrement() => state--;
}
