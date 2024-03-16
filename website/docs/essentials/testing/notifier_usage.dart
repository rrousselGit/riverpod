// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notifier_mock/codegen.dart';

/* SNIPPET START */
void main() {
  test('Some description', () {
    final container = ProviderContainer.test(
      // Override the provider to have it create our mock Notifier.
      overrides: [myNotifierProvider.overrideWith(MyNotifierMock.new)],
    );

    // Then obtain the mocked notifier through the container:
    final notifier = container.read(myNotifierProvider.notifier);

    // You can then interact with the notifier as you would with the real one:
    notifier.state = 42;
  });
}
