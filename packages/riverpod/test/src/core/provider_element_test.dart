import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../../old/utils.dart';

void main() {
  group('ProviderElement', () {
    test('Only includes direct subscriptions in subscription lists', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);
      final dep = Provider((ref) {
        ref.watch(provider.future.select((value) => 0));
      });

      container.read(dep);

      final providerElement = container.readProviderElement(provider);
      final depElement = container.readProviderElement(dep);

      expect(providerElement.subscriptions, null);
      expect(
        providerElement.dependents,
        [isA<SelectorSubscription<Future<int>, int>>()],
      );
      expect(providerElement.weakDependents, isEmpty);

      expect(depElement.subscriptions, [
        isA<SelectorSubscription<Future<int>, int>>(),
      ]);
      expect(depElement.dependents, isEmpty);
      expect(depElement.weakDependents, isEmpty);
    });

    test(
        'does not throw outdated error when a dependency is flushed while the dependent is building',
        () async {
      final container = ProviderContainer.test();
      final a = StateProvider((ref) => 0);

      final dep = Provider<int>((ref) {
        return ref.watch(a) + 10;
      });
      final dependent = Provider<int?>((ref) {
        if (ref.watch(a) > 0) {
          ref.watch(dep);
          // Voluntarily using "watch" twice.
          // When `dep` is flushed, it could cause subsequent "watch" calls to throw
          // because `dependent` is considered as outdated
          return ref.watch(dep);
        }
        return null;
      });
      final listener = Listener<int?>();

      expect(container.read(dep), 10);
      container.listen<int?>(dependent, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, null));

      // schedules `dep` and `dependent` to rebuild
      // Will build `dependent` before `dep` because `dependent` doesn't depend on `dep` yet
      // And since nothing is watching `dep` at the moment, then `dependent` will
      // rebuild before `dep` even though `dep` is its ancestor.
      // This is fine since nothing is listening to `dep` yet, but it should
      // not cause certain assertions to trigger
      container.read(a.notifier).state++;
      await container.pump();

      verifyOnly(listener, listener(null, 11));
    });

    group('readSelf', () {
      test('throws on providers that threw', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => throw UnimplementedError());

        final element = container.readProviderElement(provider);

        expect(
          element.readSelf,
          throwsUnimplementedError,
        );
      });
    });

    group('visitChildren', () {
      test('includes ref.watch dependents', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final dependent = Provider((ref) {
          ref.watch(provider);
        });
        final dependent2 = Provider((ref) {
          ref.watch(provider);
        });

        container.read(dependent);
        container.read(dependent2);

        final children = <ProviderElement>[];

        container.readProviderElement(provider).visitChildren(
              elementVisitor: children.add,
              listenableVisitor: (_) {},
            );
        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent2),
          ]),
        );
      });

      test('includes ref.listen dependents', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final dependent = Provider((ref) {
          ref.listen(provider, (_, __) {});
        });
        final dependent2 = Provider((ref) {
          ref.listen(provider, (_, __) {});
        });
        final dependent3 = Provider((ref) {
          ref.listen(provider, (_, __) {}, weak: true);
        });

        container.read(dependent);
        container.read(dependent2);
        container.read(dependent3);

        final children = <ProviderElement>[];

        container.readProviderElement(provider).visitChildren(
              elementVisitor: children.add,
              listenableVisitor: (_) {},
            );

        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent2),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent3),
          ]),
        );
      });
    });

    group('isActive', () {
      test('Is paused if all watchers are paused', () {
        final container = ProviderContainer.test();
        final provider = Provider(name: 'foo', (ref) => 0);
        final dep = Provider(name: 'dep', (ref) => ref.watch(provider));
        final dep2 = Provider(name: 'dep2', (ref) => ref.watch(provider));

        final depSub = container.listen(dep, (a, b) {});
        final dep2Sub = container.listen(dep2, (a, b) {});
        final element = container.readProviderElement(provider);

        expect(element.isActive, true);

        depSub.close();

        expect(element.isActive, true);

        dep2Sub.close();

        expect(element.isActive, false);
      });

      test('Is paused if all subscriptions are paused', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        final element = container.readProviderElement(provider);

        final sub = container.listen(provider, (_, __) {});
        final sub2 = container.listen(provider, (_, __) {});

        expect(element.isActive, true);

        sub.pause();

        expect(element.isActive, true);

        sub2.pause();

        expect(element.isActive, false);
      });

      test('rejects weak listeners', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        final element = container.readProviderElement(provider);

        expect(element.isActive, false);

        container.listen(provider, weak: true, (_, __) {});

        expect(element.isActive, false);
      });

      test('includes provider listeners', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.listen(provider, (prev, value) {});
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.read(dep);

        expect(container.readProviderElement(provider).isActive, true);
      });

      test('includes provider dependents', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.watch(provider);
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.read(dep);

        expect(container.readProviderElement(provider).isActive, true);
      });

      test('includes container listeners', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.listen(provider, (_, __) {});

        expect(container.readProviderElement(provider).isActive, true);
      });
    });

    group('hasListeners', () {
      test('includes weak listeners', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        final element = container.readProviderElement(provider);

        expect(element.hasListeners, false);

        container.listen(provider, weak: true, (_, __) {});

        expect(element.hasListeners, true);
      });

      test('includes provider listeners', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.listen(provider, (prev, value) {});
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).hasListeners, false);

        container.read(dep);

        expect(container.readProviderElement(provider).hasListeners, true);
      });

      test('includes provider dependents', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.watch(provider);
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).hasListeners, false);

        container.read(dep);

        expect(container.readProviderElement(provider).hasListeners, true);
      });

      test('includes container listeners', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).hasListeners, false);

        container.listen(provider, (_, __) {});

        expect(container.readProviderElement(provider).hasListeners, true);
      });
    });

    test('does not notify listeners twice when using fireImmediately',
        () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        ref.watch(dep);
        return ref.state = 0;
      });

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));
    });

    test('does not notify listeners when rebuilding the state', () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        ref.watch(dep);
        return ref.state = 0;
      });

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(dep.notifier).state++;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });
  });
}
