import 'package:riverpod/riverpod.dart' show ProviderContainer;
import 'package:test/test.dart';

import '../../integration/sync.dart';

void main() {
  test('overrideWithValue keeps the notifier usable', () {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/4699
    final familyProvider = familyClassProvider(42, third: .42);
    final container = ProviderContainer.test(
      overrides: [
        publicClassProvider.overrideWithValue('a'),
        familyProvider.overrideWithValue('b'),
      ],
    );

    expect(container.read(publicClassProvider), 'a');
    expect(container.read(publicClassProvider.notifier), isA<PublicClass>());

    final notifier = container.read(familyProvider.notifier);
    expect(notifier.first, 42);
    expect(notifier.state, 'b');

    notifier.state = 'c';
    expect(container.read(familyProvider), 'c');
  });
}
