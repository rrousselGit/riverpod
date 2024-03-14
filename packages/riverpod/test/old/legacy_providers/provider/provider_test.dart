// ignore_for_file: avoid_types_on_closure_parameters

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider', () {
    test('supports overrideWith', () {
      final provider = Provider<int>((ref) => 0);
      final autoDispose = Provider.autoDispose<int>((ref) => 0);
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWith((Ref<int> ref) => 42),
          autoDispose.overrideWith(
            (Ref<int> ref) => 84,
          ),
        ],
      );

      expect(container.read(provider), 42);
      expect(container.read(autoDispose), 84);
    });

    test('supports family overrideWith', () {
      final family = Provider.family<String, int>((ref, arg) => '0 $arg');
      final autoDisposeFamily = Provider.autoDispose.family<String, int>(
        (ref, arg) => '0 $arg',
      );
      final container = ProviderContainer.test(
        overrides: [
          family.overrideWith((Ref<String> ref, int arg) => '42 $arg'),
          autoDisposeFamily.overrideWith(
            (Ref<String> ref, int arg) => '84 $arg',
          ),
        ],
      );

      expect(container.read(family(10)), '42 10');
      expect(container.read(autoDisposeFamily(10)), '84 10');
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = Provider((ref) => result);

      expect(container.read(provider), 0);

      result = 1;
      expect(container.refresh(provider), 1);

      expect(container.read(provider), 1);
    });

    group('ref.state', () {
      test('throws on providers that threw', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => throw UnimplementedError());

        expect(
          () => container.read(provider),
          throwsUnimplementedError,
        );

        final element = container.readProviderElement(provider);

        expect(
          () => element.ref!.state,
          throwsUnimplementedError,
        );
      });

      test('can read and change current value', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late Ref<int> ref;
        final provider = Provider<int>((r) {
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
        final container = ProviderContainer.test();
        Object? err;
        final provider = Provider<int>((ref) {
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
        final provider = Provider<int>((ref) {
          return ref.state = 42;
        });

        expect(container.read(provider), 42);
      });
    });

    test('does not notify listeners when called ref.state= with == new value',
        () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();
      late Ref<int> ref;
      final provider = Provider<int>((r) {
        ref = r;
        return 0;
      });

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      ref.state = 0;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    group('scoping an override overrides all the associated sub-providers', () {
      test('when passing the provider itself', () {
        final provider = Provider(
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
        final provider = Provider(
          (ref) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWithValue(42)],
        );

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWith', () {
        final provider = Provider(
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

    test('can specify name', () {
      final provider = Provider(
        (_) => 0,
        name: 'example',
      );

      expect(provider.name, 'example');

      final provider2 = Provider((_) => 0);

      expect(provider2.name, isNull);
    });
  });

  test('dispose', () {
    final container = ProviderContainer.test();
    final onDispose = OnDisposeMock();
    final provider = Provider((ref) {
      ref.onDispose(onDispose.call);
      return 42;
    });

    expect(container.read(provider), 42);

    verifyZeroInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
  });

  test('Read creates the value only once', () {
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    var buildCount = 0;
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub =
        container.listen(provider, listener.call, fireImmediately: true);

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
    final container = ProviderContainer.test();
    final counter = Counter();
    final other = StateNotifierProvider<Counter, int>((ref) => counter);
    final provider = Provider((ref) {
      return ref.watch(other).isEven;
    });
    final listener = Listener<bool>();

    final sub =
        container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, true));
    expect(sub.read(), true);

    counter.increment();

    expect(sub.read(), false);
    verifyOnly(listener, listener(true, false));
  });

  test('can be auto-scoped', () async {
    final dep = Provider(
      (ref) => 0,
      dependencies: const [],
    );
    final provider = Provider(
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
}
