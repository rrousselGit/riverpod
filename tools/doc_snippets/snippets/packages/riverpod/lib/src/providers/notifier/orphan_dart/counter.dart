// GENERATED from packages/riverpod/lib/src/providers/notifier/orphan.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

// The snippet that defines Counter, for the ones that use it.
import 'counter.dart';

final counterProvider = NotifierProvider<Counter, int>(Counter.new);

class Counter extends Notifier<int> {
  @override
  int build() {
    // Inside "build", we return the initial state of the counter.
    return 0;
  }

  void increment() {
    state++;
  }
}
