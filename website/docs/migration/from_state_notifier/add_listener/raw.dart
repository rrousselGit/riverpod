// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
class MyNotifier extends Notifier<int> {
  @override
  int build() {
    ref.listenSelf((_, next) => debugPrint('$next'));
    return 0;
  }

  void add() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
