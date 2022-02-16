import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('implements ProviderSubscription.read on AsyncData', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider((ref) async => ref.watch(dep));

    final sub = container.listen(
      provider.selectAsync((data) => data.isEven),
      (prev, next) {},
    );

    expect(await sub.read(), true);

    container.read(dep.notifier).state += 2;
    await container.read(provider.future);

    expect(await sub.read(), true);

    container.read(dep.notifier).state++;
    await container.read(provider.future);

    expect(await sub.read(), false);
  });

  test('implements ProviderSubscription.read on AsyncError', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider<int>(
      (ref) => Future.error(ref.watch(dep)),
    );

    final sub = container.listen<Future<bool>>(
      provider.selectAsync((data) => data.isEven),
      (prev, next) {
        // workaround to the fact that throwA(2) later in the test
        // will be called _after_ the failing future is reported to the zone,
        // marking the test as failing when the future is in fact caught
        next.ignore();
      },
    );

    await expectLater(sub.read(), throwsA(0));

    container.read(dep.notifier).state += 2;
    // ignore: avoid_types_on_closure_parameters, conflict with implicit_dynamic
    await container.read(provider.future).catchError((Object? _) => 0);

    await expectLater(sub.read(), throwsA(2));
  });

  test('when selector throws, returns a failing future', () async {
    final container = createContainer();
    final dep = StateProvider((ref) => 0);
    final provider = FutureProvider((ref) async => ref.watch(dep));

    final sub = container.listen<Future<Object?>>(
      // ignore: only_throw_errors
      provider.selectAsync((data) => throw data),
      (prev, next) {
        // workaround to the fact that throwA(2) later in the test
        // will be called _after_ the failing future is reported to the zone,
        // marking the test as failing when the future is in fact caught
        next.ignore();
      },
    );
    await expectLater(sub.read(), throwsA(0));

    container.read(dep.notifier).state += 2;
    await container.read(provider.future);

    await expectLater(sub.read(), throwsA(2));
  });

  test('handles fireImmediately: true on AsyncLoading', () async {
    final container = createContainer();
    final provider = FutureProvider((ref) async => 0);
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    expect(await result, true);
  });

  test('handles fireImmediately: true on AsyncData', () async {
    final container = createContainer();
    final provider = Provider((ref) => const AsyncData(0));
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    expect(await result, true);
  });

  test('handles fireImmediately: true on AsyncError', () async {
    final container = createContainer();
    final provider = Provider((ref) => const AsyncError<int>(0));
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    await expectLater(result, throwsA(0));
  });

  test('handles fireImmediately: false', () async {
    final container = createContainer();
    final provider = FutureProvider((ref) async => 0);
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener,
      fireImmediately: false,
    );

    verifyZeroInteractions(listener);
  });

  test(
      'catching errors in the future is not necessary if the error is coming from AsyncError',
      () async {
    final container = createContainer();
    final provider = Provider((ref) => const AsyncError<int>(0));

    container.listen(
      provider.selectAsync((data) => data.isEven),
      (prev, next) {},
      fireImmediately: true,
    );

    // If somehow the future failed, it would be sent to the zone,
    // making the test fail
  });

  test('handles multiple AsyncLoading at once then data', () async {
    final container = createContainer();
    final provider = StateProvider((ref) => const AsyncValue<int>.loading());

    final sub = container.listen(
      provider.selectAsync((data) => data + 40),
      (prev, next) {},
    );

    expect(sub.read(), completion(42));

    container.read(provider.notifier).state = const AsyncLoading<int>()
        .copyWithPrevious(const AsyncValue<int>.data(0));
    container.read(provider.notifier).state = const AsyncLoading<int>()
        .copyWithPrevious(const AsyncError<int>('err'));
    container.read(provider.notifier).state = const AsyncLoading<int>();

    container.read(provider.notifier).state = const AsyncData(2);

    // the previous unawaited `completion` should resolve with 2+40
  });

  test('can watch async selectors', () async {
    final container = createContainer();
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final a = FutureProvider((ref) async => ref.watch(dep));
    final b = FutureProvider((ref) {
      buildCount++;
      return ref.watch(a.selectAsync((value) => value % 10));
    });

    expect(buildCount, 0);
    expect(container.read(b), const AsyncLoading<int>());
    expect(container.read(b), const AsyncLoading<int>());
    expect(await container.read(b.future), 0);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 1;
    expect(
      container.read(a),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(0)),
    );
    expect(container.read(b), const AsyncData(0));
    expect(buildCount, 1);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 11;
    expect(
      container.read(a),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(1)),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);
  });

  test('can watch async selectors (autoDispose)', () async {
    final container = createContainer();
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final a = FutureProvider.autoDispose((ref) async => ref.watch(dep));
    final b = FutureProvider.autoDispose((ref) {
      buildCount++;
      return ref.watch(a.selectAsync((value) => value % 10));
    });

    expect(buildCount, 0);
    expect(container.read(b), const AsyncLoading<int>());
    expect(container.read(b), const AsyncLoading<int>());
    expect(await container.read(b.future), 0);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 1;
    expect(
      container.read(a),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(0)),
    );
    expect(container.read(b), const AsyncData(0));
    expect(buildCount, 1);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 11;
    expect(
      container.read(a),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(1)),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);
  });
}
