import 'package:test/test.dart';

import '../prefixed_output.dart';

void main() {
  test('writes @ProviderFor with the prefix of its import', () {
    expectPrefixed(['ProviderFor']);
  });
}
