// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = Provider((_) => 'Hello world');

void main() {
  test('Some description', () {
    final container = createContainer();
    /* SNIPPET START */
    final subscription = container.listen<String>(provider, (_, __) {});

    expect(
      // {@template read}
      // Equivalent to `container.read(provider)`
      // But the provider will not be disposed unless "subscription" is disposed.
      // {@endtemplate}
      subscription.read(),
      'Some value',
    );
    /* SNIPPET END */
  });
}
