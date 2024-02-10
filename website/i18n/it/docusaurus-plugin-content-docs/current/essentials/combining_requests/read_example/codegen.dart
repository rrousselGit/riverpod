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
    // Non buono! Non usare "read" qui dato che non è reattivo
    ref.read(otherProvider);

    return 0;
  }

  void increment() {
    ref.read(otherProvider); // Usare "read" qui va bene
  }
}
