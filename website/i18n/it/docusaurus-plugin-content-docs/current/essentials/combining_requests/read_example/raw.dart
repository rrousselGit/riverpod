// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final notifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
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
