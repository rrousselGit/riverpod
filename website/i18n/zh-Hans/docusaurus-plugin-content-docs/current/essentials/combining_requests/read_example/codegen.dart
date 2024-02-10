// ignore_for_file: unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
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
