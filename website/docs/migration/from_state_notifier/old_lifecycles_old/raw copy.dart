import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // Just read/write the code here, in one place
    final period = ref.watch(durationProvider);
    final timer = Timer.periodic(period, (t) => update());
    ref.onDispose(timer.cancel);

    return 0;
  }

  void update() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
