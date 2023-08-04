import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  late Timer _timer;
  @override
  int build() {
    final period = ref.watch(durationProvider);
    _timer = Timer.periodic(period, (t) => update());
    ref.onDispose(_timer.cancel);

    return 0;
  }

  void update() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
