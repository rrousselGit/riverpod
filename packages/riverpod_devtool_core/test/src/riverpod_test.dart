import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/src/riverpod.dart';
import 'package:test/test.dart';

void main() {
  test('StateNotifier exposes mutable state through a NotifierProvider', () {
    final provider = NotifierProvider<StateNotifier<int>, int>(
      () => StateNotifier((ref, self) => 41),
    );
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    expect(container.read(provider), 41);

    final notifier = container.read(provider.notifier);
    expect(notifier.stateOrNull, 41);

    notifier.state = 42;

    expect(container.read(provider), 42);
    expect(notifier.stateOrNull, 42);
  });
}
