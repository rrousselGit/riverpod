// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final provider = Provider<int>((ref) {
  ref.watch(otherProvider); // Good!
  ref.onDispose(() => ref.watch(otherProvider)); // Bad!

  final someListenable = ValueNotifier(0);
  someListenable.addListener(() {
    ref.watch(otherProvider); // Bad!
  });

  return 0;
});

final notifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    ref.watch(otherProvider); // Good!
    ref.onDispose(() => ref.watch(otherProvider)); // Bad!

    return 0;
  }

  void increment() {
    ref.watch(otherProvider); // Bad!
  }
}
