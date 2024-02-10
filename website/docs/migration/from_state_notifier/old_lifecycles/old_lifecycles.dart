import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../old_lifecycles_final/old_lifecycles_final.dart';

part 'old_lifecycles.g.dart';

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    // Just read/write the code here, in one place
    final period = ref.watch(durationProvider);
    final timer = Timer.periodic(period, (t) => update());
    ref.onDispose(timer.cancel);

    return 0;
  }

  Future<void> update() async {
    await ref.read(repositoryProvider).update(state + 1);
    // `mounted` is no more!
    state++; // This might throw.
  }
}
