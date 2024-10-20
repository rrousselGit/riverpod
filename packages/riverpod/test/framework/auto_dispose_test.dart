// ignore_for_file: deprecated_member_use_from_same_package

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

Future<void> main() async {
  test(
      'When a non-overridden autoDispose provider is disposed '
      'and the associated ProviderContainer has a child ProviderContainer which overrides said provider, '
      'the child container keeps its override', () async {
// Regression test for https://github.com/rrousselGit/riverpod/issues/1519

    final root = createContainer();
    final provider = Provider.autoDispose((ref) => 0);
    final child = createContainer(
      parent: root,
      overrides: [provider.overrideWithValue(42)],
    );

    root.read(provider);

    await root.pump();

    child.updateOverrides([
      provider.overrideWithValue(21),
    ]);

    expect(child.read(provider), 21);
  });

  test(
      'Handles cases where the ProviderContainer is disposed yet Scheduler.performDispose is invoked anyway',
      () async {
    // regression test for https://github.com/rrousselGit/riverpod/issues/1400
    final provider = Provider.autoDispose((ref) => 0);
    final root = createContainer();
    final container = createContainer(parent: root, overrides: [provider]);

    container.read(provider);
    container.dispose();

    await root.pump();
  });

  group('ref.keepAlive', () {
    test('Does not cause an infinite loop if aborted directly in the callback',
        () async {
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
        'when closing KeepAliveLink, does not dispose the provider maintainState=true',
        () async {
      final container = createContainer();
      late KeepAliveLink a;
      late AutoDisposeRef<Object?> ref;

      final provider = Provider.autoDispose<void>((r) {
        ref = r;
        r.maintainState = true;
        a = ref.keepAlive();
      });

      container.read<void>(provider);

      a.close();
      await container.pump();

      expect(
        container.getAllProviderElements().map((e) => e.provider),
        [provider],
      );

      ref.maintainState = false;
      await container.pump();

      expect(
        container.getAllProviderElements().map((e) => e.provider),
        isEmpty,
      );
    });

    test(
        'when closing the last KeepAliveLink, then immediately adding a new link, '
        'the provider will not be disposed.', () async {
      final container = createContainer();
      late KeepAliveLink a;
      late AutoDisposeRef<Object?> ref;

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

  test('Can ref.read autoDispose selectors inside non-autoDispose providers',
      () {
    final autoDispose = Provider.autoDispose<int>((ref) => 0);

    Provider((ref) {
      ref.read(
        autoDispose.select((value) => value),
      );
    });
  });

  test(
      'if a dependency changed, the element is still disposed, '
      'but without calling ref.onDispose again', () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final dep = StateProvider((ref) => 0);
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return ref.watch(dep);
    });

    container.read(provider);

    verifyZeroInteractions(onDispose);
    expect(
      container.getAllProviderElements().map((e) => e.origin),
      contains(provider),
    );

    container.read(dep.notifier).state++;

    await container.pump();

    verify(onDispose()).called(1);

    expect(
      container.getAllProviderElements().map((e) => e.origin),
      isNot(contains(provider)),
    );
  });

  test(
      'when a provider conditionally depends on another provider, rebuilding without the dependency can dispose the dependency',
      () async {
    final container = createContainer();
    var dependencyDisposeCount = 0;
    final dependency = Provider.autoDispose(
      name: 'dependency',
      (ref) {
        ref.onDispose(() => dependencyDisposeCount++);
        return 0;
      },
    );
    final isDependingOnDependency = StateProvider(
      name: 'isDependingOnDependency',
      (ref) => true,
    );
    final provider = Provider.autoDispose(
      name: 'provider',
      (ref) {
        ref.maintainState = true;
        if (ref.watch(isDependingOnDependency)) {
          ref.watch(dependency);
        }
      },
    );

    container.listen<void>(provider, (_, __) {});

    expect(dependencyDisposeCount, 0);
    expect(
      container.getAllProviderElements().map((e) => e.provider),
      unorderedEquals(<Object>[
        dependency,
        provider,
        isDependingOnDependency,
      ]),
    );

    container.read(isDependingOnDependency.notifier).state = false;
    await container.pump();

    expect(dependencyDisposeCount, 1);
    expect(
      container.getAllProviderElements().map((e) => e.provider),
      unorderedEquals(<Object>[
        provider,
        isDependingOnDependency,
      ]),
    );
  });

  test('works if used across a ProviderContainer', () async {
    var value = 0;
    var buildCount = 0;
    var disposeCount = 0;
    final listener = Listener<int>();
    final provider = Provider.autoDispose((ref) {
      buildCount++;
      ref.onDispose(() => disposeCount++);
      return value;
    });

    final root = createContainer();
    final container = createContainer(parent: root);

    final sub =
        container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, 0));
    expect(buildCount, 1);
    expect(disposeCount, 0);

    sub.close();
    await container.pump();

    expect(buildCount, 1);
    expect(disposeCount, 1);
    verifyNoMoreInteractions(listener);
    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    value = 42;
    container.listen(provider, listener.call, fireImmediately: true);

    expect(buildCount, 2);
    expect(disposeCount, 1);
    verifyOnly(listener, listener(null, 42));
  });

  test('scoped autoDispose override preserve the override after one disposal',
      () async {
    final provider = Provider.autoDispose((ref) => 0);

    final root = createContainer();
    final container = createContainer(parent: root, overrides: [provider]);

    container.read(provider);
    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isNotEmpty);

    await container.pump();

    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    container.read(provider);

    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isNotEmpty);
  });

  test(
      'scoped autoDispose override  through intermediary unused container preserve the override after one disposal',
      () async {
    final provider = Provider.autoDispose((ref) => 0);

    final root = createContainer();
    final mid = createContainer(parent: root, overrides: [provider]);
    final container = createContainer(parent: mid);

    container.read(provider);
    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isNotEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    await container.pump();

    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    container.read(provider);

    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isNotEmpty);
    expect(container.getAllProviderElements(), isEmpty);
  });

  test(
      'scoped autoDispose override preserve family override after one disposal',
      () async {
    final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);

    final root = createContainer();
    final container = createContainer(parent: root, overrides: [provider]);

    container.read(provider(0));
    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isNotEmpty);

    await container.pump();

    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    container.read(provider(0));

    expect(root.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isNotEmpty);
  });

  test(
      'scoped autoDispose override through intermediary unused container preserve family  override after one disposal',
      () async {
    final provider = Provider.autoDispose.family<int, int>((ref, _) => 0);

    final root = createContainer();
    final mid = createContainer(parent: root, overrides: [provider]);
    final container = createContainer(parent: mid);

    container.read(provider(0));
    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isNotEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    await container.pump();

    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isEmpty);
    expect(container.getAllProviderElements(), isEmpty);

    container.read(provider(0));

    expect(root.getAllProviderElements(), isEmpty);
    expect(mid.getAllProviderElements(), isNotEmpty);
    expect(container.getAllProviderElements(), isEmpty);
  });

  test('supports disposing of overridden families', () async {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/2480
    final provider = Provider.autoDispose.family<int, int>((ref, _) => -1);

    var constructionCount = 0;
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [provider.overrideWith((ref, arg) => ++constructionCount)],
    );

    var count = container.read(provider(0));
    expect(count, 1);

    await container.pump();

    count = container.read(provider(0));
    expect(count, 2);
  });

  test(
      'can select auto-dispose providers if the selecting provider is auto-dispose too',
      () {
    final container = createContainer();
    final selected = Provider.autoDispose((ref) => 0);
    final isEven = Provider.autoDispose((ref) {
      return ref.watch(selected.select((c) => c.isEven));
    });

    expect(container.read(isEven), true);
  });

  test('setting maintainState to false destroys the state when not listened to',
      () async {
    final onDispose = OnDisposeMock();
    late AutoDisposeRef<Object?> ref;
    final provider = Provider.autoDispose((r) {
      ref = r;
      ref.onDispose(onDispose.call);
      ref.maintainState = true;
    });
    final container = createContainer();

    final sub = container.listen<void>(provider, (prev, value) {});
    sub.close();

    await container.pump();

    verifyZeroInteractions(onDispose);

    ref.maintainState = false;

    verifyZeroInteractions(onDispose);

    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test(
      "maintainState to true don't dispose the state when no longer listened to",
      () async {
    var value = 42;
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      ref.maintainState = true;
      return value;
    });
    final container = createContainer();
    final listener = Listener<int>();

    final sub =
        container.listen(provider, listener.call, fireImmediately: true);
    verify(listener(null, 42)).called(1);
    verifyNoMoreInteractions(listener);
    sub.close();

    await container.pump();

    verifyZeroInteractions(onDispose);

    value = 21;
    container.listen(provider, listener.call, fireImmediately: true);

    verify(listener(null, 42)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('maintainState defaults to false', () {
    late bool maintainState;
    final provider = Provider.autoDispose((ref) {
      maintainState = ref.maintainState;
      return 42;
    });
    final container = createContainer();

    container.listen(provider, (prev, value) {});

    expect(maintainState, false);
  });

  test('unsub to A then make B sub to A then unsub to B disposes B before A',
      () async {
    final container = createContainer();
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose.call);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose.call);
      ref.watch(a);
      return '42';
    });

    final subA = container.listen(a, (prev, value) {});
    subA.close();

    final subB = container.listen(b, (prev, value) {});
    subB.close();

    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    await container.pump();

    verifyInOrder([
      bDispose(),
      aDispose(),
    ]);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  test('chain', () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    var value = 42;
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return value;
    });
    final onDispose2 = OnDisposeMock();
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(onDispose2.call);
      return ref.watch(provider);
    });
    final listener = Listener<int>();

    var sub = container.listen(provider2, listener.call, fireImmediately: true);

    verify(listener(null, 42)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    sub.close();

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    await container.pump();

    verifyNoMoreInteractions(listener);
    verifyInOrder([
      onDispose2(),
      onDispose(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    value = 21;
    sub = container.listen(provider2, listener.call, fireImmediately: true);

    verify(listener(null, 21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });

  test("auto dispose A then auto dispose B doesn't dispose A again", () async {
    final container = createContainer();
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose.call);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose.call);
      return 42;
    });

    var subA = container.listen(a, (prev, value) {});
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
    subA.close();

    await container.pump();

    verify(aDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);

    subA = container.listen(a, (prev, value) {});
    final subB = container.listen(b, (prev, value) {});

    subB.close();

    await container.pump();

    verify(bDispose()).called(1);
    verifyNoMoreInteractions(aDispose);
    verifyNoMoreInteractions(bDispose);
  });

  test('ProviderContainer was disposed before AutoDisposer handled the dispose',
      () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return 42;
    });

    final sub = container.listen(provider, (prev, value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    verifyNoMoreInteractions(onDispose);

    container.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await container.pump();

    verifyNoMoreInteractions(onDispose);
  });

  test('unsub no-op if another sub is added before event-loop', () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return 42;
    });

    final sub = container.listen(provider, (prev, value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    verifyNoMoreInteractions(onDispose);

    final sub2 = container.listen(provider, (prev, value) {});

    await container.pump();

    verifyNoMoreInteractions(onDispose);

    sub2.close();
    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('no-op if when removing listener if there is still a listener',
      () async {
    final container = createContainer();
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return 42;
    });

    final sub = container.listen(provider, (prev, value) {});
    final sub2 = container.listen(provider, (prev, value) {});

    verifyNoMoreInteractions(onDispose);

    sub.close();
    await container.pump();

    verifyNoMoreInteractions(onDispose);

    sub2.close();
    await container.pump();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);
  });

  test('Do not dispose twice when ProviderContainer is disposed first',
      () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return 42;
    });
    final container = createContainer();

    final sub = container.listen(provider, (_, __) {});
    sub.close();

    container.dispose();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    await container.pump();

    verifyNoMoreInteractions(onDispose);
  });

  test('providers with only a "listen" as subscribers are kept alive',
      () async {
    final container = createContainer();
    var mounted = true;
    final listened = Provider.autoDispose((ref) {
      ref.onDispose(() => mounted = false);
      return 0;
    });
    final provider = Provider.autoDispose((ref) {
      ref.listen(listened, (prev, value) {});
      return 0;
    });

    container.listen(provider, (prev, value) {});
    final sub = container.listen(listened, (prev, value) {});

    sub.close();

    await container.pump();

    expect(mounted, true);
  });
}
