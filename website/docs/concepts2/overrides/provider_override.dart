// ignore_for_file: unused_local_variable, prefer_const_declarations, invalid_use_of_visible_for_testing_member

import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  /* SNIPPET START */

  test('can inspect which provider is overridden', () {
    final myProvider = Provider((ref) => 0);
    final override = myProvider.overrideWithValue(42);

    // Check which provider is being overridden
    expect(
      override,
      isA<ProviderOverride>().having((o) => o.origin, 'origin', myProvider),
    );
  });

  /* SNIPPET END */
}
