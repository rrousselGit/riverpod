import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils.dart';

part 'old_lifecycles.g.dart';

/* SNIPPET START */
@riverpod
class MyNotifier3 extends _$MyNotifier3 {
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
