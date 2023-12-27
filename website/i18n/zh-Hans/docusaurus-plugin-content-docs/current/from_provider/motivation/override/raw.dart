import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../combine/combine.dart';

/* SNIPPET START */
void main() {
  test('这个值将正确的翻倍', () async {
    final container = ProviderContainer(
      overrides: [numberProvider.overrideWith((ref) => 9)],
    );
    final doubled = container.read(doubledProvider);
    expect(doubled, 9 * 2);
  });
}
