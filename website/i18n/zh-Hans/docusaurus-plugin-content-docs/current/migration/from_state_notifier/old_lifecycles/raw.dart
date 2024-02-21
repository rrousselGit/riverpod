import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';

import '../../utils.dart';

final repositoryProvider = Provider<_MyRepo>((ref) {
  return _MyRepo();
});

class _MyRepo {
  Future<void> update(int i, {CancelToken? token}) async {}
}

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() {
    // 只需在此处读取/写入代码，一目了然
    final period = ref.watch(durationProvider);
    final timer = Timer.periodic(period, (t) => update());
    ref.onDispose(timer.cancel);

    return 0;
  }

  Future<void> update() async {
    await ref.read(repositoryProvider).update(state + 1);
    // `mounted` 已不复存在！
    state++; // 这可能会抛出。
  }
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
