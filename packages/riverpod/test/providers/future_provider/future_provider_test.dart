import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can read and set current AsyncValue', () {
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    late FutureProviderRef<int> ref;
    final provider = FutureProvider<int>((r) {
      ref = r;
      return 0;
    });

    container.listen(provider, listener);

    expect(ref.state, const AsyncData(0));
    verifyZeroInteractions(listener);

    ref.state = const AsyncLoading<int>();

    expect(
      ref.state,
      const AsyncData<int>(0, isRefreshing: true),
    );

    verifyOnly(
      listener,
      listener(
        const AsyncData(0),
        const AsyncData<int>(0, isRefreshing: true),
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
      isA<AsyncError>().having((e) => e.error, 'error', isUnimplementedError),
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

  test('can refresh .stream', () async {
    var future = Future.value(1);
    final provider = FutureProvider((ref) => future);
    final container = createContainer();

    expect(await container.read(provider.stream).first, 1);

    future = Future.value(42);

    expect(await container.refresh(provider.stream).first, 42);
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
      const AsyncValue<int>.data(0, isRefreshing: true),
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

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    container.read(dep.state).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  test(
      '.stream does not update dependents if the created stream did not change',
      () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final completer = Completer<int>();
    final provider = FutureProvider((ref) {
      ref.watch(dep);
      return completer.future;
    });
    final listener = Listener<Future<int>>();

    container.listen(provider.future, listener, fireImmediately: true);

    verifyOnly(listener, listener(any, any));

    container.read(dep.state).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);

    // No value were emitted, so the future will fail. Catching the error to
    // avoid false positive.
    // ignore: unawaited_futures, avoid_types_on_closure_parameters
    container.read(provider.future).catchError((Object _) => 0);
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
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });

    test('when using provider.overrideWithValue', () async {
      final provider = FutureProvider((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });

    test('when using provider.overrideWithProvider', () async {
      final provider = FutureProvider((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(FutureProvider((ref) async => 42)),
      ]);

      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElementsInOrder(), isEmpty);
      expect(container.getAllProviderElementsInOrder(), [
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });
  });

  test(
      'when overridden with an error but provider.future is not listened, it should not emit an error to the zone',
      () async {
    final error = Error();
    final future = FutureProvider<int>((ref) async => 0);

    final container = createContainer(overrides: [
      future.overrideWithValue(AsyncValue.error(error)),
    ]);
    addTearDown(container.dispose);

    expect(
      container.read(future),
      AsyncValue<int>.error(error),
    );

    // the test will naturally fail if a non-caught future is created
  });

  test('throwing inside "create" result in an AsyncValue.error', () {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((ref) => throw 42);
    final container = createContainer();

    expect(
      container.read(provider),
      isA<AsyncError>().having((s) => s.error, 'error', 42),
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
      isA<AsyncValue>().having(
        (s) => s.maybeWhen(
          error: (err, _) => err,
          orElse: () => null,
        ),
        'error',
        42,
      ),
    );
  });

  test('noop if fails after dispose', () async {
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

    expect(provider, isA<AlwaysAliveProviderBase>());
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
      final provider =
          FutureProvider<int>((ref) => ref.watch(futureProvider.state).state);
      var callCount = 0;
      final dependent = Provider<Future<int>>((ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = createContainer();
      final futureController = container.read(futureProvider.state);

      await expectLater(container.read(dependent), completion(42));
      expect(callCount, 1);

      futureController.state = Future.value(21);

      await expectLater(container.read(dependent), completion(21));
      expect(callCount, 2);
    });

    test('.name is the listened name.future', () {
      expect(
        FutureProvider((ref) async {}, name: 'hey').future.name,
        'hey.future',
      );
      expect(
        FutureProvider((ref) async {}).future.name,
        null,
      );
    });
  });

  group('FutureProvider.autoDispose().future', () {
    test('.name is the listened name.future', () {
      expect(
        FutureProvider.autoDispose((ref) async {}, name: 'hey').future.name,
        'hey.future',
      );
      expect(
        FutureProvider.autoDispose((ref) async {}).future.name,
        null,
      );
    });

    test('update dependents when the future changes', () async {
      final futureProvider = StateProvider((ref) => Future.value(42));
      // a FutureProvider that can rebuild with a new future
      final provider = FutureProvider.autoDispose(
          (ref) => ref.watch(futureProvider.state).state);
      var callCount = 0;
      final dependent = Provider.autoDispose((ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = createContainer();
      final futureController = container.read(futureProvider.state);

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

    test('disposes the main provider when no-longer used', () async {
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

    container.listen(example, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue<String>.loading()));
    completer.complete(42);

    verifyNoMoreInteractions(listener);

    await container.pump();

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

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    completer.complete(42);

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue.data(42)),
    );

    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  group('mock as value', () {
    test('value immediately then other value', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), const AsyncValue.data(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(21),
      );
      expect(sub.read(), const AsyncValue.data(21));
    });

    test('value immediately then error', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), const AsyncValue.data(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.error(21)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(21),
      );
      expect(sub.read(), const AsyncValue<int>.error(21));
    });

    test('value immediately then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      final future = container.read(provider.future);

      await expectLater(
        future,
        completion(42),
      );

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), const AsyncValue<int>.data(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(container.read(provider.future), isNot(future));
      expect(sub.read(), const AsyncData<int>(42, isRefreshing: true));
    });

    test('loading immediately then value', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      final future = container.read(provider.future);

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), const AsyncValue<int>.loading());

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(sub.read(), const AsyncValue<int>.data(42));

      await expectLater(future, completion(42));
    });

    test('loading immediately then error', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      final future = container.read(provider.future);

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), const AsyncValue<int>.loading());

      final stackTrace = StackTrace.current;

      container.updateOverrides([
        provider
            .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
      ]);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

      await expectLater(future, throwsA(42));
    });

    test('loading immediately then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = Listener<AsyncValue<int>>();

      final future = container.read(provider.future);

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      verifyNoMoreInteractions(listener);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(42)),
      );
      await expectLater(future, completion(42));
    });

    test('error immediately then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider
            .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

      container.updateOverrides([
        provider
            .overrideWithValue(AsyncValue.error(21, stackTrace: stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(21),
      );
      expect(sub.read(), AsyncValue<int>.error(21, stackTrace: stackTrace));
    });

    test('error immediately then different stacktrace', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider
            .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
      ]);

      final future = container.read(provider.future);

      await expectLater(future, throwsA(42));

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

      final stack2 = StackTrace.current;

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(42, stackTrace: stack2)),
      ]);

      expect(
        container.read(provider.future),
        isNot(future),
      );
      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );
      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stack2));
    });

    test('error immediately then data', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider
            .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );
      expect(sub.read(), const AsyncValue<int>.data(42));
    });

    test('error immediately then loading', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = createContainer(overrides: [
        provider
            .overrideWithValue(AsyncValue.error(42, stackTrace: stackTrace)),
      ]);

      final future = container.read(provider.future);
      await expectLater(future, throwsA(42));

      final sub = container.listen(provider, (_, __) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(container.read(provider.future), isNot(future));
      expect(
        sub.read(),
        AsyncValue<int>.error(42, stackTrace: stackTrace, isRefreshing: true),
      );
    });
  });
}
