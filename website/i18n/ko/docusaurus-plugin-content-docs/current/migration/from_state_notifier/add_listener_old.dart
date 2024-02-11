// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */
class MyNotifier extends StateNotifier<int> {
  MyNotifier() : super(0);

  void add() => state++;
}

final myNotifierProvider = StateNotifierProvider<MyNotifier, int>((ref) {
  final notifier = MyNotifier();

  final cleanup = notifier.addListener((state) => debugPrint('$state'));
  ref.onDispose(cleanup);

  // 또는, 이와 동일하게:
  // final listener = notifier.stream.listen((event) => debugPrint('$event'));
  // ref.onDispose(listener.cancel);

  return notifier;
});
