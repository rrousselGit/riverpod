import 'package:test/test.dart';

import '../prefixed_output.dart';

void main() {
  test('writes families with the prefix of their import', () {
    expectPrefixed([
      r'$Family',
      r'$FunctionalFamilyOverride',
      r'$ClassFamilyOverride',
      r'$FamilyOverride',
      'Override',
      'Ref',
    ]);
  });
}
