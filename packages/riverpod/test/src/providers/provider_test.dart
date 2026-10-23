// ignore_for_file: avoid_types_on_closure_parameters

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart'
    show InternalProviderContainer, ProviderElement;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('Provider', () {
    test('supports overrideWith', () {
      final provider = Provider<int>((ref) => 0);
      final autoDispose = Provider.autoDispose<int>((ref) => 0);
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWith((ref) => 42),
          autoDispose.overrideWith((ref) => 84),
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
          family.overrideWith((ref, int arg) => '42 $arg'),
          autoDisposeFamily.overrideWith((ref, int arg) => '84 $arg'),
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

    group('scoping an override overrides all the associated sub-providers', () {
      test('when passing the provider itself', () {
        final provider = Provider((ref) => 0, dependencies: const []);
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
        final provider = Provider((ref) => 0, dependencies: const []);
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
        final provider = Provider((ref) => 0, dependencies: const []);
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref) => 42)],
        );

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can specify name', () {
      final provider = Provider((_) => 0, name: 'example');

      expect(provider.name, 'example');

      final provider2 = Provider((_) => 0);

      expect(provider2.name, isNull);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider((ref) => ref.watch(dep), dependencies: [dep]);
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider), 42);

      expect(root.getAllProviderElements(), isEmpty);
    });

    group('updateShouldNotify', () {
      test("rebuild don't notify clients if == doesn't change", () {
        final container = ProviderContainer.test();
        final other = NotifierProvider<Counter, int>(Counter.new);
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(other).isEven;
        });
        final listener = Listener<bool>();

        final sub = container.listen(
          provider,
          listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, true));
        expect(sub.read(), true);
        expect(buildCount, 1);

        container.read(other.notifier).increment();
        container.read(other.notifier).increment();

        expect(sub.read(), true);
        expect(buildCount, 2);
        verifyNoMoreInteractions(listener);
      });

      test('rebuild notify clients if == did change', () {
        final container = ProviderContainer.test();
        final other = NotifierProvider<Counter, int>(Counter.new);
        final provider = Provider((ref) {
          return ref.watch(other).isEven;
        });
        final listener = Listener<bool>();

        final sub = container.listen(
          provider,
          listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, true));
        expect(sub.read(), true);

        container.read(other.notifier).increment();

        expect(sub.read(), false);
        verifyOnly(listener, listener(true, false));
      });
    });
  });

  group('Provider.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = Provider.family<int, int>((ref, _) => 0);

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });

      test('when using provider.overrideWith', () {
        final provider = Provider.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref, value) => 42)],
        );

        expect(root.getAllProviderElements(), isEmpty);
        expect(container.read(provider(0)), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider.family<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);

      expect(root.getAllProviderElements(), isEmpty);
    });
  });

  group('Provider.autoDispose', () {
    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = Provider.autoDispose((ref) => result);

      expect(container.read(provider), 0);

      result = 1;
      expect(container.refresh(provider), 1);

      expect(container.read(provider), 1);
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
          overrides: [provider.overrideWithValue(42)],
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
          overrides: [provider.overrideWith((ref) => 42)],
        );

        expect(container.read(provider), 42);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
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

  group('Provider.autoDispose.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () {
        final provider = Provider.autoDispose.family<int, int>(
          (ref, _) => 0,
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0)), 0);
        expect(container.getAllProviderElements(), [
          isA<ProviderElement>().having((e) => e.origin, 'origin', provider(0)),
        ]);
        expect(root.getAllProviderElements(), isEmpty);
      });
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = Provider.family.autoDispose<int, int>(
        (ref, i) => ref.watch(dep) + i,
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('works', () async {
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose.family<String, int>((ref, value) {
        ref.onDispose(onDispose.call);
        return '$value';
      });
      final listener = Listener<String>();
      final container = ProviderContainer.test();

      final sub = container.listen(
        provider(0),
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, '0'));

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
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWith((ref, value) {
            ref.onDispose(onDispose.call);
            return '$value override';
          }),
        ],
      );
      addTearDown(container.dispose);

      final sub = container.listen(
        provider(0),
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, '0 override'));

      sub.close();

      verifyZeroInteractions(onDispose);

      await container.pump();

      verifyOnly(onDispose, onDispose());
    });
  });
}
