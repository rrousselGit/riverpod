import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose', () {
    test('can benefit from .future extension if returning an AsyncValue',
        () async {
      final container = createContainer();
      final provider = Provider.autoDispose((ref) => const AsyncValue.data(42));

      container.listen(provider, (previous, next) {});

      await expectLater(container.read(provider.future), completion(42));
    });

    test('can benefit from .stream extension if returning an AsyncValue',
        () async {
      final container = createContainer();
      final provider = Provider.autoDispose((ref) => const AsyncValue.data(42));

      container.listen(provider, (previous, next) {});

      await expectLater(container.read(provider.stream), emits(42));
    });

    group('ref.state', () {
      test('can read and change current value', () {
        final container = createContainer();
        final listener = Listener<int>();
        late ProviderRef<int> ref;
        final provider = Provider.autoDispose<int>((r) {
          ref = r;
          return 0;
        });

        container.listen(provider, listener);
        verifyZeroInteractions(listener);

        expect(ref.state, 0);

        ref.state = 42;

        verifyOnly(listener, listener(0, 42));
        expect(ref.state, 42);
      });

      test('fails if trying to read the state before it was set', () {
        final container = createContainer();
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
        final container = createContainer();
        Object? err;
        final provider = Provider.autoDispose<int>((ref) {
          if (ref.watch(dep.state).state) {
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

        container.read(dep.state).state = true;
        container.read(provider);

        expect(err, isStateError);
      });

      test('can read the state if the setter was called before', () {
        final container = createContainer();
        final provider = Provider.autoDispose<int>((ref) {
          // ignore: join_return_with_assignment
          ref.state = 42;

          return ref.state;
        });

        expect(container.read(provider), 42);
      });
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = createContainer();
      final provider = Provider.autoDispose((ref) => result);

      expect(container.read(provider), 0);

      result = 1;
      expect(container.refresh(provider), 1);

      expect(container.read(provider), 1);
    });

    test('does not notify listeners when called ref.state= with == new value',
        () async {
      final container = createContainer();
      final listener = Listener<int>();
      late AutoDisposeProviderRef<int> ref;
      final provider = AutoDisposeProvider<int>((r) {
        ref = r;
        return 0;
      });

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      ref.state = 0;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithValue', () {
        final provider = Provider.autoDispose((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(42),
        ]);

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithProvider', () {
        final provider = Provider.autoDispose((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(Provider.autoDispose((ref) => 42)),
        ]);

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be overridden by anything', () {
      final provider = Provider.autoDispose((_) => 42);
      final AutoDisposeProviderBase<int> override = Provider.autoDispose((_) {
        return 21;
      });
      final container = createContainer(overrides: [
        provider.overrideWithProvider(override),
      ]);

      expect(container.read(provider), 21);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = Provider.autoDispose(
        (ref) => ref.watch(dep),
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
