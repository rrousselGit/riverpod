// GENERATED from website/docs/from_provider/quickstart.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Notifier, NotifierProvider;
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// The snippet that defines the MyNotifier to migrate, for the ones that use it.
import 'my_notifier.dart';

class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
