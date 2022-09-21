// ignore_for_file: omit_local_variable_types, unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import 'integration/auto_dispose.dart';
import 'utils.dart';

void main() {
  test('Passes cacheTime/disposeDelay from the annotation', () {
    expect(timersProvider.cacheTime, 10);
    expect(timersProvider.disposeDelay, 20);

    expect(timers2Provider.cacheTime, 12);
    expect(timers2Provider.disposeDelay, 21);
    expect(timers2Provider(42).cacheTime, 12);
    expect(timers2Provider(42).disposeDelay, 21);
  });

  test('Respects keepAlive parameter', () {
    final AutoDisposeProvider<int> provider = timersProvider;
    final AutoDisposeProvider<int> provider2 = timers2Provider(42);
    final container = createContainer();

    container.read(keepAliveProvider);

    expect(
      container.readProviderElement(keepAliveProvider),
      isA<ProviderElement>(),
    );
    expect(
      container.readProviderElement(keepAliveProvider),
      isNot(isA<AutoDisposeProviderElement>()),
    );
  });
}
