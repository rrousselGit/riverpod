import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils.dart';

final repositoryProvider = Provider<_MyRepo>((ref) {
  return _MyRepo();
});

class _MyRepo {
  Future<void> update(int i, {CancelToken? token}) async {}
}

/* SNIPPET START */
class MyNotifier extends StateNotifier<int> {
  MyNotifier(this.ref, this.period) : super(0) {
    // 1 init logic
    _timer = Timer.periodic(period, (t) => update()); // 2 side effect on init
  }
  final Duration period;
  final Ref ref;
  late final Timer _timer;

  Future<void> update() async {
    await ref.read(repositoryProvider).update(state + 1); // 3 mutation
    if (mounted) state++; // 4 check for mounted props
  }

  @override
  void dispose() {
    _timer.cancel(); // 5 custom dispose logic
    super.dispose();
  }
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  // 6 provider definition
  final period = ref.watch(durationProvider); // 7 reactive dependency logic
  return MyNotifier(ref, period); // 8 pipe down `ref`
});
