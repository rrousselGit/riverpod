import 'package:expect_error/expect_error.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

Future<void> main() async {
  final library = await Library.parseFromStacktrace();

  group(
      'emits compilation error when passing an autoDispose provider to a non-autoDispose provider',
      () {
    test('to ref.watch', () {
      expect(library.withCode('''
import 'package:riverpod/riverpod.dart';

final autoDispose = Provider.autoDispose<int>((ref) => 0);

final alwaysAlive = Provider((ref) {
  // expect-error: ARGUMENT_TYPE_NOT_ASSIGNABLE
  ref.watch(autoDispose);
});
'''), compiles);
    });

    test('to ref.watch when using selectors', () {
      expect(library.withCode('''
import 'package:riverpod/riverpod.dart';

final autoDispose = Provider.autoDispose<int>((ref) => 0);

final alwaysAlive = Provider((ref) {
  ref.watch(
    // expect-error: ARGUMENT_TYPE_NOT_ASSIGNABLE
    autoDispose
      .select((value) => value),
  );
});
'''), compiles);
    });

    test('to ref.read when using selectors', () {
      expect(library.withCode('''
import 'package:riverpod/riverpod.dart';

final autoDispose = Provider.autoDispose<int>((ref) => 0);

final alwaysAlive = Provider((ref) {
  ref.read(
    // expect-error: ARGUMENT_TYPE_NOT_ASSIGNABLE
    autoDispose
      .select((value) => value),
  );
});
'''), compiles);
    });

    test('to ref.listen', () {
      expect(library.withCode('''
import 'package:riverpod/riverpod.dart';

final autoDispose = Provider.autoDispose<int>((ref) => 0);

final alwaysAlive = Provider((ref) {
  ref.listen<int>(
    // expect-error: ARGUMENT_TYPE_NOT_ASSIGNABLE
    autoDispose,
    (prev, value) {},
  );
});
'''), compiles);
    });

    test('to ref.listen when using selectors', () {
      expect(library.withCode('''
import 'package:riverpod/riverpod.dart';

final autoDispose = Provider.autoDispose<int>((ref) => 0);

final alwaysAlive = Provider((ref) {
  ref.listen<int>(
    // expect-error: ARGUMENT_TYPE_NOT_ASSIGNABLE
    autoDispose
      .select((value) => value),
    (prev, value) {},
  );
});
'''), compiles);
    });
  });

  test(
      'when a provider conditionally depends on another provider, rebuilding without the dependency can dispose the dependency',
      () async {
    final container = createContainer();
    var dependencyDisposeCount = 0;
    final dependency = Provider.autoDispose((ref) {
      ref.onDispose(() => dependencyDisposeCount++);
      return 0;
    });
    final isDependendingOnDependency = StateProvider(
      (ref) => true,
      name: 'foo',
    );
    final provider = Provider.autoDispose((ref) {
      ref.maintainState = true;
      if (ref.watch(isDependendingOnDependency.state).state) {
        ref.watch(dependency);
      }
    });

    container.listen<void>(provider, (_, __) {});

    expect(dependencyDisposeCount, 0);
    expect(
      container.getAllProviderElements().map((e) => e.provider),
      unorderedEquals(<Object>[
        dependency,
        provider,
        isDependendingOnDependency.state,
        isDependendingOnDependency.notifier,
      ]),
    );

    container.read(isDependendingOnDependency.state).state = false;
    await container.pump();

    expect(dependencyDisposeCount, 1);
    expect(
      container.getAllProviderElements().map((e) => e.provider),
      unorderedEquals(<Object>[
        provider,
        isDependendingOnDependency.state,
        isDependendingOnDependency.notifier,
      ]),
    );
  });

  test('works if used accross a ProviderContainer', () async {
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

    final sub = container.listen(provider, listener, fireImmediately: true);

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
    container.listen(provider, listener, fireImmediately: true);

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

  test('setting maintainState to false destroys the state when not listened',
      () async {
    final onDispose = OnDisposeMock();
    late AutoDisposeRef ref;
    final provider = Provider.autoDispose((_ref) {
      ref = _ref;
      ref.onDispose(onDispose);
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

  test("maintainState to true don't dispose the state when no-longer listened",
      () async {
    var value = 42;
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose((ref) {
      ref.onDispose(onDispose);
      ref.maintainState = true;
      return value;
    });
    final container = createContainer();
    final listener = Listener<int>();

    final sub = container.listen(provider, listener, fireImmediately: true);
    verify(listener(null, 42)).called(1);
    verifyNoMoreInteractions(listener);
    sub.close();

    await container.pump();

    verifyZeroInteractions(onDispose);

    value = 21;
    container.listen(provider, listener, fireImmediately: true);

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
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose);
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
      ref.onDispose(onDispose);
      return value;
    });
    final onDispose2 = OnDisposeMock();
    final provider2 = Provider.autoDispose((ref) {
      ref.onDispose(onDispose2);
      return ref.watch(provider);
    });
    final listener = Listener<int>();

    var sub = container.listen(provider2, listener, fireImmediately: true);

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
    sub = container.listen(provider2, listener, fireImmediately: true);

    verify(listener(null, 21)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });

  test("auto dispose A then auto dispose B doesn't dispose A again", () async {
    final container = createContainer();
    final aDispose = OnDisposeMock();
    final a = Provider.autoDispose((ref) {
      ref.onDispose(aDispose);
      return 42;
    });
    final bDispose = OnDisposeMock();
    final b = Provider.autoDispose((ref) {
      ref.onDispose(bDispose);
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
      ref.onDispose(onDispose);
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
      ref.onDispose(onDispose);
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
      ref.onDispose(onDispose);
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
      ref.onDispose(onDispose);
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
