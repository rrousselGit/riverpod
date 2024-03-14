import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose', () {
    group('ref.state', () {
      test('can read and change current value', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late Ref<int> ref;
        final provider = Provider.autoDispose<int>((r) {
          ref = r;
          return 0;
        });

        container.listen(provider, listener.call);
        verifyZeroInteractions(listener);

        expect(ref.state, 0);

        ref.state = 42;

        verifyOnly(listener, listener(0, 42));
        expect(ref.state, 42);
      });

      test('fails if trying to read the state before it was set', () {
        final container = ProviderContainer.test();
        Object? err;
        final provider = Provider.autoDispose<int>((ref) {
          try {
            ref.state;
          } catch (e) {
            err = e;
          }
          return 0;
        });

        container.read(provider);
        expect(err, isStateError);
      });

      test(
          'on rebuild, still fails if trying to read the state before was built',
          () {
        final dep = StateProvider((ref) => false);
        final container = ProviderContainer.test();
        Object? err;
        final provider = Provider.autoDispose<int>((ref) {
          if (ref.watch(dep)) {
            try {
              ref.state;
            } catch (e) {
              err = e;
            }
          }
          return 0;
        });

        container.read(provider);
        expect(err, isNull);

        container.read(dep.notifier).state = true;
        container.read(provider);

        expect(err, isStateError);
      });

      test('can read the state if the setter was called before', () {
        final container = ProviderContainer.test();
        final provider = Provider.autoDispose<int>((ref) {
          return ref.state = 42;
        });

        expect(container.read(provider), 42);
      });
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = Provider.autoDispose((ref) => result);

      expect(container.read(provider), 0);

      result = 1;
      expect(container.refresh(provider), 1);

      expect(container.read(provider), 1);
    });

    test('does not notify listeners when called ref.state= with == new value',
        () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();
      late Ref<int> ref;
      final provider = Provider.autoDispose<int>((r) {
        ref = r;
        return 0;
      });

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      ref.state = 0;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithValue', () {
        final provider = Provider.autoDispose(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWithValue(42),
          ],
        );

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWith', () {
        final provider = Provider.autoDispose(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref) => 42),
          ],
        );

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider(
        (ref) => 0,
        dependencies: const [],
      );
      final provider = Provider.autoDispose(
        (ref) => ref.watch(dep),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
