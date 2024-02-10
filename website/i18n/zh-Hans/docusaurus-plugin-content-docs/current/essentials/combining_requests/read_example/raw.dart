// ignore_for_file: unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final notifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // 糟糕的！不要在这里使用 "read"，因为它不是反应性的
    ref.read(otherProvider);

    return 0;
  }

  void increment() {
    ref.read(otherProvider); // 这里使用 "read" 就可以了
  }
}
