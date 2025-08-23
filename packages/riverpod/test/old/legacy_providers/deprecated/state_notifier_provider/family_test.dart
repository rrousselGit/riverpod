import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:test/test.dart';

import '../../../utils.dart';
import 'state_notifier_provider_test.dart';

void main() {
  group('StateNotifier.family', () {
    test('specifies `from` & `argument` for related providers', () {
      final provider = StateNotifierProvider.family<Counter, int, int>(
        (ref, _) => Counter(),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider =
          StateNotifierProvider.family<StateController<int>, int, int>(
            (ref, i) => StateController(ref.watch(dep) + i),
            dependencies: [dep],
          );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider(10)), 52);
      expect(container.read(provider(10).notifier).state, 52);

      expect(root.getAllProviderElements(), isEmpty);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        expect(container.read(provider(0).notifier), controller);
        expect(container.read(provider(0)), 0);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
        expect(root.getAllProviderElementsInOrder(), isEmpty);
      });

      test('when using provider.overrideWith', () async {
        final controller = StateController(0);
        final provider =
            StateNotifierProvider.family<StateController<int>, int, int>(
              (ref, _) => controller,
              dependencies: const [],
            );
        final root = ProviderContainer.test();
        final controllerOverride = StateController(42);
        final container = ProviderContainer.test(
          parent: root,
          overrides: [
            provider.overrideWith((ref, value) => controllerOverride),
          ],
        );

        expect(container.read(provider(0).notifier), controllerOverride);
        expect(container.read(provider(0)), 42);
        expect(root.getAllProviderElementsInOrder(), isEmpty);
        expect(
          container.getAllProviderElementsInOrder(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having(
              (e) => e.origin,
              'origin',
              provider(0),
            ),
          ]),
        );
      });
    });

    test('StateNotifierProviderFamily.toString includes argument & name', () {
      final family = StateNotifierProvider.family<Counter, int, String>(
        (ref, id) => Counter(),
        name: 'Example',
      );

      expect(family('foo').toString(), equalsIgnoringHashCodes('Example(foo)'));
    });

    test('properly overrides ==', () {
      final family = StateNotifierProvider.family<Counter, int, int>(
        (ref, _) => Counter(),
      );

      expect(family(0), family(0));
      expect(family(1), isNot(family(0)));
      expect(family(1), family(1));
    });

    test('scoping a provider overrides all the associated subproviders', () {
      final family = StateNotifierProvider.family<Counter, int, String>(
        (ref, id) => Counter(),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [family],
      );

      expect(container.read(family('0')), 0);
      expect(container.read(family('0').notifier), isA<Counter>());

      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElement>().having(
          (e) => e.provider,
          'provider',
          family('0'),
        ),
      ]);
    });

    test('StateNotifierFamily override', () async {
      final notifier2 = TestNotifier(42);
      final provider = StateNotifierProvider.autoDispose
          .family<TestNotifier, int, int>((ref, a) => TestNotifier());
      final container = ProviderContainer.test(
        overrides: [provider.overrideWith((ref, a) => notifier2)],
      );
      addTearDown(container.dispose);
      final ownerStateListener = Listener<int>();
      final ownerNotifierListener = Listener<TestNotifier>();

      // access in the child container
      // try to read provider.state before provider and see if it points to the override
      final stateSub = container.listen(
        provider(0),
        ownerStateListener.call,
        fireImmediately: true,
      );

      verify(ownerStateListener(null, 42)).called(1);
      verifyNoMoreInteractions(ownerStateListener);

      final notifierSub = container.listen(
        provider(0).notifier,
        ownerNotifierListener.call,
        fireImmediately: true,
      );
      verifyOnly(ownerNotifierListener, ownerNotifierListener(null, notifier2));

      notifierSub.close();

      await container.pump();

      expect(notifier2.mounted, true);

      stateSub.close();

      expect(notifier2.mounted, true);

      await container.pump();

      await container.pump();

      expect(notifier2.mounted, false);
    });
  });
}
