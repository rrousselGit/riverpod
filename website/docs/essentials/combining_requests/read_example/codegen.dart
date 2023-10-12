// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    // Bad! Do not use "read" here as it is not reactive
    ref.read(otherProvider);

    return 0;
  }

  void increment() {
    ref.read(otherProvider); // Using "read" here is fine
  }
}
