// ignore_for_file: unused_local_variable, prefer_const_declarations, invalid_use_of_visible_for_testing_member

import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  /* SNIPPET START */

  test('can inspect which family is overridden', () {
    final myFamily = Provider.family<int, String>((ref, id) => 0);
    final override = myFamily.overrideWith((ref, id) => 42);

    // Check which family is being overridden
    expect(
      override,
      isA<FamilyOverride>().having((o) => o.from, 'from', myFamily),
    );
  });

  /* SNIPPET END */
}
