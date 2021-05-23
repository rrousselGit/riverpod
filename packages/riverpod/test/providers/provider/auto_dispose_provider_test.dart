import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('Provider.autoDispose can be overriden by auto-dispose providers', () {
    final provider = Provider.autoDispose((_) => 42);
    final AutoDisposeProviderBase<int> override =
        Provider.autoDispose((_) => 21);
    final container = createContainer(overrides: [
      provider.overrideWithProvider(override),
    ]);

    final sub = container.listen(provider, (_) {});

    expect(sub.read(), 21);
  });
}
