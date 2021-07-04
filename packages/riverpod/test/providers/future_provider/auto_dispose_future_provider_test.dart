import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider.autoDispose((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });

    test('when using provider.overrideWithValue', () async {
      final provider = FutureProvider.autoDispose((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = FutureProvider.autoDispose((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
            FutureProvider.autoDispose((ref) async => 42)),
      ]);

      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });
  });

  test('FutureProvider.autoDispose', () async {
    var future = Future.value(42);
    final onDispose = OnDisposeMock();
    final provider = FutureProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return future;
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    sub.close();
    await container.pump();

    verifyOnly(onDispose, onDispose());

    future = Future.value(21);

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    await container.pump();

    verifyOnly(listener, listener(const AsyncValue.data(21)));
  });
}
