import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderContainer', () {
    testWidgets('Does not cause Timer issue when used in widget tests',
        (tester) async {
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(parent: root);
      final provider = Provider((ref) => 0);

      root.read(provider);
      root.invalidate(provider);
      container.read(provider);
      container.invalidate(provider);

      // Needed due to https://github.com/flutter/flutter/issues/144472
      root.dispose();
    });
  });
}
