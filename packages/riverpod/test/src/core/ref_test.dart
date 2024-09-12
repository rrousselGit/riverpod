import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../utils.dart';

final refMethodsThatDependOnProviders =
    <String, void Function(Ref<Object?> ref, ProviderBase<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
  'invalidate': (ref, p) => ref.invalidate(p),
  'refresh': (ref, p) => ref.refresh(p),
  'exists': (ref, p) => ref.exists(p),
};
final refMethodsThatDependOnListenables =
    <String, void Function(Ref<Object?> ref, ProviderListenable<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
};
final refMethodsThatDependOnProviderOrFamilies =
    <String, void Function(Ref<Object?> ref, ProviderOrFamily)>{
  'invalidate': (ref, p) => ref.invalidate(p),
};

void main() {
  group('Ref', () {
    test('asserts that a lifecycle cannot be used after a ref is unmounted',
        () {
      late Ref<Object?> ref;
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final provider = Provider<Object?>((r) {
        r.watch(dep);
        ref = r;
        return Object();
      });

      container.read(provider);

      container.read(dep.notifier).state++;

      final another = Provider((ref) => 0);

      expect(
        () => ref.state,
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.state = 42,
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.watch(another),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.invalidateSelf(),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.invalidate(dep),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.refresh(another),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.read(another),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.onDispose(() {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.onAddListener((_) {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.onCancel(() {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.onRemoveListener((_) {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.onResume(() {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.notifyListeners(),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.listen(another, (_, __) {}),
        throwsA(isA<UnmountedRefException>()),
      );
      expect(
        () => ref.exists(another),
        throwsA(isA<UnmountedRefException>()),
      );

      expect(
        () => ref.keepAlive(),
        throwsA(isA<UnmountedRefException>()),
      );
    });

    test('asserts that a lifecycle cannot be used inside selectors', () {
      late Ref<Object?> ref;
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final provider = Provider<Object?>((r) {
        r.watch(dep);
        ref = r;
        return Object();
      });

      container.read(provider);

      container.read(dep.notifier).state++;

      final another = Provider((ref) => 0);

      expect(
        () => container.read(provider.select((_) => ref.state)),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.state = 42)),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.watch(another))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.invalidateSelf())),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.invalidate(dep))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.refresh(another))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.read(another))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.onDispose(() {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.onAddListener((_) {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.onCancel(() {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container
            .read(provider.select((_) => ref.onRemoveListener((_) {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.onResume(() {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.notifyListeners())),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container
            .read(provider.select((_) => ref.listen(another, (_, __) {}))),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => container.read(provider.select((_) => ref.exists(another))),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => container.read(provider.select((_) => ref.keepAlive())),
        throwsA(isA<AssertionError>()),
      );
    });

    group('invalidate', () {
      test('can disposes of the element if not used anymore', () async {
        late Ref<Object?> ref;
        final dep = Provider((r) {
          ref = r;
          return 0;
        });
        final provider = Provider.autoDispose((r) {
          r.keepAlive();
          return 0;
        });
        final container = ProviderContainer.test();

        container.read(dep);
        container.read(provider);
        ref.invalidate(provider);

        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          [dep],
        );
      });

      test('does not mount providers if they are not already mounted',
          () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider<int>((r) async => 0);
        late Ref<Object?> ref;
        final dep = Provider((r) {
          ref = r;
          return 0;
        });

        container.read(dep);

        ref.invalidate(provider);

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          [dep],
        );
      });

      test('supports asReload', () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider<int>((r) async => 0);
        late Ref<Object?> ref;
        final dep = Provider((r) {
          ref = r;
          return 0;
        });

        container.read(dep);
        await container.read(provider.future);
        expect(container.read(provider), const AsyncValue.data(0));

        ref.invalidate(provider, asReload: true);

        expect(
          container.read(provider),
          isA<AsyncLoading<int>>().having((e) => e.value, 'value', 0),
        );
      });
    });

    group('invalidateSelf', () {
      test('calls dispose immediately', () {
        final container = ProviderContainer.test();
        final listener = OnDisposeMock();
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
          ref.onDispose(listener.call);
        });

        container.read(provider);
        verifyZeroInteractions(listener);

        ref.invalidateSelf();

        verifyOnly(listener, listener());
      });

      test('triggers a rebuild on next frame', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        var result = 0;
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
          return result;
        });

        container.listen(provider, listener.call);
        verifyZeroInteractions(listener);

        ref.invalidateSelf();
        result = 1;

        verifyZeroInteractions(listener);

        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test('merges the rebuild with dependency change rebuild', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final dep = StateProvider((ref) => 0);
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
          return ref.watch(dep);
        });

        container.listen(provider, listener.call);
        verifyZeroInteractions(listener);

        ref.invalidateSelf();
        container.read(dep.notifier).state++;

        verifyZeroInteractions(listener);

        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test('can disposes of the element if not used anymore', () async {
        late Ref<Object?> ref;
        final provider = Provider.autoDispose((r) {
          ref = r;
          r.keepAlive();
          return 0;
        });
        final container = ProviderContainer.test();

        container.read(provider);
        ref.invalidateSelf();

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
      });

      test('supports asReload', () async {
        final container = ProviderContainer.test();
        late Ref<AsyncValue<int>> ref;
        final provider = FutureProvider<int>((r) async {
          ref = r;
          return 0;
        });

        await container.read(provider.future);
        expect(container.read(provider), const AsyncValue.data(0));

        ref.invalidateSelf(asReload: true);

        expect(
          container.read(provider),
          isA<AsyncLoading<int>>().having((e) => e.value, 'value', 0),
        );
      });
    });

    test("can't use ref inside onDispose", () {
      final provider2 = Provider((ref) => 0);
      final provider = Provider((ref) {
        ref.onDispose(() {
          ref.watch(provider2);
        });
        return ref;
      });
      final container = ProviderContainer.test();

      container.read(provider);

      final errors = <Object>[];
      runZonedGuarded(container.dispose, (err, _) => errors.add(err));

      expect(errors, [isA<UnmountedRefException>()]);
    });

    group(
        'asserts that a provider cannot depend on a provider that is not in its dependencies:',
        () {
      for (final entry in refMethodsThatDependOnProviders.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a provider', () {
          final transitiveDep = Provider((ref) => 0, dependencies: const []);
          final dep = Provider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = Provider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = Provider((ref) => 0, dependencies: const []);
          final unrelatedScopedFamily = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider((ref) => 0);
          final provider = Provider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );
          final family = Provider.family(
            (ref, id) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);
          final ref2 = container.read(family(0));

          // accepts providers that are part of its dependencies
          call(ref, dep);
          call(ref2, dep);
          call(ref, depFamily(42));
          call(ref2, depFamily(42));

          // accepts non-scoped providers
          call(ref, nonScopedProvider);
          call(ref2, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScopedFamily(42)),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnListenables.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a listenable', () async {
          final transitiveDep = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final dep = FutureProvider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = FutureProvider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = FutureProvider((ref) => 0);
          final provider = FutureProvider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider).requireValue;

          // accepts providers that are part of its dependencies
          call(ref, dep.select((value) => 0));
          call(ref, dep.selectAsync((value) => 0));
          call(ref, depFamily(42).select((value) => 0));

          // accepts non-scoped providers
          call(ref, nonScopedProvider.select((value) => 0));

          // rejects providers that are not part of its dependencies
          await expectLater(
            () => call(ref, unrelatedScoped.select((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.selectAsync((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.future),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnProviderOrFamilies.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a family (not `family(arg)`)', () {
          final transitiveDep = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final dep = Provider.family(
            (ref, id) => 0,
            dependencies: [transitiveDep],
          );
          final unrelatedScoped = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider.family((ref, i) => 0);

          final provider = Provider(
            (ref) => ref,
            dependencies: [dep],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);

          // accepts providers that are part of its dependencies
          call(ref, dep);

          // accepts non-scoped providers
          call(ref, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
        });
      }
    });

    group('.exists', () {
      test('Returns true if available on ancestor container', () {
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(parent: root);
        final provider = Provider((ref) => 0);

        root.read(provider);

        expect(container.exists(provider), true);
        expect(root.exists(provider), true);
      });

      test('simple use-case', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final refProvider = Provider((ref) => ref);

        final ref = container.read(refProvider);

        expect(
          container.getAllProviderElements().map((e) => e.origin),
          [refProvider],
        );
        expect(container.exists(refProvider), true);
        expect(ref.exists(provider), false);

        ref.read(provider);

        expect(ref.exists(provider), true);
      });
    });

    group('listenSelf', () {
      test('does not break autoDispose', () async {
        final container = ProviderContainer.test();
        final provider = Provider.autoDispose((ref) {
          ref.listenSelf((previous, next) {});
        });

        container.read(provider);
        expect(container.getAllProviderElements(), [anything]);

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
      });

      test('listens to mutations post build', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();

        late Ref<int> ref;
        final provider = Provider<int>((r) {
          ref = r;
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return 0;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref.state = 42;

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listens to rebuild', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return result;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('notify listeners independently from updateShouldNotify', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return 0;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        container.refresh(provider);

        verifyInOrder([
          listener(0, 0),
          listener2(0, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('clears state listeners on rebuild', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          if (result == 0) {
            ref.listenSelf(listener.call);
          } else {
            ref.listenSelf(listener2.call);
          }

          return result;
        });

        container.read(provider);

        verifyOnly(listener, listener(null, 0));
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyOnly(listener2, listener2(0, 42));
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listens to errors', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        final errorListener2 = ErrorListener();
        var error = 42;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call, onError: errorListener.call);
          ref.listenSelf((prev, next) {}, onError: errorListener2.call);

          Error.throwWithStackTrace(error, StackTrace.empty);
        });

        expect(() => container.read(provider), throwsA(42));

        verifyZeroInteractions(listener);
        verifyInOrder([
          errorListener(42, StackTrace.empty),
          errorListener2(42, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);

        error = 21;
        expect(() => container.refresh(provider), throwsA(21));

        verifyZeroInteractions(listener);

        verifyInOrder([
          errorListener(21, StackTrace.empty),
          errorListener2(21, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);
      });

      test('executes error listener before other listeners', () {
        final container = ProviderContainer.test();
        final errorListener = ErrorListener();
        final errorListener2 = ErrorListener();
        Exception? error;
        final provider = Provider<int>((ref) {
          ref.listenSelf((prev, next) {}, onError: errorListener.call);

          if (error != null) Error.throwWithStackTrace(error, StackTrace.empty);

          return 0;
        });

        container.listen(
          provider,
          (prev, next) {},
          onError: errorListener2.call,
        );

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(errorListener2);

        error = Exception();
        expect(() => container.refresh(provider), throwsA(error));

        verifyInOrder([
          errorListener(error, StackTrace.empty),
          errorListener2(error, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);
      });

      test('executes state listener before other listeners', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          return result;
        });

        container.listen(provider, listener2.call, fireImmediately: true);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listeners are not allowed to modify the state', () {});
    });

    group('listen', () {
      test('does not invoke value listeners if paused', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late Ref<int> ref;
        final provider = Provider<int>((r) {
          ref = r;
          return 0;
        });

        final sub = container.listen(provider, listener.call);
        sub.pause();

        verifyZeroInteractions(listener);

        ref.notifyListeners();

        verifyZeroInteractions(listener);
      });

      test('does not invoke error listeners if paused', () {
        final container = ProviderContainer.test();
        final listener = ErrorListener();
        late Ref<void> ref;
        var throws = false;
        final provider = Provider<void>((r) {
          ref = r;
          if (throws) throw StateError('err');
        });

        final sub = container.listen(
          provider,
          (a, b) {},
          onError: listener.call,
        );

        sub.pause();

        verifyZeroInteractions(listener);

        throws = true;
        try {
          container.refresh(provider);
        } catch (e) {
          // We just want to trigger onError listener
        }
        verifyZeroInteractions(listener);
      });

      group('weak', () {
        test('Mounts the element but does not initialize the provider', () {
          final container = ProviderContainer.test();

          final dep = StateProvider((ref) => 0);
          final provider = Provider((ref) {
            ref.listen(
              dep,
              weak: true,
              (previous, next) {},
            );
            return 0;
          });

          container.read(provider);

          expect(
            container.pointerManager.orphanPointers.pointers[dep]!.element,
            isA<ProviderElement<int>>()
                .having((e) => e.stateResult, 'stateResult', null),
          );
        });

        test('when finally mounting an element, notifies weak listeners', () {
          final container = ProviderContainer.test();

          final listener = Listener<int>();
          final dep = StateProvider((ref) => 0);
          final provider = Provider((ref) {
            ref.listen(dep, weak: true, listener.call);
            return 0;
          });

          container.read(provider);

          verifyZeroInteractions(listener);

          // Flush the provider
          container.read(dep);

          verifyOnly(listener, listener(null, 0));
        });

        test('when finally rebuilding a dirty element, notifies weak listeners',
            () {
          final container = ProviderContainer.test();

          final listener = Listener<int>();
          var result = 0;
          final dep = StateProvider((ref) => result);
          final provider = Provider((ref) {
            ref.listen(dep, weak: true, listener.call);
            return 0;
          });

          container.read(dep);
          container.invalidate(dep);
          result = 1;

          container.read(provider);

          verifyZeroInteractions(listener);

          // Flush the provider
          container.read(dep);

          verifyOnly(listener, listener(0, 1));
        });

        test(
            'adding a weak listener on an invalidated provider does not rebuild it',
            () {
          final container = ProviderContainer.test();
          var buildCount = 0;
          final dep = StateProvider((ref) {
            buildCount++;
            return 0;
          });
          final provider = Provider((ref) {
            ref.listen(dep, weak: true, (previous, next) {});
            return 0;
          });

          container.read(dep);
          container.invalidate(dep);
          expect(buildCount, 1);

          container.read(provider);

          expect(buildCount, 1);
        });

        test('closing the subscription removes the listener', () {
          final container = ProviderContainer.test();
          final provider = Provider((ref) => Object());
          final listener = Listener<Object>();

          final sub = container.listen(
            provider,
            weak: true,
            listener.call,
          );
          sub.close();

          container.read(provider);
          container.refresh(provider);

          verifyZeroInteractions(listener);
        });

        test('does not count towards the pause mechanism', () async {
          final container = ProviderContainer.test();

          final listener = Listener<Object?>();
          final provider = Provider((ref) => Object());

          container.listen(provider, weak: true, listener.call);
          container.invalidate(provider);

          await container.pump();

          verifyZeroInteractions(listener);
        });
      });

      test('ref.listen on outdated provider causes it to rebuild', () {
        final dep = StateProvider((ref) => 0);
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep);
        });
        final listener = Listener<int>();
        final another = Provider((ref) {
          ref.listen<int>(provider, listener.call, fireImmediately: true);
        });
        final container = ProviderContainer.test();

        expect(container.read(provider), 0);
        expect(buildCount, 1);

        container.read(dep.notifier).state = 42;

        expect(buildCount, 1);

        container.read(another);

        expect(buildCount, 2);
        verifyOnly(listener, listener(null, 42));
      });

      test('can downcast the value', () async {
        final listener = Listener<num>();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.listen<num>(dep, listener.call);
        });

        final container = ProviderContainer.test();
        container.read(provider);

        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test('can listen selectors', () async {
        final container = ProviderContainer.test();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
        final isEvenListener = Listener<bool>();
        var buildCount = 0;

        final another = Provider<int>((ref) {
          buildCount++;
          ref.listen<bool>(
            provider.select(isEvenSelector.call),
            isEvenListener.call,
          );
          return 0;
        });

        container.read(another);

        expect(buildCount, 1);
        verifyZeroInteractions(isEvenListener);
        verifyOnly(isEvenSelector, isEvenSelector(0));

        container.read(provider.notifier).state = 2;

        verifyOnly(isEvenSelector, isEvenSelector(2));
        verifyZeroInteractions(isEvenListener);

        container.read(provider.notifier).state = 3;

        verifyOnly(isEvenSelector, isEvenSelector(3));
        verifyOnly(isEvenListener, isEvenListener(true, false));

        container.read(provider.notifier).state = 4;

        verifyOnly(isEvenSelector, isEvenSelector(4));
        verifyOnly(isEvenListener, isEvenListener(false, true));

        await container.pump();

        expect(buildCount, 1);
      });

      test('listen on selectors supports fireImmediately', () async {
        final container = ProviderContainer.test();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
        final isEvenListener = Listener<bool>();
        var buildCount = 0;

        final another = Provider<int>((ref) {
          buildCount++;
          ref.listen<bool>(
            provider.select(isEvenSelector.call),
            isEvenListener.call,
            fireImmediately: true,
          );
          return 0;
        });

        container.read(another);

        expect(buildCount, 1);
        verifyOnly(isEvenListener, isEvenListener(null, true));
        verifyOnly(isEvenSelector, isEvenSelector(0));

        container.read(provider.notifier).state = 2;

        verifyOnly(isEvenSelector, isEvenSelector(2));
        verifyNoMoreInteractions(isEvenListener);

        container.read(provider.notifier).state = 3;

        verifyOnly(isEvenSelector, isEvenSelector(3));
        verifyOnly(isEvenListener, isEvenListener(true, false));

        await container.pump();

        expect(buildCount, 1);
      });

      test(
          'when rebuild throws identical error/stack, listeners are still notified',
          () {
        final container = ProviderContainer.test();
        const stack = StackTrace.empty;
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        final provider = Provider<int>((ref) {
          Error.throwWithStackTrace(42, stack);
        });

        container.listen(
          provider,
          listener.call,
          onError: errorListener.call,
          fireImmediately: true,
        );

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(42, stack));

        expect(() => container.refresh(provider), throwsA(42));

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(42, stack));
      });

      test('cannot listen itself', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late Ref<int> ref;
        late Provider<int> provider;
        provider = Provider<int>((r) {
          ref = r;
          ref.listen(provider, (previous, next) {});
          return 0;
        });

        expect(() => container.read(provider), throwsA(isAssertionError));

        ref.state = 42;

        verifyZeroInteractions(listener);
      });

      test('expose previous and new value on change', () {
        final container = ProviderContainer.test();
        final dep = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final listener = Listener<int>();
        final provider = Provider((ref) {
          ref.listen<int>(dep, listener.call, fireImmediately: true);
        });

        container.read(provider);

        verifyOnly(listener, listener(null, 0));

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test(
          'calling ref.listen on a provider with an outdated dependency flushes it, then add the listener',
          () {
        final container = ProviderContainer.test();
        var buildCount = 0;
        final dep2 = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final dep = Provider<int>((ref) {
          buildCount++;
          return ref.watch(dep2);
        });
        final listener = Listener<int>();
        final provider = Provider((ref) {
          ref.listen<int>(dep, listener.call);
        });

        container.read(dep);
        container.read(dep2.notifier).state++; // mark `dep` as outdated

        expect(buildCount, 1);
        verifyZeroInteractions(listener);

        container.read(provider);

        expect(buildCount, 2);
        verifyZeroInteractions(listener);
      });

      test(
          'when using selectors, `previous` is the latest notification instead of latest event',
          () {
        final container = ProviderContainer.test();
        final dep = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final listener = Listener<bool>();
        final provider = Provider((ref) {
          ref.listen<bool>(
            dep.select((value) => value.isEven),
            listener.call,
            fireImmediately: true,
          );
        });

        container.read(provider);
        verifyOnly(listener, listener(null, true));

        container.read(dep.notifier).state += 2;

        verifyNoMoreInteractions(listener);

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(true, false));
      });

      test('when no onError is specified, fallbacks to handleUncaughtError',
          () async {
        final container = ProviderContainer.test();
        final isErrored = StateProvider((ref) => false);
        final dep = Provider<int>((ref) {
          if (ref.watch(isErrored)) throw UnimplementedError();
          return 0;
        });
        final listener = Listener<int>();
        final errors = <Object>[];
        final provider = Provider((ref) {
          runZonedGuarded(
            () => ref.listen(dep, listener.call),
            (err, stack) => errors.add(err),
          );
        });

        container.listen(provider, (a, b) {});

        verifyZeroInteractions(listener);
        expect(errors, isEmpty);

        container.read(isErrored.notifier).state = true;

        await container.pump();

        verifyZeroInteractions(listener);
        expect(errors, [isUnimplementedError]);
      });

      test(
          'when no onError is specified, selectors fallbacks to handleUncaughtError',
          () async {
        final container = ProviderContainer.test();
        final isErrored = StateProvider((ref) => false);
        final dep = Provider<int>((ref) {
          if (ref.watch(isErrored)) throw UnimplementedError();
          return 0;
        });
        final listener = Listener<int>();
        final errors = <Object>[];
        final provider = Provider((ref) {
          runZonedGuarded(
            () => ref.listen(dep.select((value) => value), listener.call),
            (err, stack) => errors.add(err),
          );
        });

        container.listen(provider, (p, n) {});

        verifyZeroInteractions(listener);
        expect(errors, isEmpty);

        container.read(isErrored.notifier).state = true;

        await container.pump();

        verifyZeroInteractions(listener);
        expect(errors, [isUnimplementedError]);
      });

      test('when rebuild throws, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        final a = Provider((ref) {
          ref.listen(provider, listener.call, onError: errorListener.call);
        });

        container.listen(a, (p, n) {});

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(
          errorListener,
          errorListener(isUnimplementedError, any),
        );
      });

      test('when rebuild throws on selector, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        final a = Provider((ref) {
          ref.listen(
            provider.select((value) => value),
            listener.call,
            onError: errorListener.call,
          );
        });

        container.listen(a, (a, b) {});

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(
          errorListener,
          errorListener(isUnimplementedError, any),
        );
      });

      group('fireImmediately', () {
        test('when no onError is specified, fallbacks to handleUncaughtError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errors = <Object>[];
          final provider = Provider((ref) {
            runZonedGuarded(
              () {
                ref.listen(
                  dep,
                  listener.call,
                  fireImmediately: true,
                );
              },
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          expect(errors, [
            isUnimplementedError,
          ]);
        });

        test(
            'when no onError is specified on selectors, fallbacks to handleUncaughtError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errors = <Object>[];
          final provider = Provider((ref) {
            runZonedGuarded(
              () {
                ref.listen(
                  dep.select((value) => value),
                  listener.call,
                  fireImmediately: true,
                );
              },
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          expect(errors, [
            isUnimplementedError,
          ]);
        });

        test('on provider that threw, fireImmediately calls onError', () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          final provider = Provider((ref) {
            ref.listen(
              dep,
              listener.call,
              onError: errorListener.call,
              fireImmediately: true,
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(isUnimplementedError, argThat(isNotNull)),
          );
        });

        test(
            'when selecting provider that threw, fireImmediately calls onError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<String>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          final provider = Provider((ref) {
            ref.listen<int>(
              dep.select((value) => 0),
              listener.call,
              onError: errorListener.call,
              fireImmediately: true,
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(isUnimplementedError, argThat(isNotNull)),
          );
        });

        test('correctly listens to the provider if selector listener throws',
            () {
          final dep = StateProvider((ref) => 0);
          final listener = Listener<int>();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep.select((value) => value),
                (prev, value) {
                  listener(prev, value);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen<void>(provider, (prev, value) {});

          expect(sub, isNotNull);
          verifyOnly(listener, listener(null, 0));
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          verifyOnly(listener, listener(0, 1));
        });

        test('correctly listens to the provider if normal listener throws', () {
          final dep = StateProvider((ref) => 0);
          final listener = Listener<int>();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep,
                (prev, value) {
                  listener(prev, value);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen<void>(provider, (prev, value) {});

          expect(sub, isNotNull);
          verifyOnly(listener, listener(null, 0));
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          verifyOnly(listener, listener(0, 1));
        });

        test(
            'correctly listens to the provider if selector onError listener throws',
            () async {
          final dep = StateProvider<int>((ref) => 0);
          final dep2 = Provider<int>((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return ref.watch(dep);
          });
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep2.select((value) => value),
                listener.call,
                onError: (err, stack) {
                  errorListener(err, stack);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen(provider, (p, n) {});

          expect(sub, isNotNull);
          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
          );
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyNoMoreInteractions(errorListener);
          verifyOnly(listener, listener(null, 1));
        });

        test(
            'correctly listens to the provider if normal onError listener throws',
            () async {
          final dep = StateProvider<int>((ref) => 0);
          final dep2 = Provider<int>((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return ref.watch(dep);
          });
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep2,
                listener.call,
                onError: (err, stack) {
                  errorListener(err, stack);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen(provider, (p, n) {});

          expect(sub, isNotNull);
          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
          );
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyNoMoreInteractions(errorListener);
          verifyOnly(listener, listener(null, 1));
        });
      });
    });

    group('keepAlive', () {
      test(
          'Does not cause an infinite loop if aborted directly in the callback',
          () async {
        final container = ProviderContainer.test();
        var buildCount = 0;
        var disposeCount = 0;
        final provider = Provider.autoDispose<String>((ref) {
          buildCount++;
          ref.onDispose(() => disposeCount++);
          final link = ref.keepAlive();
          link.close();
          return 'value';
        });

        container.read(provider);

        expect(buildCount, 1);
        expect(disposeCount, 0);
        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        await container.pump();

        expect(buildCount, 1);
        expect(disposeCount, 1);
        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });

      test('when the provider rebuilds, links are cleared', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        KeepAliveLink? a;

        final provider = Provider.autoDispose<void>((ref) {
          ref.watch(dep);
          a ??= ref.keepAlive();
        });

        container.read(provider);
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          contains(provider),
        );

        container.read(dep.notifier).state++;
        // manually trigger rebuild, as the provider is not listened
        container.read(provider);
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isNot(contains(provider)),
        );
      });

      test('maintains the state of the provider until all links are closed',
          () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;
        late KeepAliveLink b;

        final provider = Provider.autoDispose<void>((ref) {
          a = ref.keepAlive();
          b = ref.keepAlive();
        });

        container.read(provider);

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        a.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        b.close();
        await container.pump();

        expect(
          container.getAllProviderElements(),
          isEmpty,
        );
      });

      test(
          'when closing KeepAliveLink, does not dispose the provider if it is still being listened to',
          () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;

        final provider = Provider.autoDispose<void>((ref) {
          a = ref.keepAlive();
        });

        final sub = container.listen<void>(provider, (previous, next) {});

        a.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        sub.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });

      test(
          'when closing the last KeepAliveLink, then immediately adding a new link, '
          'the provider will not be disposed.', () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;
        late Ref<Object?> ref;

        final provider = Provider.autoDispose<void>((r) {
          ref = r;
          a = ref.keepAlive();
        });

        container.read<void>(provider);

        a.close();
        final b = ref.keepAlive();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        b.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });
    });

    group('refresh', () {
      test('refreshes a provider and return the new state', () {
        var value = 0;
        final state = Provider((ref) => value);
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
        });
        final container = ProviderContainer.test();

        container.read(provider);

        expect(container.read(state), 0);

        value = 42;
        expect(ref.refresh(state), 42);
        expect(container.read(state), 42);
      });
    });

    group('.notifyListeners', () {
      test('If called after initialization, notify listeners', () {
        final observer = ProviderObserverMock();
        final listener = Listener<int>();
        final selfListener = Listener<int>();
        final container = ProviderContainer.test(observers: [observer]);
        late Ref<int> ref;
        final provider = Provider<int>((r) {
          ref = r;
          ref.listenSelf(selfListener.call);
          return 0;
        });

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(observer, observer.didAddProvider(provider, 0, container));
        verifyOnly(listener, listener(null, 0));
        verifyOnly(selfListener, selfListener(null, 0));

        ref.notifyListeners();

        verifyOnly(listener, listener(0, 0));
        verifyOnly(selfListener, selfListener(0, 0));
        verifyOnly(
          observer,
          observer.didUpdateProvider(provider, 0, 0, container),
        );
      });

      test(
          'can be invoked during first initialization, and does not notify listeners',
          () {
        final observer = ProviderObserverMock();
        final selfListener = Listener<int>();
        final listener = Listener<int>();
        final container = ProviderContainer.test(observers: [observer]);
        final provider = Provider<int>((ref) {
          ref.listenSelf(selfListener.call);
          ref.notifyListeners();
          return 0;
        });

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(observer, observer.didAddProvider(provider, 0, container));
        verifyOnly(listener, listener(null, 0));
        verifyOnly(selfListener, selfListener(null, 0));
      });

      test(
          'can be invoked during a re-initialization, and does not notify listeners',
          () {
        final observer = ProviderObserverMock();
        final listener = Listener<Object>();
        final selfListener = Listener<Object>();
        final container = ProviderContainer.test(observers: [observer]);
        var callNotifyListeners = false;
        const firstValue = 'first';
        const secondValue = 'second';
        var result = firstValue;
        final provider = Provider<Object>((ref) {
          ref.listenSelf(selfListener.call);
          if (callNotifyListeners) {
            ref.notifyListeners();
          }
          return result;
        });

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(
          observer,
          observer.didAddProvider(provider, firstValue, container),
        );
        verifyOnly(selfListener, selfListener(null, firstValue));
        verifyOnly(listener, listener(null, firstValue));

        result = secondValue;
        callNotifyListeners = true;
        container.refresh(provider);

        verifyOnly(selfListener, selfListener(firstValue, secondValue));
        verifyOnly(listener, listener(firstValue, secondValue));
        verify(observer.didDisposeProvider(provider, container));
        verify(
          observer.didUpdateProvider(
            provider,
            firstValue,
            secondValue,
            container,
          ),
        ).called(1);
        verifyNoMoreInteractions(observer);
      });
    });

    group('.refresh', () {
      test('Throws if a circular dependency is detected', () {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/2336
        late Ref<Object?> ref;
        final a = Provider((r) {
          ref = r;
          return 0;
        });
        final b = Provider((r) => r.watch(a));
        final container = ProviderContainer.test();

        container.read(b);

        expect(
          () => ref.refresh(b),
          throwsA(isA<CircularDependencyError>()),
        );
      });
    });

    group('.invalidate', () {
      test('Throws if a circular dependency is detected', skip: true, () {
        // Regression test for https://github.com/rrousselGit/riverpod/issues/2336
        late Ref<Object?> ref;
        final a = Provider((r) {
          ref = r;
          return 0;
        });
        final b = Provider((r) => r.watch(a));
        final container = ProviderContainer.test();

        container.read(b);

        ;
        expect(
          () => ref.invalidate(b),
          throwsA(isA<CircularDependencyError>()),
        );
      });

      test('Circular dependency ignores families', () {
        late Ref<Object?> ref;
        final a = Provider((r) {
          ref = r;
          return 0;
        });
        final b = Provider.family<int, int>((r, id) => r.watch(a));
        final container = ProviderContainer.test();

        container.read(b(0));

        expect(
          () => ref.invalidate(b),
          returnsNormally,
        );
      });

      test('triggers a rebuild on next frame', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        var result = 0;
        final provider = Provider((r) => result);
        late Ref<Object?> ref;
        final another = Provider((r) {
          ref = r;
        });

        container.listen(provider, listener.call);
        container.read(another);
        verifyZeroInteractions(listener);

        ref.invalidate(provider);
        ref.invalidate(provider);
        result = 1;

        verifyZeroInteractions(listener);

        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      group('on families', () {
        test('recomputes providers associated with the family', () async {
          final container = ProviderContainer.test();
          final listener = Listener<String>();
          final listener2 = Listener<String>();
          final listener3 = Listener<int>();
          var result = 0;
          final unrelated = Provider((ref) => result);
          final provider = Provider.family<String, int>((r, i) => '$result-$i');
          late Ref<Object?> ref;
          final another = Provider((r) {
            ref = r;
          });

          container.read(another);

          container.listen(provider(0), listener.call, fireImmediately: true);
          container.listen(provider(1), listener2.call, fireImmediately: true);
          container.listen(unrelated, listener3.call, fireImmediately: true);

          verifyOnly(listener, listener(null, '0-0'));
          verifyOnly(listener2, listener2(null, '0-1'));
          verifyOnly(listener3, listener3(null, 0));

          ref.invalidate(provider);
          ref.invalidate(provider);
          result = 1;

          verifyNoMoreInteractions(listener);
          verifyNoMoreInteractions(listener2);
          verifyNoMoreInteractions(listener3);

          await container.pump();

          verifyOnly(listener, listener('0-0', '1-0'));
          verifyOnly(listener2, listener2('0-1', '1-1'));
          verifyNoMoreInteractions(listener3);
        });

        test('clears only on the closest family override', () async {
          var result = 0;
          final provider = Provider.family<int, int>(
            (r, i) => result,
            dependencies: const [],
          );
          late Ref<Object?> ref;
          final another = Provider((r) => ref = r, dependencies: [provider]);

          final listener = Listener<int>();
          final listener2 = Listener<int>();
          final root = ProviderContainer.test();
          final container = ProviderContainer.test(
            parent: root,
            overrides: [provider, another],
          );

          container.read(another);
          root.listen(provider(0), listener.call, fireImmediately: true);
          container.listen(provider(1), listener2.call, fireImmediately: true);

          verifyOnly(listener, listener(null, 0));
          verifyOnly(listener2, listener2(null, 0));

          ref.invalidate(provider);
          result = 1;

          verifyNoMoreInteractions(listener);
          verifyNoMoreInteractions(listener2);

          await container.pump();

          verifyOnly(listener2, listener2(0, 1));
          verifyNoMoreInteractions(listener);
        });
      });
    });

    group('.onRemoveListener', () {
      test('is called on read', () {
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final provider = Provider((ref) {
          ref.onRemoveListener(listener.call);
        });

        container.read(provider);

        verifyOnly(listener, listener(any));
      });

      test('calls listeners when container.listen subscriptions are closed',
          () {
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final listener2 = OnRemoveListener();
        final provider = Provider((ref) {
          ref.onRemoveListener(listener.call);
          ref.onRemoveListener(listener2.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        sub.close();

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        final sub2 = container.listen<void>(provider, (previous, next) {});

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        sub2.close();

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners when ref.listen subscriptions are closed', () {
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final listener2 = OnRemoveListener();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onRemoveListener(listener.call);
            ref.onRemoveListener(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) {
            ref = r;
          },
        );

        // initialize ref
        container.read(provider);

        final sub = ref.listen<void>(dep, (previous, next) {});

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        sub.close();

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        final sub2 = ref.listen<void>(dep, (previous, next) {});

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        sub2.close();

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners when ref.watch subscriptions are removed', () {
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final listener2 = OnRemoveListener();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onRemoveListener(listener.call);
            ref.onRemoveListener(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) => ref = r,
        );

        // initialize refs
        container.read(provider);

        ref.watch<void>(dep);

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        container.refresh(provider);

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listeners are cleared on rebuild', () {
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final listener2 = OnRemoveListener();
        var isSecondBuild = false;
        final provider = Provider((ref) {
          if (isSecondBuild) {
            ref.onRemoveListener(listener2.call);
          } else {
            ref.onRemoveListener(listener.call);
          }
        });

        container.read(provider);
        verifyOnly(listener, listener(any));
        verifyZeroInteractions(listener2);

        isSecondBuild = true;
        container.refresh(provider);

        // Removed sub from refresh
        verify(listener2(any)).called(1);

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        verify(listener2(any)).called(1);
        verifyNoMoreInteractions(listener2);
        verifyNoMoreInteractions(listener);
      });

      test('if a listener throws, still calls all listeners', () {
        final errors = <Object?>[];
        final container = ProviderContainer.test();
        final listener = OnRemoveListener();
        final listener2 = OnRemoveListener();
        when(listener(any)).thenThrow(42);
        final provider = Provider((ref) {
          ref.onRemoveListener(listener.call);
          ref.onRemoveListener(listener2.call);
        });

        final sub = container.listen<void>(provider, (prev, next) {});

        runZonedGuarded(
          sub.close,
          (err, stack) => errors.add(err),
        );

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
        expect(errors, [42]);
      });
    });

    group('.onAddListener', () {
      test('is called on read', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final provider = Provider((ref) {
          ref.onAddListener(listener.call);
        });

        container.read(provider);

        verifyOnly(listener, listener(any));
      });

      test('calls listeners when container.listen is invoked', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        final provider = Provider((ref) {
          ref.onAddListener(listener.call);
          ref.onAddListener(listener2.call);
        });

        container.listen<void>(provider, (previous, next) {});

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        container.listen<void>(provider, (previous, next) {});

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners when new ref.listen is invoked', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onAddListener(listener.call);
            ref.onAddListener(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) => ref = r,
        );

        // initialize ref
        container.read(provider);

        ref.listen<void>(dep, (previous, next) {});

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref.listen<void>(dep, (previous, next) {});

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners when new ref.watch is invoked', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onAddListener(listener.call);
            ref.onAddListener(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) => ref = r,
        );
        late Ref<Object?> ref2;
        final provider2 = Provider(
          name: 'provider',
          (r) => ref2 = r,
        );

        // initialize refs
        container.read(provider);
        container.read(provider2);

        ref.watch<void>(dep);

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref.watch<void>(dep);

        // TODO changelog breaking: Calling ref.watch multiple times calls ref.onListen everytime
        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref2.watch<void>(dep);

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listeners are cleared on rebuild', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        var isSecondBuild = false;
        final provider = Provider((ref) {
          if (isSecondBuild) {
            ref.onAddListener(listener2.call);
          } else {
            ref.onAddListener(listener.call);
          }
        });

        container.read(provider);
        verifyOnly(listener, listener(any));

        isSecondBuild = true;
        container.refresh(provider);

        // Added refresh listener
        verifyOnly(listener2, listener2(any));

        container.listen<void>(provider, (previous, next) {});

        verify(listener2(any)).called(1);
        verifyNoMoreInteractions(listener2);
        verifyNoMoreInteractions(listener);
      });

      test('if a listener throws, still calls all listeners', () {
        final errors = <Object?>[];
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        when(listener(any)).thenThrow(42);
        final provider = Provider((ref) {
          ref.onAddListener(listener.call);
          ref.onAddListener(listener2.call);
        });

        runZonedGuarded(
          () => container.listen<void>(provider, (prev, next) {}),
          (err, stack) => errors.add(err),
        );

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
        expect(errors, [42]);
      });
    });

    group('.onResume', () {
      test('is not called on initial subscription', () {
        final container = ProviderContainer.test();
        final listener = OnResume();
        final provider = Provider((ref) {
          ref.onResume(listener.call);
        });

        container.listen<void>(provider, (previous, next) {});

        verifyZeroInteractions(listener);
      });

      test('calls listeners on the first new container.listen after a cancel',
          () {
        final container = ProviderContainer.test();
        final listener = OnResume();
        final listener2 = OnResume();
        final provider = Provider((ref) {
          ref.onResume(listener.call);
          ref.onResume(listener2.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.listen<void>(provider, (previous, next) {});

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        container.listen<void>(provider, (previous, next) {});

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners on the first new ref.listen after a cancel', () {
        final container = ProviderContainer.test();
        final listener = OnResume();
        final listener2 = OnResume();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onResume(listener.call);
            ref.onResume(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) => ref = r,
        );

        // initialize ref
        container.read(provider);

        final sub = ref.listen<void>(dep, (previous, next) {});
        sub.close();

        verifyZeroInteractions(listener);

        ref.listen<void>(dep, (previous, next) {});

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref.listen<void>(dep, (previous, next) {});

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('calls listeners when ref.watch is invoked after a cancel', () {
        final container = ProviderContainer.test();
        final listener = OnAddListener();
        final listener2 = OnAddListener();
        final dep = Provider(
          name: 'dep',
          (ref) {
            ref.onAddListener(listener.call);
            ref.onAddListener(listener2.call);
          },
        );
        late Ref<Object?> ref;
        final provider = Provider(
          name: 'provider',
          (r) => ref = r,
        );

        // initialize refs
        container.read(provider);

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        verifyZeroInteractions(listener);

        ref.watch<void>(dep);

        verifyInOrder([listener(any), listener2(any)]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listeners are cleared on rebuild', () {
        final container = ProviderContainer.test();
        final listener = OnResume();
        final listener2 = OnResume();
        var isSecondBuild = false;
        final provider = Provider((ref) {
          if (isSecondBuild) {
            ref.onResume(listener2.call);
          } else {
            ref.onResume(listener.call);
          }
        });

        container.read(provider);
        isSecondBuild = true;
        container.invalidate(provider);

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.listen<void>(provider, (previous, next) {});

        verify(listener2()).called(1);
        verifyNoMoreInteractions(listener2);
        verifyZeroInteractions(listener);
      });

      test('internal resume status is cleared on rebuild', () {
        final container = ProviderContainer.test();
        final listener = OnResume();
        final provider = Provider((ref) {
          ref.onResume(listener.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        container.invalidate(provider);

        final sub2 = container.listen<void>(provider, (previous, next) {});
        sub2.close();

        verifyZeroInteractions(listener);

        container.listen<void>(provider, (previous, next) {});

        verifyOnly(listener, listener());
      });

      test('if a listener throws, still calls all listeners', () {
        final errors = <Object?>[];
        final container = ProviderContainer.test();
        final listener = OnResume();
        final listener2 = OnResume();
        when(listener()).thenThrow(42);
        final provider = Provider((ref) {
          ref.onResume(listener.call);
          ref.onResume(listener2.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});
        sub.close();

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        runZonedGuarded(
          () => container.listen<void>(provider, (prev, next) {}),
          (err, stack) => errors.add(err),
        );

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
        expect(errors, [42]);
      });
    });

    group('.onCancel', () {
      test(
        'is called when dependent is invalidated and was the only listener',
        // TODO deal with now that we have onPause
        skip: 'Waiting for "clear dependencies after FutureProvider rebuilds"',
        () async {
          //
          final container = ProviderContainer.test();
          final onCancel = OnCancelMock();
          final dep = StateProvider((ref) {
            ref.onCancel(onCancel.call);
            return 0;
          });
          final provider = Provider.autoDispose((ref) => ref.watch(dep));

          container.read(provider);

          verifyZeroInteractions(onCancel);

          container.read(dep.notifier).state++;

          verify(onCancel()).called(1);

          await container.pump();

          verifyNoMoreInteractions(onCancel);
        },
      );

      test('is called when all container listeners are removed', () {
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final listener2 = OnCancelMock();
        final provider = Provider((ref) {
          ref.onCancel(listener.call);
          ref.onCancel(listener2.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});
        final sub2 = container.listen<void>(provider, (previous, next) {});

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        sub.close();

        verifyZeroInteractions(listener2);

        sub2.close();

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('is called when all provider listeners are removed', () {
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final listener2 = OnCancelMock();
        final dep = Provider((ref) {
          ref.onCancel(listener.call);
          ref.onCancel(listener2.call);
        });
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
        });

        container.read(provider);
        final sub = ref.listen<void>(dep, (previous, next) {});
        final sub2 = ref.listen<void>(dep, (previous, next) {});

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        sub.close();

        verifyZeroInteractions(listener2);

        sub2.close();

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('is called when all provider dependencies are removed', () {
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final listener2 = OnCancelMock();
        final dep = Provider(name: 'dep', (ref) {
          ref.onCancel(listener.call);
          ref.onCancel(listener2.call);
        });
        var watching = true;
        final provider = Provider(name: 'provider', (ref) {
          if (watching) ref.watch(dep);
        });
        final provider2 = Provider(name: 'provider2', (ref) {
          if (watching) ref.watch(dep);
        });

        container.listen(provider, (p, n) {});
        container.listen(provider2, (p, n) {});

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        watching = false;
        // remove the dependency provider<>dep
        container.refresh(provider);

        verifyZeroInteractions(listener2);

        // remove the dependency provider2<>dep
        container.refresh(provider2);

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('is called when using container.read', () async {
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final provider = Provider((ref) {
          ref.onCancel(listener.call);
        });

        container.read(provider);

        verifyOnly(listener, listener());
      });

      test('listeners are cleared on rebuild', () {
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final listener2 = OnCancelMock();
        var isSecondBuild = false;
        final provider = Provider((ref) {
          if (isSecondBuild) {
            ref.onCancel(listener2.call);
          } else {
            ref.onCancel(listener.call);
          }
        });

        container.read(provider);
        clearInteractions(listener);

        isSecondBuild = true;
        container.invalidate(provider);

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        final sub = container.listen<void>(provider, (previous, next) {});

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        sub.close();

        verify(listener2()).called(1);
        verifyNoMoreInteractions(listener2);
        verifyZeroInteractions(listener);
      });

      test('if a listener throws, still calls all listeners', () {
        final errors = <Object?>[];
        final container = ProviderContainer.test();
        final listener = OnCancelMock();
        final listener2 = OnCancelMock();
        when(listener()).thenThrow(42);
        final provider = Provider((ref) {
          ref.onCancel(listener.call);
          ref.onCancel(listener2.call);
        });

        final sub = container.listen<void>(provider, (previous, next) {});

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        runZonedGuarded(
          sub.close,
          (err, stack) => errors.add(err),
        );

        verifyInOrder([listener(), listener2()]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
        expect(errors, [42]);
      });
    });

    group('.onDispose', () {
      test(
          'calls all the listeners in order when the ProviderContainer is disposed',
          () {
        final onDispose = OnDisposeMock();
        final onDispose2 = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(onDispose.call);
          ref.onDispose(onDispose2.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);
        verifyZeroInteractions(onDispose2);

        container.dispose();

        verifyInOrder([
          onDispose(),
          onDispose2(),
        ]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);
      });

      test('calls all listeners in order when one of its dependency changed',
          () async {
        final onDispose = OnDisposeMock();
        final onDispose2 = OnDisposeMock();

        final count = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(count);
          ref.onDispose(onDispose.call);
          ref.onDispose(onDispose2.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);
        verifyZeroInteractions(onDispose2);

        container.read(count.notifier).state++;
        await container.pump();

        verifyInOrder([
          onDispose(),
          onDispose2(),
        ]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);
      });

      test('does not call listeners again if more than one dependency changed',
          () {
        final onDispose = OnDisposeMock();

        final count = StateProvider((ref) => 0);
        final count2 = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(count);
          ref.watch(count2);
          ref.onDispose(onDispose.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);

        container.read(count.notifier).state++;
        container.read(count2.notifier).state++;

        verifyOnly(onDispose, onDispose());
      });

      test(
          'does not call listeners again if a dependency changed then ProviderContainer was disposed',
          () async {
        final onDispose = OnDisposeMock();
        var buildCount = 0;

        final count = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          buildCount++;
          ref.watch(count);
          ref.onDispose(onDispose.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks
        expect(buildCount, 1);

        verifyZeroInteractions(onDispose);

        container.read(count.notifier).state++;
        // no pump() because that would rebuild the provider, which means it would
        // need to be disposed once again.

        verifyOnly(onDispose, onDispose());

        container.dispose();

        expect(buildCount, 1);
        verifyNoMoreInteractions(onDispose);
      });
    });

    group('mounted', () {
      test('stays false on older refs while new refs are building', () {
        final container = ProviderContainer.test();
        late Ref<int> ref;
        final provider = Provider<int>((r) {
          ref = r;
          return 0;
        });

        container.read(provider);
        final oldRef = ref;

        container.refresh(provider);

        expect(oldRef.mounted, false);
        expect(ref.mounted, true);
      });

      test('is false during onDispose caused by ref.watch', () {
        final container = ProviderContainer.test();
        bool? mounted;
        late Ref<Object?> ref;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((r) {
          ref = r;
          ref.watch(dep);
          ref.onDispose(() => mounted = ref.mounted);
        });

        container.read(provider);
        expect(mounted, null);

        container.read(dep.notifier).state++;

        expect(mounted, false);
      });

      test('is false during onDispose caused by container dispose', () {
        final container = ProviderContainer.test();
        bool? mounted;
        late Ref<Object?> ref;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((r) {
          ref = r;
          ref.watch(dep);
          ref.onDispose(() => mounted = ref.mounted);
        });

        container.read(provider);
        expect(mounted, null);

        container.dispose();

        expect(mounted, false);
      });

      test('is false in between rebuilds', () {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
          ref.watch(dep);
        });

        container.read(provider);
        expect(ref.mounted, true);

        container.read(dep.notifier).state++;

        expect(ref.mounted, false);
      });
    });
  });
}
