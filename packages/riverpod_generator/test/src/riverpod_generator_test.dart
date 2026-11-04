import 'package:test/test.dart';

import 'prefixed_output.dart';

void main() {
  test('writes the type of dependencies with the prefix of its import', () {
    expectPrefixed(['ProviderOrFamily']);
  });
}
