import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../utils.dart';

Future<void> main() async {
  test(
    'when a provider conditionally depends on another provider, rebuilding without the dependency can dispose the dependency',
    () async {
      final container = ProviderContainer.test();
      var dependencyDisposeCount = 0;
      final dependency = Provider.autoDispose(name: 'dependency', (ref) {
        ref.onDispose(() => dependencyDisposeCount++);
        return 0;
      });
      final isDependingOnDependency = StateProvider(
        name: 'isDependingOnDependency',
        (ref) => true,
      );
      final provider = Provider.autoDispose(name: 'provider', (ref) {
        if (ref.watch(isDependingOnDependency)) {
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
          isDependingOnDependency,
        ]),
      );

      container.read(isDependingOnDependency.notifier).state = false;
      await container.pump();

      expect(dependencyDisposeCount, 1);
      expect(
        container.getAllProviderElements().map((e) => e.provider),
        unorderedEquals(<Object>[provider, isDependingOnDependency]),
      );
    },
  );

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

    final root = ProviderContainer.test();
    final container = ProviderContainer.test(parent: root);

    final sub = container.listen(
      provider,
      listener.call,
      fireImmediately: true,
    );

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

  test(
    'unsub to A then make B sub to A then unsub to B disposes B before A',
    () async {
      final container = ProviderContainer.test();
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

      verifyInOrder([bDispose(), aDispose()]);
      verifyNoMoreInteractions(aDispose);
      verifyNoMoreInteractions(bDispose);
    },
  );

  test('chain', () async {
    final container = ProviderContainer.test();
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
    verifyInOrder([onDispose2(), onDispose()]);
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
    final container = ProviderContainer.test();
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

  test(
    'ProviderContainer was disposed before Scheduler handled the dispose',
    () async {
      final container = ProviderContainer.test();
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
    },
  );

  test('unsub no-op if another sub is added before event-loop', () async {
    final container = ProviderContainer.test();
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

  test(
    'no-op if when removing listener if there is still a listener',
    () async {
      final container = ProviderContainer.test();
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
    },
  );

  test(
    'Do not dispose twice when ProviderContainer is disposed first',
    () async {
      final onDispose = OnDisposeMock();
      final provider = Provider.autoDispose((ref) {
        ref.onDispose(onDispose.call);
        return 42;
      });
      final container = ProviderContainer.test();

      final sub = container.listen(provider, (_, __) {});
      sub.close();

      container.dispose();

      verify(onDispose()).called(1);
      verifyNoMoreInteractions(onDispose);

      await container.pump();

      verifyNoMoreInteractions(onDispose);
    },
  );

  test(
    'providers with only a "listen" as subscribers are kept alive',
    () async {
      final container = ProviderContainer.test();
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
    },
  );
}
