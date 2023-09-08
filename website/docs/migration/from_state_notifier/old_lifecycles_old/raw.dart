import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils.dart';

/* SNIPPET START */
class MyNotifier extends StateNotifier<int> {
  MyNotifier(this.period) : super(0) {
    // 1 init logic
    _timer = Timer.periodic(period, (t) => update()); // 2 side effect on init
  }
  final Duration period;
  late final Timer _timer;

  void update() => state++; // 3 mutation

  @override
  void dispose() {
    _timer.cancel(); // 4 custom dispose logic
    super.dispose();
  }
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  // 5 provider definition
  final period = ref.watch(durationProvider); // 6 reactive dependency logic
  return MyNotifier(period);
});
