// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
final notifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // {@template read}
    // Bad! Do not use "read" here as it is not reactive
    // {@endtemplate}
    ref.read(otherProvider);

    return 0;
  }

  void increment() {
    // {@template read2}
    ref.read(otherProvider); // Using "read" here is fine
    // {@endtemplate}
  }
}
