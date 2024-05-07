// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';

import 'create_container.dart';
import 'notifier_mock/codegen.dart';

/* SNIPPET START */
void main() {
  test('Some description', () {
    final container = createContainer(
      // {@template overrides}
      // Override the provider to have it create our mock Notifier.
      // {@endtemplate}
      overrides: [myNotifierProvider.overrideWith(MyNotifierMock.new)],
    );

    // {@template readNotifier}
    // Then obtain the mocked notifier through the container:
    // {@endtemplate}
    final notifier = container.read(myNotifierProvider.notifier);

    // {@template interactNotifier}
    // You can then interact with the notifier as you would with the real one:
    // {@endtemplate}
    notifier.state = 42;
  });
}
