// Only uses the public library, as the packages built on it do.
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  test('the public library is enough to inspect an application', () async {
    final app = await startApp();
    final container = ProviderContainer.test(
      overrides: [appConnectionProvider.overrideWith((ref) => app.connection)],
    );
    container.listen(framesProvider, (_, _) {});

    final frames = await container.read(framesProvider.future);
    final counter = frames.last.elements.values.firstWhere(
      (element) => element.provider.origin.toStringValue == 'counterProvider',
    );
    final state = resolvedVariableForObjectProvider(counter.state.state);
    container.listen(state, (_, _) {});

    expect(
      await container.read(state.future),
      isA<ByteVariable<ResolvedVariable>>().having(
        (e) => e.instance,
        'instance',
        isA<IntVariable>().having((e) => e.value, 'value', 0),
      ),
    );

    final eval = await container.read(evalProvider.future);
    final result = await evalInTerminal(
      r'$state + 1',
      eval,
      state: counter.state.state,
      notifier: counter.notifier?.state,
      previous: null,
      isAlive: Disposable(),
    );

    expect(result, isA<ByteVariable<RootCachedObject>>());
  });
}
