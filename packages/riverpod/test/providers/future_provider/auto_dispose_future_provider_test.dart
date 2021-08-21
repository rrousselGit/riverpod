import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
    final dep = StateProvider((ref) => Future.value(42));
    final provider = FutureProvider.autoDispose((ref) => ref.watch(dep).state);
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, (value) {});

    await expectLater(
      container.read(provider.future),
      completion(42),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(42),
    );

    final completer = Completer<int>();
    container.read(dep).state = completer.future;

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(
      listener,
      listener(const AsyncLoading<int>(previous: AsyncData(42))),
    );

    container.read(dep).state = Future.value(21);

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

  test(
      'when recreating the future, AsyncLoading contains the previous data if any',
      () async {
    final dep = StateProvider((ref) => Future.value(42));
    final provider = FutureProvider.autoDispose((ref) => ref.watch(dep).state);
    final container = createContainer();

    container.listen(provider, (value) {});

    expect(
      container.read(provider),
      const AsyncLoading<int>(),
    );

    await expectLater(
      container.read(provider.future),
      completion(42),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(42),
    );

    container.read(dep).state = Future.value(21);

    expect(
      container.read(provider),
      const AsyncLoading<int>(previous: AsyncData(42)),
    );
  });

  test(
      'when recreating the future, AsyncLoading contains the previous error if any',
      () async {
    final dep = StateProvider((ref) => Future<int>.error(42, StackTrace.empty));
    final provider = FutureProvider.autoDispose((ref) => ref.watch(dep).state);
    final container = createContainer();

    container.listen(provider, (value) {});

    expect(
      container.read(provider),
      const AsyncLoading<int>(),
    );

    await expectLater(
      container.read(provider.future),
      throwsA(42),
    );
    expect(
      container.read(provider),
      const AsyncError<int>(42, StackTrace.empty),
    );

    container.read(dep).state = Future.value(21);

    expect(
      container.read(provider),
      const AsyncLoading<int>(previous: AsyncError<int>(42, StackTrace.empty)),
    );
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = createContainer();
    final provider = FutureProvider.autoDispose((ref) => Future.value(result));

    container.listen(provider, (e) {});

    expect(await container.read(provider.future), 0);
    expect(container.read(provider), const AsyncValue.data(0));

    result = 1;
    expect(
      container.refresh(provider),
      const AsyncValue<int>.loading(previous: AsyncValue.data(0)),
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

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    container.read(dep).state++;
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

    container.listen(provider.future, listener, fireImmediately: true);

    verifyOnly(listener, listener(any));

    container.read(dep).state++;
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
        isA<ProviderElementBase>().having((e) => e.origin, 'origin', provider),
        isA<ProviderElementBase>()
            .having((e) => e.origin, 'origin', provider.future)
      ]);
    });

    test('when using provider.overrideWithValue', () async {
      final provider = FutureProvider.autoDispose((ref) async => 0);
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
      final provider = FutureProvider.autoDispose((ref) async => 0);
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [
        provider.overrideWithProvider(
            FutureProvider.autoDispose((ref) async => 42)),
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

  test('FutureProvider.autoDispose', () async {
    var future = Future.value(42);
    final onDispose = OnDisposeMock();
    final provider = FutureProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return future;
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    final sub = container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    sub.close();
    await container.pump();

    verifyOnly(onDispose, onDispose());

    future = Future.value(21);

    container.listen(provider, listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    await container.pump();

    verifyOnly(listener, listener(const AsyncValue.data(21)));
  });
}
