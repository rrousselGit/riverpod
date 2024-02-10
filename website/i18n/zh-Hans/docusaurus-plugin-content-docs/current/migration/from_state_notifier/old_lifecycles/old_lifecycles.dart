// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../utils.dart';

part 'old_lifecycles.g.dart';

@riverpod
_MyRepo repository(RepositoryRef ref) {
  return _MyRepo();
}

class _MyRepo {
  Future<void> update(int i, {CancelToken? token}) async {}
}

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
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
