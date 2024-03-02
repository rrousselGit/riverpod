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
      // Equivalente di `container.read(provider)`
      // Ma il provider non verrà distrutto a meno che "subscription" non venga distrutta.
      subscription.read(),
      'Some value',
    );
    /* SNIPPET END */
  });
}
