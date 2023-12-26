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
    // 1 初始化逻辑
    _timer = Timer.periodic(period, (t) => update()); // 2 初始化副作用
  }
  final Duration period;
  final Ref ref;
  late final Timer _timer;

  Future<void> update() async {
    await ref.read(repositoryProvider).update(state + 1); // 3 发生突变
    if (mounted) state++; // 4 检测挂载属性
  }

  @override
  void dispose() {
    _timer.cancel(); // 5 自定义处置逻辑
    super.dispose();
  }
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  // 6 提供者程序定义
  final period = ref.watch(durationProvider); // 7 反应式依赖逻辑
  return MyNotifier(ref, period); // 8 传递 `ref`
});
