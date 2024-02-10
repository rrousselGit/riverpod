// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  ref.watch(otherProvider); // 好！
  ref.onDispose(() => ref.watch(otherProvider)); // 糟糕！

  final someListenable = ValueNotifier(0);
  someListenable.addListener(() {
    ref.watch(otherProvider); // 糟糕！
  });

  return 0;
}

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    ref.watch(otherProvider); // 好！
    ref.onDispose(() => ref.watch(otherProvider)); // 糟糕！

    return 0;
  }

  void increment() {
    ref.watch(otherProvider); // 糟糕！
  }
}
