import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../combine/combine.dart';

/* SNIPPET START */

void main() {
  test('raddoppia il valore correttamente', () async {
    final container = ProviderContainer(
      overrides: [numberProvider.overrideWith((ref) => 9)],
    );
    final doubled = container.read(doubledProvider);
    expect(doubled, 9 * 2);
  });
}
