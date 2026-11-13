// GENERATED from packages/riverpod/lib/src/core/provider/notifier_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:async';

import 'package:riverpod/misc.dart';

mixin LoggingMixin<T> on AnyNotifier<T, T> {
  @override
  WhenComplete runBuild() {
    print('Will build $this');
    final result = super.runBuild();
    print('Did build $this');
    return result;
  }
}
