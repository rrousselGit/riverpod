import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('can read and set current AsyncValue', () {
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    late AutoDisposeFutureProviderRef<int> ref;
    final provider = FutureProvider.autoDispose<int>((r) {
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
    final provider = FutureProvider.autoDispose(
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
    final provider = FutureProvider.autoDispose((ref) => 0);
    final container = createContainer();

    container.listen(provider, (_, __) {});

    expect(container.read(provider), const AsyncData(0));
    await expectLater(container.read(provider.future), completion(0));
  });

  test('can return an error synchronously, bypassing AsyncLoading', () async {
    final provider =
        FutureProvider.autoDispose((ref) => throw UnimplementedError());
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

  test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
    final dep = StateProvider((ref) => Future.value(42));
    final provider = FutureProvider.autoDispose((ref) => ref.watch(dep));
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, (prev, value) {});

    await expectLater(
      container.read(provider.future),
      completion(42),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(42),
    );

    final completer = Completer<int>();
    container.read(dep.notifier).state = completer.future;

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(
      listener,
      listener(
        null,
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false),
      ),
    );

    container.read(dep.notifier).state = Future.value(21);

    verifyNoMoreInteractions(listener);

    await expectLater(
      container.read(provider.future),
      completion(21),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(21),
    );
  });

  test('can refresh .future', () async {
    var future = Future.value(1);
    final provider = FutureProvider.autoDispose((ref) => future);
    final container = createContainer();

    container.listen(provider.future, (prev, value) {});

    expect(await container.read(provider.future), 1);

    future = Future.value(42);

    expect(await container.refresh(provider.future), 42);
    expect(container.read(provider), const AsyncData(42));
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = FutureProvider.autoDispose((ref) => Future.value(result));

    container.listen(provider, (prev, value) {});

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
    final provider = FutureProvider.autoDispose((ref) {
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
      '.stream does not update dependents if the created stream did not change',
      () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final completer = Completer<int>();
    final provider = FutureProvider.autoDispose((ref) {
      ref.watch(dep);
      return completer.future;
    });
    final listener = Listener<Future<int>>();

    container.listen(provider.future, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(any, any));

    container.read(dep.notifier).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);

    // No value were emitted, so the future will fail. Catching the error to
    // avoid false positive.
    // ignore: unawaited_futures, avoid_types_on_closure_parameters
    container.read(provider.future).catchError((Object _) => 0);
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = FutureProvider.autoDispose((ref) async => 0);
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
    //   final provider = FutureProvider.autoDispose((ref) async => 0);
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
      final provider = FutureProvider.autoDispose((ref) async => 0);
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider
              // ignore: deprecated_member_use_from_same_package
              .overrideWithProvider(FutureProvider.autoDispose((ref) => 42)),
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

  test('FutureProvider.autoDispose', () async {
    var future = Future.value(42);
    final onDispose = OnDisposeMock();
    final provider = FutureProvider.autoDispose((ref) {
      ref.onDispose(onDispose.call);
      return future;
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    final sub =
        container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    sub.close();
    await container.pump();

    verifyOnly(onDispose, onDispose());

    future = Future.value(21);

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    await container.pump();

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue.data(21)),
    );
  });
}
