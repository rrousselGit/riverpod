import 'package:test/test.dart';

import 'prefixed_output.dart';

void main() {
  test('writes the persist API with the prefix of its import', () {
    expectPrefixed([
      'PersistResult',
      'FutureOr',
      'Storage',
      'StorageOptions',
      'NotifierPersistX',
      r'$jsonCodex',
    ]);
  });
}
