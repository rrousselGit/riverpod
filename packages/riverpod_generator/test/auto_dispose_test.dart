// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/auto_dispose.dart';
import 'utils.dart';

void main() {
  test('Passes cacheTime/disposeDelay from the annotation', () {
    expect(TimersProvider.cacheTime, 10);
    expect(TimersProvider.disposeDelay, 20);

    expect(Timers2Provider.cacheTime, 12);
    expect(Timers2Provider.disposeDelay, 21);
    expect(Timers2Provider(42).cacheTime, 12);
    expect(Timers2Provider(42).disposeDelay, 21);
  });

  test('Respects keepAlive parameter', () {
    const AutoDisposeProvider<int> provider = TimersProvider;
    final AutoDisposeProvider<int> provider2 = Timers2Provider(42);
    final container = createContainer();

    container.read(KeepAliveProvider);

    expect(
      container.readProviderElement(KeepAliveProvider),
      isA<ProviderElement>(),
    );
    expect(
      container.readProviderElement(KeepAliveProvider),
      isNot(isA<AutoDisposeProviderElement>()),
    );
  });
}
