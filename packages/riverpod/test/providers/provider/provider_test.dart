import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider', () {
    test('can benefit from .future extension if returning an AsyncValue',
        () async {
      final container = createContainer();
      final provider = Provider((ref) => const AsyncValue.data(42));

      await expectLater(container.read(provider.future), completion(42));
    });

    test('can benefit from .stream extension if returning an AsyncValue',
        () async {
      final container = createContainer();
      final provider = Provider((ref) => const AsyncValue.data(42));

      await expectLater(container.read(provider.stream), emits(42));
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = createContainer();
      final provider = Provider((ref) => result);

      expect(container.read(provider), 0);

      result = 1;
      expect(container.refresh(provider), 1);

      expect(container.read(provider), 1);
    });

    group('ref.state', () {
      test('throws on providers that threw', () {
        final container = createContainer();
        final provider = Provider((ref) => throw UnimplementedError());

        expect(
          () => container.read(provider),
          throwsA(isA<ProviderException>()),
        );

        final element =
            container.readProviderElement(provider) as ProviderElement;

        expect(
          () => element.state,
          throwsA(isA<ProviderException>()),
        );
      });

      test('can read and change current value', () {
        final container = createContainer();
        final listener = Listener<int>();
        late ProviderRef<int> ref;
        final provider = Provider<int>((r) {
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
        final provider = Provider<int>((ref) {
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
        final provider = Provider<int>((ref) {
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
        final provider = Provider<int>((ref) {
          // ignore: join_return_with_assignment
          ref.state = 42;

          return ref.state;
        });

        expect(container.read(provider), 42);
      });
    });

    test('does not notify listeners when called ref.state= with == new value',
        () async {
      final container = createContainer();
      final listener = Listener<int>();
      late ProviderRef<int> ref;
      final provider = Provider<int>((r) {
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
        final provider = Provider((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(container.read(provider), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWithValue', () {
        final provider = Provider((ref) => 0);
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
        final provider = Provider((ref) => 0);
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(Provider((ref) => 42)),
        ]);

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider)
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    group('override', () {
      test('Provider can be overridden by anything', () {
        final provider = Provider((_) => 42);
        final AlwaysAliveProviderBase<int> override = Provider((_) {
          return 21;
        });
        final container = createContainer(overrides: [
          provider.overrideWithProvider(override),
        ]);

        expect(container.read(provider), 21);
      });

      test('does not notify listeners if updated with the same value', () {
        final provider = Provider((ref) => 0);
        final container = createContainer(overrides: [
          provider.overrideWithValue(42),
        ]);
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        container.updateOverrides([
          provider.overrideWithValue(42),
        ]);

        expect(container.read(provider), 42);
        verifyNoMoreInteractions(listener);
      });

      test('notify listeners when value changes', () {
        final provider = Provider((ref) => 0);
        final container = createContainer(overrides: [
          provider.overrideWithValue(42),
        ]);
        final listener = Listener<int>();

        addTearDown(container.dispose);

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(null, 42));

        container.updateOverrides([
          provider.overrideWithValue(21),
        ]);

        verifyOnly(listener, listener(42, 21));
      });
    });

    test('can specify name', () {
      final provider = Provider(
        (_) => 0,
        name: 'example',
      );

      expect(provider.name, 'example');

      final provider2 = Provider((_) => 0);

      expect(provider2.name, isNull);
    });

    test('is AlwaysAliveProviderBase', () {
      // ignore: unused_local_variable, testing that Provider can be assigned to AlwaysAliveProviderBase
      final AlwaysAliveProviderBase provider = Provider<int>((_) => 42);
    });
  });

  test('dispose', () {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose);
      return 42;
    });

    expect(container.read(provider), 42);

    verifyZeroInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
  });

  test('Read creates the value only once', () {
    final container = createContainer();
    var callCount = 0;
    final provider = Provider((ref) {
      callCount++;
      return 42;
    });

    expect(callCount, 0);
    expect(container.read(provider), 42);
    expect(callCount, 1);

    expect(container.read(provider), 42);
    expect(callCount, 1);
  });

  test("rebuild don't notify clients if == doesn't change", () {
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    var buildCount = 0;
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, true));
    expect(sub.read(), true);
    expect(buildCount, 1);

    counter.increment();
    counter.increment();

    expect(sub.read(), true);
    expect(buildCount, 2);
    verifyNoMoreInteractions(listener);
  });

  test('rebuild notify clients if == did change', () {
    final container = createContainer();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, true));
    expect(sub.read(), true);

    counter.increment();

    expect(sub.read(), false);
    verifyOnly(listener, listener(true, false));
  });

  test('can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider = Provider(
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
}
