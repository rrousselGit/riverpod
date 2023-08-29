// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_listener.g.dart';

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    ref.listenSelf((_, next) => debugPrint('$next'));
    return 0;
  }

  void add() => state++;
}
