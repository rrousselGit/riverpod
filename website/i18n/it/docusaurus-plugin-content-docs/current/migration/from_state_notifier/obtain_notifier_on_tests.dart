// ignore_for_file: unused_local_variable,omit_local_variable_types

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }
}

final myNotifierProvider = NotifierProvider.autoDispose<MyNotifier, int>(MyNotifier.new);

/* SNIPPET START */
void main(List<String> args) {
  test('my test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Ottenendo un notifier
    /* highlight-start */
    final AutoDisposeNotifier<int> notifier = container.read(myNotifierProvider.notifier);
    /* highlight-end */

    // Ottenendo il suo stato esposto
    /* highlight-start */
    final int state = container.read(myNotifierProvider);
    /* highlight-end */

    // TODO scrivi i tuoi test
  });
}
