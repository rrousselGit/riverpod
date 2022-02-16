import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ResultError;
import 'package:test/test.dart';

import '../third_party/fake_async.dart';
import '../utils.dart';

void main() {
  group('cacheTime', () {
    test('keeps autoDispose provider alive for at least duration', () async {
      fakeAsync((async) {
        final container = createContainer();
        final listener = OnDisposeMock();
        final provider = Provider.autoDispose(
          (ref) => ref.onDispose(listener),
          cacheTime: const Duration(seconds: 2),
        );

        container.read(provider);
        verifyZeroInteractions(listener);

        async.elapse(const Duration(seconds: 1));

        verifyZeroInteractions(listener);

        async.elapse(const Duration(seconds: 1));

        verifyOnly(listener, listener());
      });
    });

    test('if provider rebuilds, reset the timer', () async {
      fakeAsync((async) {
        final container = createContainer();
        final listener = OnDisposeMock();
        final provider = Provider.autoDispose(
          (ref) => ref.onDispose(listener),
          cacheTime: const Duration(seconds: 5),
        );

        container.read(provider);
        verifyZeroInteractions(listener);

        async.elapse(const Duration(seconds: 3));

        verifyZeroInteractions(listener);

        container.refresh(provider);
        verifyOnly(listener, listener());

        async.elapse(const Duration(seconds: 3));

        verifyNoMoreInteractions(listener);

        async.elapse(const Duration(seconds: 2));

        verifyOnly(listener, listener());
      });
    });

    test('If provider.cacheTime is null, use container.cacheTime', () async {
      fakeAsync((async) {
        final listener = OnDisposeMock();
        final provider = Provider.autoDispose((ref) => ref.onDispose(listener));
        final root = createContainer(
          cacheTime: const Duration(seconds: 10),
        );
        final container = createContainer(
          parent: root,
          cacheTime: const Duration(seconds: 5),
          overrides: [provider],
        );

        container.read(provider);
        verifyZeroInteractions(listener);

        async.elapse(const Duration(seconds: 2));

        verifyZeroInteractions(listener);

        async.elapse(const Duration(seconds: 3));

        verifyOnly(listener, listener());
      });
    });
  });

  group('ref.onRemoveListener', () {
    test('is not called on read', () {
      final container = createContainer();
      final listener = OnRemoveListener();
      final provider = Provider((ref) {
        ref.onRemoveListener(listener);
      });

      container.read(provider);

      verifyZeroInteractions(listener);
    });

    test('calls listeners when container.listen subscriptions are closed', () {
      final container = createContainer();
      final listener = OnRemoveListener();
      final listener2 = OnRemoveListener();
      final provider = Provider((ref) {
        ref.onRemoveListener(listener);
        ref.onRemoveListener(listener2);
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
      final dep = Provider((ref) {
        ref.onRemoveListener(listener);
        ref.onRemoveListener(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');

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
      final dep = Provider((ref) {
        ref.onRemoveListener(listener);
        ref.onRemoveListener(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');

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
          ref.onRemoveListener(listener2);
        } else {
          ref.onRemoveListener(listener);
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
        ref.onRemoveListener(listener);
        ref.onRemoveListener(listener2);
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
        ref.onAddListener(listener);
      });

      container.read(provider);

      verifyZeroInteractions(listener);
    });

    test('calls listeners when container.listen is invoked', () {
      final container = createContainer();
      final listener = OnAddListener();
      final listener2 = OnAddListener();
      final provider = Provider((ref) {
        ref.onAddListener(listener);
        ref.onAddListener(listener2);
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
      final dep = Provider((ref) {
        ref.onAddListener(listener);
        ref.onAddListener(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');

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
      final dep = Provider((ref) {
        ref.onAddListener(listener);
        ref.onAddListener(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');
      late Ref ref2;
      final provider2 = Provider((r) {
        ref2 = r;
      }, name: 'provider');

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
          ref.onAddListener(listener2);
        } else {
          ref.onAddListener(listener);
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
        ref.onAddListener(listener);
        ref.onAddListener(listener2);
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
        ref.onResume(listener);
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
        ref.onResume(listener);
        ref.onResume(listener2);
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
      final dep = Provider((ref) {
        ref.onResume(listener);
        ref.onResume(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');

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
        ref.onResume(listener);
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
      final dep = Provider((ref) {
        ref.onAddListener(listener);
        ref.onAddListener(listener2);
      }, name: 'dep');
      late Ref ref;
      final provider = Provider((r) {
        ref = r;
      }, name: 'provider');

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
          ref.onResume(listener2);
        } else {
          ref.onResume(listener);
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
        ref.onResume(listener);
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
        ref.onResume(listener);
        ref.onResume(listener2);
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
    test('is called when all container listeners are removed', () {
      final container = createContainer();
      final listener = OnCancelMock();
      final listener2 = OnCancelMock();
      final provider = Provider((ref) {
        ref.onCancel(listener);
        ref.onCancel(listener2);
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
        ref.onCancel(listener);
        ref.onCancel(listener2);
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
        ref.onCancel(listener);
        ref.onCancel(listener2);
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
        ref.onCancel(listener);
      });

      container.read(provider);
      await container.pump();

      verifyZeroInteractions(listener);
    });

    test('listeners are cleared on rebuild', () {
      final container = createContainer();
      final listener = OnCancelMock();
      final listener2 = OnCancelMock();
      var isSecondBuild = false;
      final provider = Provider((ref) {
        if (isSecondBuild) {
          ref.onCancel(listener2);
        } else {
          ref.onCancel(listener);
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
        ref.onCancel(listener);
        ref.onCancel(listener2);
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
      'onDispose is triggered only once if within autoDispose unmount, a dependency chnaged',
      () async {
    // regression test for https://github.com/rrousselGit/river_pod/issues/1064
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final dep = StateProvider((ref) => 0);
    final provider = Provider.autoDispose((ref) {
      ref.watch(dep);
      ref.onDispose(onDispose);
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
    container.listen(dependent, listener, fireImmediately: true);

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
        isA<ResultError>()
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

      final children = <ProviderElementBase>[];

      container.readProviderElement(provider).visitChildren(children.add);
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase>()
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

      final children = <ProviderElementBase>[];

      container.readProviderElement(provider).visitChildren(children.add);
      expect(
        children,
        unorderedMatches(<Object>[
          isA<ProviderElementBase>()
              .having((e) => e.provider, 'provider', dependent),
          isA<ProviderElementBase>()
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
      ref.watch(dep.state).state;
      return ref.state = 0;
    });

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));

    container.read(dep.state).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });
}
