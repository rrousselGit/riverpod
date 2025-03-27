import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('Ref.exists', () {
    test('Returns true if available on ancestor container', () {
      final root = createContainer();
      final container = createContainer(parent: root);
      final provider = Provider((ref) => 0);

      root.read(provider);

      expect(container.exists(provider), true);
      expect(root.exists(provider), true);
    });

    test('simple use-case', () {
      final container = createContainer();
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

      expect(ref.exists(refProvider), true);
      expect(ref.exists(provider), true);
    });
  });

  group('ref.notifyListeners', () {
    test('If called after initialization, notify listeners', () {
      final observer = ProviderObserverMock();
      final listener = Listener<int>();
      final selfListener = Listener<int>();
      final container = createContainer(observers: [observer]);
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
      final container = createContainer(observers: [observer]);
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
      final container = createContainer(observers: [observer]);
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

  group('ref.refresh', () {
    test('Throws if a circular dependency is detected', () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2336
      late Ref ref;
      final a = Provider(name: 'a', (r) {
        ref = r;
        return 0;
      });
      final b = Provider(name: 'b', (r) => r.watch(a));
      final container = createContainer();

      container.read(b);

      expect(
        () => ref.refresh(b),
        throwsA(isA<CircularDependencyError>()),
      );
    });
  });

  group('ref.invalidate', () {
    test('Throws if a circular dependency is detected', () {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2336
      late Ref ref;
      final a = Provider((r) {
        ref = r;
        return 0;
      });
      final b = Provider((r) => r.watch(a));
      final container = createContainer();

      container.read(b);

      expect(
        () => ref.invalidate(b),
        throwsA(isA<CircularDependencyError>()),
      );
    });

    test('Circular dependency ignores families', () {
      late Ref ref;
      final a = Provider((r) {
        ref = r;
        return 0;
      });
      final b = Provider.family<int, int>((r, id) => r.watch(a));
      final container = createContainer();

      container.read(b(0));

      expect(
        () => ref.invalidate(b),
        returnsNormally,
      );
    });

    test('triggers a rebuild on next frame', () async {
      final container = createContainer();
      final listener = Listener<int>();
      var result = 0;
      final provider = Provider((r) => result);
      late Ref ref;
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
        final container = createContainer();
        final listener = Listener<String>();
        final listener2 = Listener<String>();
        final listener3 = Listener<int>();
        var result = 0;
        final unrelated = Provider((ref) => result);
        final provider = Provider.family<String, int>((r, i) => '$result-$i');
        late Ref ref;
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
        late Ref ref;
        final another = Provider((r) {
          ref = r;
        });
        var result = 0;
        final provider = Provider.family<int, int>((r, i) => result);
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        final root = createContainer();
        final container = createContainer(
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

  group('ref.invalidateSelf', () {
    test('calls dispose immediately', () {
      final container = createContainer();
      final listener = OnDisposeMock();
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
        ref.onDispose(listener.call);
      });

      container.read(provider);
      verifyZeroInteractions(listener);

      ref.invalidateSelf();

      verifyOnly(listener, listener());

      ref.invalidateSelf();

      verifyNoMoreInteractions(listener);
    });

    test('triggers a rebuild on next frame', () async {
      final container = createContainer();
      final listener = Listener<int>();
      var result = 0;
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
        return result;
      });

      container.listen(provider, listener.call);
      verifyZeroInteractions(listener);

      ref.invalidateSelf();
      ref.invalidateSelf();
      result = 1;

      verifyZeroInteractions(listener);

      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test('merges the rebuild with dependency change rebuild', () async {
      final container = createContainer();
      final listener = Listener<int>();
      final dep = StateProvider((ref) => 0);
      late Ref ref;
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
  });

  group('ref.onRemoveListener', () {
    test('is not called on read', () {
      final container = createContainer();
      final listener = OnRemoveListener();
      final provider = Provider((ref) {
        ref.onRemoveListener(listener.call);
      });

      container.read(provider);

      verifyZeroInteractions(listener);
    });

    test('calls listeners when container.listen subscriptions are closed', () {
      final container = createContainer();
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

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      final sub2 = container.listen<void>(provider, (previous, next) {});

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      sub2.close();

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('calls listeners when ref.listen subscriptions are closed', () {
      final container = createContainer();
      final listener = OnRemoveListener();
      final listener2 = OnRemoveListener();
      final dep = Provider(
        name: 'dep',
        (ref) {
          ref.onRemoveListener(listener.call);
          ref.onRemoveListener(listener2.call);
        },
      );
      late Ref ref;
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

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      final sub2 = ref.listen<void>(dep, (previous, next) {});

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      sub2.close();

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('calls listeners when ref.watch subscriptions are removed', () {
      final container = createContainer();
      final listener = OnRemoveListener();
      final listener2 = OnRemoveListener();
      final dep = Provider(
        name: 'dep',
        (ref) {
          ref.onRemoveListener(listener.call);
          ref.onRemoveListener(listener2.call);
        },
      );
      late Ref ref;
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

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('listeners are cleared on rebuild', () {
      final container = createContainer();
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
      isSecondBuild = true;
      container.refresh(provider);

      final sub = container.listen<void>(provider, (previous, next) {});
      sub.close();

      verify(listener2()).called(1);
      verifyNoMoreInteractions(listener2);
      verifyZeroInteractions(listener);
    });

    test('if a listener throws, still calls all listeners', () {
      final errors = <Object?>[];
      final container = createContainer();
      final listener = OnRemoveListener();
      final listener2 = OnRemoveListener();
      when(listener()).thenThrow(42);
      final provider = Provider((ref) {
        ref.onRemoveListener(listener.call);
        ref.onRemoveListener(listener2.call);
      });

      final sub = container.listen<void>(provider, (prev, next) {});

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

  group('ref.onAddListener', () {
    test('is not called on read', () {
      final container = createContainer();
      final listener = OnAddListener();
      final provider = Provider((ref) {
        ref.onAddListener(listener.call);
      });

      container.read(provider);

      verifyZeroInteractions(listener);
    });

    test('calls listeners when container.listen is invoked', () {
      final container = createContainer();
      final listener = OnAddListener();
      final listener2 = OnAddListener();
      final provider = Provider((ref) {
        ref.onAddListener(listener.call);
        ref.onAddListener(listener2.call);
      });

      container.listen<void>(provider, (previous, next) {});

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      container.listen<void>(provider, (previous, next) {});

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('calls listeners when new ref.listen is invoked', () {
      final container = createContainer();
      final listener = OnAddListener();
      final listener2 = OnAddListener();
      final dep = Provider(name: 'dep', (ref) {
        ref.onAddListener(listener.call);
        ref.onAddListener(listener2.call);
      });
      late Ref ref;
      final provider = Provider(
        name: 'provider',
        (r) => ref = r,
      );

      // initialize ref
      container.read(provider);

      ref.listen<void>(dep, (previous, next) {});

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      ref.listen<void>(dep, (previous, next) {});

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('calls listeners when new ref.watch is invoked', () {
      final container = createContainer();
      final listener = OnAddListener();
      final listener2 = OnAddListener();
      final dep = Provider(
        name: 'dep',
        (ref) {
          ref.onAddListener(listener.call);
          ref.onAddListener(listener2.call);
        },
      );
      late Ref ref;
      final provider = Provider(
        name: 'provider',
        (r) => ref = r,
      );
      late Ref ref2;
      final provider2 = Provider(
        name: 'provider',
        (r) => ref2 = r,
      );

      // initialize refs
      container.read(provider);
      container.read(provider2);

      ref.watch<void>(dep);

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      ref.watch<void>(dep);

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);

      ref2.watch<void>(dep);

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('listeners are cleared on rebuild', () {
      final container = createContainer();
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
      isSecondBuild = true;
      container.refresh(provider);

      container.listen<void>(provider, (previous, next) {});

      verify(listener2()).called(1);
      verifyNoMoreInteractions(listener2);
      verifyZeroInteractions(listener);
    });

    test('if a listener throws, still calls all listeners', () {
      final errors = <Object?>[];
      final container = createContainer();
      final listener = OnAddListener();
      final listener2 = OnAddListener();
      when(listener()).thenThrow(42);
      final provider = Provider((ref) {
        ref.onAddListener(listener.call);
        ref.onAddListener(listener2.call);
      });

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

  group('ref.onResume', () {
    test('is not called on initial subscription', () {
      final container = createContainer();
      final listener = OnResume();
      final provider = Provider((ref) {
        ref.onResume(listener.call);
      });

      container.read(provider);
      container.listen<void>(provider, (previous, next) {});

      verifyZeroInteractions(listener);
    });

    test('calls listeners on the first new container.listen after a cancel',
        () {
      final container = createContainer();
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
      final container = createContainer();
      final listener = OnResume();
      final listener2 = OnResume();
      final dep = Provider(
        name: 'dep',
        (ref) {
          ref.onResume(listener.call);
          ref.onResume(listener2.call);
        },
      );
      late Ref ref;
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

    test('does not call listeners on read after a cancel', () {
      final container = createContainer();
      final listener = OnResume();
      final provider = Provider((ref) {
        ref.onResume(listener.call);
      });

      final sub = container.listen<void>(provider, (previous, next) {});
      sub.close();

      verifyZeroInteractions(listener);

      container.read(provider);

      verifyZeroInteractions(listener);
    });

    test('calls listeners when ref.watch is invoked after a cancel', () {
      final container = createContainer();
      final listener = OnResume();
      final listener2 = OnResume();
      final dep = Provider(
        name: 'dep',
        (ref) {
          ref.onAddListener(listener.call);
          ref.onAddListener(listener2.call);
        },
      );
      late Ref ref;
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

      verifyInOrder([listener(), listener2()]);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
    });

    test('listeners are cleared on rebuild', () {
      final container = createContainer();
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
      container.refresh(provider);

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
      final container = createContainer();
      final listener = OnResume();
      final provider = Provider((ref) {
        ref.onResume(listener.call);
      });

      final sub = container.listen<void>(provider, (previous, next) {});
      sub.close();

      container.refresh(provider);

      final sub2 = container.listen<void>(provider, (previous, next) {});
      sub2.close();

      verifyZeroInteractions(listener);

      container.listen<void>(provider, (previous, next) {});

      verifyOnly(listener, listener());
    });

    test('if a listener throws, still calls all listeners', () {
      final errors = <Object?>[];
      final container = createContainer();
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

  group('ref.onCancel', () {
    test(
      'is called when dependent is invalidated and was the only listener',
      skip: 'Waiting for "clear dependencies after futureprovider rebuilds"',
      () async {
        //
        final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
      final listener = OnCancelMock();
      final listener2 = OnCancelMock();
      final dep = Provider((ref) {
        ref.onCancel(listener.call);
        ref.onCancel(listener2.call);
      });
      late Ref ref;
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
      final container = createContainer();
      final listener = OnCancelMock();
      final listener2 = OnCancelMock();
      final dep = Provider((ref) {
        ref.onCancel(listener.call);
        ref.onCancel(listener2.call);
      });
      var watching = true;
      final provider = Provider((ref) {
        if (watching) ref.watch(dep);
      });
      final provider2 = Provider((ref) {
        if (watching) ref.watch(dep);
      });

      container.read(provider);
      container.read(provider2);

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

    test('is not called when using container.read', () async {
      final container = createContainer();
      final listener = OnCancelMock();
      final provider = Provider((ref) {
        ref.onCancel(listener.call);
      });

      container.read(provider);
      await container.pump();

      verifyZeroInteractions(listener);
    });

    test(
      'is not called when using container.read (autoDispose)',
      skip: true,
      () async {
        final container = createContainer();
        final listener = OnCancelMock();
        final dispose = OnDisposeMock();
        final provider = StateProvider.autoDispose((ref) {
          ref.keepAlive();
          ref.onCancel(listener.call);
          ref.onDispose(dispose.call);
        });

        container.read(provider);
        await container.pump();

        verifyZeroInteractions(listener);
        verifyZeroInteractions(dispose);
      },
    );

    test('listeners are cleared on rebuild', () {
      final container = createContainer();
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
      isSecondBuild = true;
      container.refresh(provider);

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
      final container = createContainer();
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

  test(
      'onDispose is triggered only once if within autoDispose unmount, a dependency changed',
      () async {
    // regression test for https://github.com/rrousselGit/riverpod/issues/1064
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final dep = StateProvider((ref) => 0);
    final provider = Provider.autoDispose((ref) {
      ref.watch(dep);
      ref.onDispose(onDispose.call);
    });

    when(onDispose()).thenAnswer((realInvocation) {
      container.read(dep.notifier).state++;
    });

    container.read(provider);
    verifyZeroInteractions(onDispose);

    // cause provider to be disposed
    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test(
      'does not throw outdated error when a dependency is flushed while the dependent is building',
      () async {
    final container = createContainer();
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
    // And since nothing is watchin `dep` at the moment, then `dependent` will
    // rebuild before `dep` even though `dep` is its ancestor.
    // This is fine since nothing is listening to `dep` yet, but it should
    // not cause certain assertions to trigger
    container.read(a.notifier).state++;
    await container.pump();

    verifyOnly(listener, listener(null, 11));
  });

  group('getState', () {
    test('throws on providers that threw', () {
      final container = createContainer();
      final provider = Provider((ref) => throw UnimplementedError());

      final element = container.readProviderElement(provider);

      expect(
        element.getState(),
        isA<ResultError<Object?>>()
            .having((e) => e.error, 'error', isUnimplementedError),
      );
    });
  });

  group('readSelf', () {
    test('throws on providers that threw', () {
      final container = createContainer();
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
      final container = createContainer();
      final provider = Provider((ref) => 0);
      final dependent = Provider((ref) {
        ref.watch(provider);
      });
      final dependent2 = Provider((ref) {
        ref.watch(provider);
      });

      container.read(dependent);
      container.read(dependent2);

      final children = <ProviderElementBase<Object?>>[];

      container
          .readProviderElement(provider)
          .visitChildren(elementVisitor: children.add, notifierVisitor: (_) {});
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.provider, 'provider', dependent2),
        ]),
      );
    });

    test('includes ref.listen dependents', () {
      final container = createContainer();
      final provider = Provider((ref) => 0);
      final dependent = Provider((ref) {
        ref.listen(provider, (_, __) {});
      });
      final dependent2 = Provider((ref) {
        ref.listen(provider, (_, __) {});
      });

      container.read(dependent);
      container.read(dependent2);

      final children = <ProviderElementBase<Object?>>[];

      container
          .readProviderElement(provider)
          .visitChildren(elementVisitor: children.add, notifierVisitor: (_) {});
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.provider, 'provider', dependent2),
        ]),
      );
    });

    test('include ref.read dependents', () {}, skip: true);
  });

  group('hasListeners', () {
    test('includes provider listeners', () async {
      final provider = Provider((ref) => 0);
      final dep = Provider((ref) {
        ref.listen(provider, (prev, value) {});
      });
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.read(dep);

      expect(container.readProviderElement(provider).hasListeners, true);
    });

    test('includes provider dependents', () async {
      final provider = Provider((ref) => 0);
      final dep = Provider((ref) {
        ref.watch(provider);
      });
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.read(dep);

      expect(container.readProviderElement(provider).hasListeners, true);
    });

    test('includes container listeners', () async {
      final provider = Provider((ref) => 0);
      final container = createContainer();

      expect(container.readProviderElement(provider).hasListeners, false);

      container.listen(provider, (_, __) {});

      expect(container.readProviderElement(provider).hasListeners, true);
    });
  });

  test('does not notify listeners when rebuilding the state', () async {
    final container = createContainer();
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
}
