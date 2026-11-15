// GENERATED from packages/riverpod/lib/src/core/provider/notifier_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'dart:async';

import 'package:riverpod/misc.dart';

mixin MyMixin<T> on AnyNotifier<T, FutureOr<T>> {
  @override
  WhenComplete runBuild() {
    // It is safe to use "ref" here.
    listenSelf((prev, next) => print("New state $next"));

    print('Before build');
    final result = super.runBuild();
    print('After build');
    return result;
  }
}
