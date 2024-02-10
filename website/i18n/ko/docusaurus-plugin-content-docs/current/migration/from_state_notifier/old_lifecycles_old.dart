import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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
    // 1 초기화로직
    _timer = Timer.periodic(period, (t) => update()); // 2 초기화시 부가작업
  }
  final Duration period;
  final Ref ref;
  late final Timer _timer;

  Future<void> update() async {
    await ref.read(repositoryProvider).update(state + 1); // 3 변이(mutation)
    if (mounted) state++; // 4 마운트된 속성 확인
  }

  @override
  void dispose() {
    _timer.cancel(); // 5 커스텀 폐기(dispose) 로직
    super.dispose();
  }
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  // 6 provider 정의
  final period = ref.watch(durationProvider); // 7 리액티브 종속성 로직
  return MyNotifier(ref, period); // 8 `ref`로 연결(pipe down)
});
