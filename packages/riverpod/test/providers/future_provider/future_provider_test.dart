// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('FutureProviderRef.future', () {
    test(
        '.future does not immediately notify listeners when adding a new listener '
        'to .future flushes the provider', () async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2041

      final container = createContainer();
      final onFuture = Listener<Future<int>>();

      final dep = FutureProvider((ref) => 0);
      final provider = Provider(
        (ref) {
          ref.listen(dep.future, onFuture.call);
          return 0;
        },
      );

      container.read(dep);
      container.invalidate(dep);

      container.read(provider);

      verifyZeroInteractions(onFuture);
    });

    test('Regression 2041', () async {
      final container = createContainer();
      final onFuture = Listener<Future<int>>();

      final testNotifierProvider = FutureProvider.autoDispose<int>((ref) => 0);
      // ProxyProvider is never rebuild directly, but rather indirectly through
      // testNotifierProvider. This means the scheduler does not naturally cover it.
      // Then testProvider is the one to trigger the rebuild by listening to it.
      final proxyProvider = FutureProvider.autoDispose<int>(
        (ref) => ref.watch(testNotifierProvider.future),
      );

      var buildCount = 0;
      final testProvider = FutureProvider.autoDispose<int>(
        (ref) async {
          buildCount++;
          return (await ref.watch(proxyProvider.future)) + 2;
        },
      );

      container.listen<AsyncValue<void>>(
        testProvider,
        (previous, next) {
          if (!next.isLoading && next is AsyncError) {
            Zone.current.handleUncaughtError(next.error, next.stackTrace);
          }
        },
        fireImmediately: true,
      );

      container.invalidate(testNotifierProvider);
      container.invalidate(testProvider);

      verifyZeroInteractions(onFuture);
      expect(buildCount, 1);

      await container.pump();
      verifyZeroInteractions(onFuture);

      expect(buildCount, 2);
    });

    test('returns the pending future', () async {
      final container = createContainer();
      Future<int>? future;
      int? value;
      final provider = FutureProvider<int>((ref) {
        future = ref.future;
        if (value == null) return ref.future;
        return value;
      });

      container.read(provider);

      expect(
        future,
        same(container.read(provider.future)),
      );
      expect(future, completion(42));

      value = 42;
      container.refresh(provider);

      expect(
        future,
        same(container.read(provider.future)),
      );
      expect(future, completion(42));
    });

    test('flushes the provider when reading ref.future', () async {
      final container = createContainer();
      var result = Future.value(42);
      late FutureProviderRef<int> ref;
      final provider = FutureProvider<int>((r) {
        ref = r;
        return result;
      });

      container.read(provider);

      await expectLater(ref.future, completion(42));

      result = Future.value(21);
      container.invalidate(provider);

      expect(ref.future, completion(21));
    });
  });

  test('Supports void type', () async {
    // Regression test for https://github.com/rrousselGit/riverpod/issues/2028
    final testProvider = FutureProvider<void>((ref) async {
      return Future.value();
    });

    final container = createContainer();
    expect(container.read(testProvider), const AsyncLoading<void>());

    await container.read(testProvider.future);

    expect(container.read(testProvider), const AsyncData<void>(null));
  });

  test('supports overrideWith', () {
    final provider = FutureProvider<int>((ref) => 0);
    final autoDispose = FutureProvider.autoDispose<int>((ref) => 0);
    final container = createContainer(
      overrides: [
        provider.overrideWith((FutureProviderRef<int> ref) => 42),
        autoDispose.overrideWith(
          (AutoDisposeFutureProviderRef<int> ref) => 84,
        ),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('Does not skip return value if ref.state was set', () async {
    final provider = FutureProvider<int>((ref) async {
      await Future<void>.value();
      ref.state = const AsyncData(1);
      await Future<void>.value();
      ref.state = const AsyncData(2);
      await Future<void>.value();
      return 3;
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    // Completer used for the sole purpose of being able to await `provider.future`
    // Since `provider` emits `AsyncData` before the future completes, then
    // `provider.future` completes early.
    // As such, awaiting `provider.future` isn't enough to fully await the FutureProvider
    final completer = Completer<void>();

    container.listen<AsyncValue<int>>(
      provider,
      (prev, next) {
        if (next.value == 3) {
          completer.complete();
        }
        listener(prev, next);
      },
      fireImmediately: true,
    );

    await completer.future;

    verifyInOrder([
      listener(null, const AsyncLoading<int>()),
      listener(const AsyncLoading<int>(), const AsyncData(1)),
      listener(const AsyncData(1), const AsyncData(2)),
      listener(const AsyncData(2), const AsyncData(3)),
    ]);
  });

  test('supports family overrideWith', () {
    final family = FutureProvider.family<String, int>((ref, arg) => '0 $arg');
    final autoDisposeFamily = FutureProvider.autoDispose.family<String, int>(
      (ref, arg) => '0 $arg',
    );
    final container = createContainer(
      overrides: [
        family.overrideWith(
          (FutureProviderRef<String> ref, int arg) => '42 $arg',
        ),
        autoDisposeFamily.overrideWith(
          (AutoDisposeFutureProviderRef<String> ref, int arg) => '84 $arg',
        ),
      ],
    );

    expect(container.read(family(10)).value, '42 10');
    expect(container.read(autoDisposeFamily(10)).value, '84 10');
  });

  test('Emits AsyncLoading before the create function is executed', () async {
    final container = createContainer();
    late AsyncValue<int> state;
    final provider = FutureProvider<int>((ref) {
      state = ref.state;
      return 0;
    });

    container.read(provider);

    expect(state, const AsyncLoading<int>());

    await container.read(provider.future);
    container.refresh(provider);

    expect(
      state,
      const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(0)),
    );
  });

  test('On dispose, .future resolves with the future returned itself',
      () async {
    final container = createContainer();
    final completer1 = Completer<int>.sync();
    final completer2 = Completer<int>.sync();
    var result = completer1.future;
    final provider = FutureProvider((ref) => result);

    expect(
      container.read(provider.future),
      completion(42),
    );

    result = completer2.future;
    container.refresh(provider);

    container.dispose();

    completer2.complete(42);
  });

  group('When going back to AsyncLoading', () {
    test(
        'provider.future resolves with the new data instead of the old future result',
        () async {
      final container = createContainer();
      final completer1 = Completer<int>.sync();
      final completer2 = Completer<int>.sync();
      var result = completer1.future;
      final provider = FutureProvider((ref) => result);

      expect(
        container.read(provider.future),
        completion(42),
      );

      result = completer2.future;
      container.refresh(provider);

      completer1.complete(21);

      expect(container.read(provider), const AsyncLoading<int>());

      completer2.complete(42);

      await expectLater(container.read(provider.future), completion(42));
    });

    test(
        'sets isRefreshing to true if triggered by a ref.invalidate/ref.refresh',
        () async {
      final container = createContainer();
      var count = 0;
      final provider = FutureProvider((ref) => Future.value(count++));

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      expect(
        container.refresh(provider),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(0)),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));

      container.invalidate(provider);

      expect(
        container.read(provider),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(1)),
      );
      await expectLater(container.read(provider.future), completion(2));
      expect(container.read(provider), const AsyncData(2));
    });

    test('does not set isRefreshing if triggered by a dependency change',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = FutureProvider((ref) => Future.value(ref.watch(dep)));

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      container.read(dep.notifier).state++;
      expect(
        container.read(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));
    });

    test(
        'does not set isRefreshing if both triggered by a dependency change and ref.refresh',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = FutureProvider((ref) => Future.value(ref.watch(dep)));

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      container.read(dep.notifier).state++;
      expect(
        container.refresh(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));
    });
  });

  test('can read and set current AsyncValue', () {
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    late FutureProviderRef<int> ref;
    final provider = FutureProvider<int>((r) {
      ref = r;
      return 0;
    });

    container.listen(provider, listener.call);

    expect(ref.state, const AsyncData(0));
    verifyZeroInteractions(listener);

    ref.state = const AsyncLoading<int>();

    expect(
      ref.state,
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(0), isRefresh: false),
    );

    verifyOnly(
      listener,
      listener(
        const AsyncData(0),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      ),
    );
  });

  test('can be auto-scoped', () async {
    final dep = Provider((ref) => 0);
    final provider = FutureProvider(
      (ref) => ref.watch(dep),
      dependencies: [dep],
    );
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    expect(container.read(provider), const AsyncData(42));
    expect(container.read(provider.future), completion(42));

    expect(root.getAllProviderElements(), isEmpty);
  });

  test('can return a value synchronously, bypassing AsyncLoading', () async {
    final provider = FutureProvider((ref) => 0);
    final container = createContainer();

    expect(container.read(provider), const AsyncData(0));
    await expectLater(container.read(provider.future), completion(0));
  });

  test('can return an error synchronously, bypassing AsyncLoading', () async {
    final provider = FutureProvider((ref) => throw UnimplementedError());
    final container = createContainer();

    expect(
      container.read(provider),
      isA<AsyncError<Never>>()
          .having((e) => e.error, 'error', isUnimplementedError),
    );
    await expectLater(
      container.read(provider.future),
      throwsUnimplementedError,
    );
  });

  test('can refresh .future', () async {
    var future = Future.value(1);
    final provider = FutureProvider((ref) => future);
    final container = createContainer();

    expect(await container.read(provider.future), 1);

    future = Future.value(42);

    expect(await container.refresh(provider.future), 42);
    expect(container.read(provider), const AsyncData(42));
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = FutureProvider((ref) => Future.value(result));

    expect(await container.read(provider.future), 0);
    expect(container.read(provider), const AsyncValue.data(0));

    result = 1;
    expect(
      container.refresh(provider),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(0)),
    );

    expect(await container.read(provider.future), 1);
    expect(container.read(provider), const AsyncValue.data(1));
  });

  test('does not update dependents if the created stream did not change',
      () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final completer = Completer<int>();
    final provider = FutureProvider((ref) {
      ref.watch(dep);
      return completer.future;
    });
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    container.read(dep.notifier).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  test(
      '.future does not update dependents if the created future did not change',
      () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final completer = Completer<int>();
    final provider = FutureProvider((ref) {
      ref.watch(dep);
      return completer.future;
    });
    final listener = Listener<Future<int>>();

    container.listen(provider.future, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(any, any));

    container.read(dep.notifier).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase<Object?>>()
            .having((e) => e.origin, 'origin', provider),
      ]);
    });

    // test('when using provider.overrideWithValue', () async {
    //   final provider = FutureProvider((ref) async => 0);
    //   final root = createContainer();
    //   final container = createContainer(parent: root, overrides: [
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   expect(await container.read(provider.future), 42);
    //   expect(container.read(provider), const AsyncValue.data(42));
    //   expect(root.getAllProviderElementsInOrder(), isEmpty);
    //   expect(container.getAllProviderElementsInOrder(), [
    //     isA<ProviderElementBase<Object?>>().having((e) => e.origin, 'origin', provider),
    //     isA<ProviderElementBase<Object?>>()
    //         .having((e) => e.origin, 'origin', provider.future)
    //   ]);
    // });

    test('when using provider.overrideWithProvider', () async {
      final provider = FutureProvider((ref) async => 0);
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          // ignore: deprecated_member_use_from_same_package
          provider.overrideWithProvider(FutureProvider((ref) async => 42)),
        ],
      );

      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase<Object?>>()
            .having((e) => e.origin, 'origin', provider),
      ]);
    });
  });

  // test(
  //     'when overridden with an error but provider.future is not listened to, it should not emit an error to the zone',
  //     () async {
  //   final error = Error();
  //   final future = FutureProvider<int>((ref) async => 0);

  //   final container = createContainer(overrides: [
  //     future.overrideWithValue(AsyncValue.error(error)),
  //   ]);
  //   addTearDown(container.dispose);

  //   expect(
  //     container.read(future),
  //     AsyncValue<int>.error(error),
  //   );

  //   // the test will naturally fail if a non-caught future is created
  // });

  test('throwing inside "create" result in an AsyncValue.error', () {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((ref) => throw 42);
    final container = createContainer();

    expect(
      container.read(provider),
      isA<AsyncError<int>>().having((s) => s.error, 'error', 42),
    );
  });

  test('can specify name', () {
    final provider = FutureProvider(
      (_) async => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = FutureProvider((_) async => 0);

    expect(provider2.name, isNull);
  });

  test('handle errors', () async {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((_) async => throw 42);
    final container = createContainer();

    expect(container.read(provider), const AsyncValue<int>.loading());

    await container.pump();

    expect(
      container.read(provider),
      isA<AsyncValue<int>>().having(
        (s) => s.maybeWhen(
          error: (err, _) => err,
          orElse: () => null,
        ),
        'error',
        42,
      ),
    );
  });

  test('noop if fails after provider dispose', () async {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((_) async => throw 42);
    final container = createContainer();

    expect(container.read(provider), const AsyncValue<int>.loading());

    container.dispose();
    await container.pump();

    // No errors are reported to the zone
  });

  test('is AlwaysAliveProviderBase', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProviderBase<AsyncValue<int>>>());
  });

  group('FutureProvider().future', () {
    test('does not update dependents when the future completes', () async {
      final completer = Completer<int>.sync();
      final provider = FutureProvider((_) => completer.future);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider<Future<int>>((ref) {
        callCount++;
        return ref.watch(provider.future);
      });

      final sub = container.listen(dependent, (_, __) {});

      final future = sub.read();
      expect(callCount, 1);

      completer.complete(42);
      // just making sure the dependent isn't updated asynchronously
      await completer.future;
      await container.pump();

      expect(sub.read(), future);
      await expectLater(future, completion(42));
      expect(callCount, 1);
    });

    test('update dependents when the future changes', () async {
      final futureProvider = StateProvider((ref) => Future.value(42));
      // a FutureProvider that can rebuild with a new future
      final provider = FutureProvider<int>((ref) => ref.watch(futureProvider));
      var callCount = 0;
      final dependent = Provider<Future<int>>((ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = createContainer();
      final futureController = container.read(futureProvider.notifier);

      await expectLater(container.read(dependent), completion(42));
      expect(callCount, 1);

      futureController.state = Future.value(21);

      await expectLater(container.read(dependent), completion(21));
      expect(callCount, 2);
    });
  });

  group('FutureProvider.autoDispose().future', () {
    test('update dependents when the future changes', () async {
      final futureProvider = StateProvider(
        (ref) => Future.value(42),
        name: 'futureProvider',
      );
      // a FutureProvider that can rebuild with a new future
      final provider = FutureProvider.autoDispose(
        name: 'provider',
        (ref) => ref.watch(futureProvider),
      );
      var callCount = 0;
      final dependent = Provider.autoDispose(name: 'dependent', (ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = createContainer();

      final futureController = container.read(futureProvider.notifier);

      final sub = container.listen(dependent, (_, __) {});

      await expectLater(sub.read(), completion(42));
      expect(callCount, 1);

      futureController.state = Future.value(21);

      await expectLater(sub.read(), completion(21));
      expect(callCount, 2);
    });

    test('does not update dependents when the future completes', () async {
      final completer = Completer<int>.sync();
      final provider = FutureProvider.autoDispose((_) => completer.future);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider.autoDispose((ref) {
        callCount++;
        return ref.watch(provider.future);
      });

      final sub = container.listen(dependent, (_, __) {});

      final future = sub.read();
      expect(callCount, 1);

      completer.complete(42);
      // just making sure the dependent isn't updated asynchronously
      await completer.future;
      await container.pump();

      expect(sub.read(), future);
      await expectLater(future, completion(42));
      expect(callCount, 1);
    });

    test('disposes the main provider when no longer used', () async {
      var didDispose = false;
      final provider = FutureProvider.autoDispose((ref) {
        ref.onDispose(() => didDispose = true);
        return Future.value(42);
      });
      final container = createContainer();
      final sub = container.listen(provider.future, (_, __) {});

      expect(didDispose, false);

      await container.pump();
      expect(didDispose, false);

      sub.close();

      await container.pump();
      expect(didDispose, true);
    });
  });

  test('read', () async {
    final container = createContainer();
    final completer = Completer<int>.sync();
    final other = FutureProvider((_) => completer.future);
    final simple = Provider((_) => 21);

    final example = FutureProvider((ref) async {
      final otherValue = await ref.watch(other.future);

      return '${ref.watch(simple)} $otherValue';
    });

    final listener = Listener<AsyncValue<String>>();

    container.listen(example, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue<String>.loading()));
    completer.complete(42);

    await container.read(example.future);

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue.data('21 42')),
    );
  });

  test('exposes data', () async {
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    completer.complete(42);

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue.data(42)),
    );

    await container.read(provider.future);

    verifyNoMoreInteractions(listener);
  });

  // group('mock as value', () {
  //   test('value immediately then other value', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       completion(42),
  //     );

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), const AsyncValue.data(42));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.data(21)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       completion(21),
  //     );
  //     expect(sub.read(), const AsyncValue.data(21));
  //   });

  //   test('value immediately then error', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       completion(42),
  //     );

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), const AsyncValue.data(42));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.error(21)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       throwsA(21),
  //     );
  //     expect(
  //       sub.read(),
  //       const AsyncValue<int>.error(21).copyWithPrevious(const AsyncData(42)),
  //     );
  //   });

  //   test('value immediately then loading', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     final future = container.read(provider.future);

  //     await expectLater(
  //       future,
  //       completion(42),
  //     );

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), const AsyncValue<int>.data(42));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);

  //     expect(container.read(provider.future), isNot(future));
  //     expect(
  //       sub.read(),
  //       const AsyncLoading<int>()
  //           .copyWithPrevious(const AsyncValue<int>.data(42)),
  //     );
  //   });

  //   test('loading immediately then value', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);

  //     final future = container.read(provider.future);

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), const AsyncValue<int>.loading());

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     expect(sub.read(), const AsyncValue<int>.data(42));

  //     await expectLater(future, completion(42));
  //   });

  //   test('loading immediately then error', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);

  //     final future = container.read(provider.future);

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), const AsyncValue<int>.loading());

  //     final stackTrace = StackTrace.current;

  //     container.updateOverrides([
  //       provider
  //           .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
  //     ]);

  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

  //     await expectLater(future, throwsA(42));
  //   });

  //   test('loading immediately then loading', () async {
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);
  //     final listener = Listener<AsyncValue<int>>();

  //     final future = container.read(provider.future);

  //     container.listen(provider, listener, fireImmediately: true);

  //     verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);

  //     verifyNoMoreInteractions(listener);

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     verifyOnly(
  //       listener,
  //       listener(const AsyncValue.loading(), const AsyncValue.data(42)),
  //     );
  //     await expectLater(future, completion(42));
  //   });

  //   test('error immediately then different error', () async {
  //     final stackTrace = StackTrace.current;
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider
  //           .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       throwsA(42),
  //     );

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

  //     container.updateOverrides([
  //       provider
  //           .overrideWithValue(AsyncValue.error(21, stackTrace: stackTrace)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       throwsA(21),
  //     );
  //     expect(sub.read(), AsyncValue<int>.error(21, stackTrace: stackTrace));
  //   });

  //   test('error immediately then different stacktrace', () async {
  //     final stackTrace = StackTrace.current;
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider
  //           .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
  //     ]);

  //     final future = container.read(provider.future);

  //     await expectLater(future, throwsA(42));

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

  //     final stack2 = StackTrace.current;

  //     container.updateOverrides([
  //       provider.overrideWithValue(AsyncValue.error(42, stackTrace: stack2)),
  //     ]);

  //     expect(
  //       container.read(provider.future),
  //       isNot(future),
  //     );
  //     await expectLater(
  //       container.read(provider.future),
  //       throwsA(42),
  //     );
  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stack2));
  //   });

  //   test('error immediately then data', () async {
  //     final stackTrace = StackTrace.current;
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider
  //           .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       throwsA(42),
  //     );

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.data(42)),
  //     ]);

  //     await expectLater(
  //       container.read(provider.future),
  //       completion(42),
  //     );
  //     expect(
  //       sub.read(),
  //       const AsyncValue<int>.data(42)
  //           .copyWithPrevious(AsyncError(42, stackTrace: stackTrace)),
  //     );
  //   });

  //   test('error immediately then loading', () async {
  //     final stackTrace = StackTrace.current;
  //     final provider = FutureProvider((_) async => 0);
  //     final container = createContainer(overrides: [
  //       provider
  //           .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
  //     ]);

  //     final future = container.read(provider.future);
  //     await expectLater(future, throwsA(42));

  //     final sub = container.listen(provider, (_, __) {});

  //     expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

  //     container.updateOverrides([
  //       provider.overrideWithValue(const AsyncValue.loading()),
  //     ]);

  //     expect(container.read(provider.future), isNot(future));
  //     expect(
  //       sub.read(),
  //       const AsyncLoading<int>()
  //           .copyWithPrevious(AsyncError<int>(42, stackTrace: stackTrace)),
  //     );
  //   });
  // });
}
