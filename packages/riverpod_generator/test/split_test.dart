// Regression test for https://github.com/rrousselGit/riverpod/issues/4306
// Tests that providers from all part files are generated

import 'package:test/test.dart';

import 'integration/split.dart';

void main() {
  test('Generates providers from all part files', () {
    expect(counter2Provider.name, 'counter2Provider');
    expect(counterProvider.name, 'counterProvider');
  });
}
