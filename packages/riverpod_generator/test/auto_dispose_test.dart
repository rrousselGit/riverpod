// ignore_for_file: omit_local_variable_types, unused_local_variable, invalid_use_of_internal_member

import 'package:riverpod/riverpod.dart' show ProviderContainer;
import 'package:test/test.dart';

import 'integration/auto_dispose.dart';

void main() {
  test('Respects keepAlive parameter', () {
    final container = ProviderContainer.test();

    expect(keepAliveProvider.isAutoDispose, isFalse);
  });
}
