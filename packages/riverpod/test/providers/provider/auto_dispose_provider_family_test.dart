import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose.family', () {
    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider(0))
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () {
        final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            (value) => Provider.autoDispose((ref) => 42),
          ),
        ]);

        expect(root.getAllProviderElements(), isEmpty);
        expect(container.read(provider(0)), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>()
              .having((e) => e.origin, 'origin', provider(0))
        ]);
      });
    });
  });

  test('Provider.autoDispose.family', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      ref.onDispose(onDispose);
      return '$value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(provider(0), listener, fireImmediately: true);

    verifyOnly(listener, listener('0'));

    sub.close();

    verifyZeroInteractions(onDispose);

    await container.pump();

    verifyOnly(onDispose, onDispose());
  });

  test('Provider.autoDispose.family override', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      return '$value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((value) {
        return Provider.autoDispose<String>((ref) {
          ref.onDispose(onDispose);
          return '$value override';
        });
      })
    ]);
    addTearDown(container.dispose);

    final sub = container.listen(provider(0), listener, fireImmediately: true);

    verifyOnly(listener, listener('0 override'));

    sub.close();

    verifyZeroInteractions(onDispose);

    await container.pump();

    verifyOnly(onDispose, onDispose());
  });
}
