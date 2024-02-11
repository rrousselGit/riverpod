// ignore_for_file: unused_local_variable,omit_local_variable_types

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }
}

final myNotifierProvider =
    NotifierProvider.autoDispose<MyNotifier, int>(MyNotifier.new);

/* SNIPPET START */
void main(List<String> args) {
  test('my test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Obtaining a notifier
    /* highlight-start */
    final Notifier<int> notifier = container.read(myNotifierProvider.notifier);
    /* highlight-end */

    // Obtaining its exposed state
    /* highlight-start */
    final int state = container.read(myNotifierProvider);
    /* highlight-end */

    // TODO write your tests
  });
}
