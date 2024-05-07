import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    // {@template period}
    // Just read/write the code here, in one place
    // {@endtemplate}
    final period = ref.watch(durationProvider);
    final timer = Timer.periodic(period, (t) => update());
    ref.onDispose(timer.cancel);

    return 0;
  }

  Future<void> update() async {
    final cancelToken = CancelToken();
    ref.onDispose(cancelToken.cancel);
    await ref.read(repositoryProvider).update(state + 1, token: cancelToken);
    state++;
  }
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
