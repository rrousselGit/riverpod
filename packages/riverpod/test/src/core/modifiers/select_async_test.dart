import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../matrix.dart';
import '../../utils.dart';

void main() {
  group('If disposed before a value could be emitted', () {
    test('resolves values with `sub.read()`', () async {
      final container = ProviderContainer.test();
      final controller = StreamController<int>();
      final provider = Provider((ref) => ref);
      addTearDown(controller.close);
      final dep = StreamProvider<int>((ref) => controller.stream);

      container.listen(dep, (p, n) {});
      final ref = container.read(provider);
      final future = ref.watch(dep.selectAsync((data) => data * 2));

      container.invalidate(provider);
      controller.add(21);

      expect(await future, 42);
    });

    test('resolves errors with `sub.read()`', () async {
      final container = ProviderContainer.test();
      final controller = StreamController<int>();
      final provider = Provider((ref) => ref);
      addTearDown(controller.close);
      final dep = StreamProvider<int>((ref) => controller.stream);

      container.listen(dep, (p, n) {});
      final ref = container.read(provider);
      final future = ref.watch(dep.selectAsync((data) => data * 2));

      container.invalidate(provider);
      controller.addError('err');

      await expectLater(future, throwsA('err'));
    });
  });

  test('implements ProviderSubscription.read on AsyncData', () async {
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
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
    final container = ProviderContainer.test();
    final provider = FutureProvider((ref) async => 0);
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener.call,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    expect(await result, true);
  });

  test('handles fireImmediately: true on AsyncData', () async {
    final container = ProviderContainer.test();
    final provider = FutureProvider((ref) => 0);
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener.call,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    expect(await result, true);
  });

  test('handles fireImmediately: true on AsyncError', () async {
    final container = ProviderContainer.test();
    final provider = FutureProvider<int>((ref) => throw StateError('0'));
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener.call,
      fireImmediately: true,
    );

    final result = verify(listener(argThat(isNull), captureAny)).captured.single
        as Future<bool>;
    verifyNoMoreInteractions(listener);
    await expectLater(result, throwsStateError);
  });

  test('handles fireImmediately: false', () async {
    final container = ProviderContainer.test();
    final provider = FutureProvider((ref) async => 0);
    final listener = Listener<Future<bool>>();

    container.listen(
      provider.selectAsync((data) => data.isEven),
      listener.call,
    );

    verifyZeroInteractions(listener);
  });

  test(
      'catching errors in the future is not necessary if the error is coming from AsyncError',
      () async {
    final container = ProviderContainer.test();
    final provider = FutureProvider<int>((ref) => throw StateError('err'));

    container.listen(
      provider.selectAsync((data) => data.isEven),
      (prev, next) {},
      fireImmediately: true,
    );

    // If somehow the future failed, it would be sent to the zone,
    // making the test fail
  });

  test('handles multiple AsyncLoading at once then data', () async {
    final container = ProviderContainer.test();
    final provider = AsyncNotifierProvider<AsyncNotifier<int>, int>(
      () => DeferredAsyncNotifier((ref, self) {
        final completer = Completer<int>();
        ref.onDispose(() => completer.complete(84));

        return completer.future;
      }),
    );

    final sub = container.listen(
      provider.selectAsync((data) => data + 40),
      (prev, next) {},
    );

    expect(sub.read(), completion(42));

    final notifier = container.read(provider.notifier);
    notifier.state = const AsyncLoading<int>()
        .copyWithPrevious(const AsyncValue<int>.data(0));
    notifier.state = const AsyncLoading<int>()
        .copyWithPrevious(const AsyncError<int>('err', StackTrace.empty));
    notifier.state = const AsyncLoading<int>();
    notifier.state = const AsyncData(2);

    // the previous unawaited `completion` should resolve with 2+40
  });

  test('can watch async selectors', () async {
    final container = ProviderContainer.test();
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final a = FutureProvider((ref) async => ref.watch(dep));
    final b = FutureProvider((ref) {
      buildCount++;
      return ref.watch(a.selectAsync((value) => value % 10));
    });

    container.listen(a, (p, n) {});
    container.listen(b, (p, n) {});

    expect(container.read(a), const AsyncLoading<int>());
    expect(container.read(b), const AsyncLoading<int>());
    expect(await container.read(b.future), 0);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 1;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(0), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(0));
    expect(buildCount, 1);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 11;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(1), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 12;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(11), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 2);
    expect(buildCount, 3);
  });

  test('can watch async selectors (autoDispose)', () async {
    final container = ProviderContainer.test();
    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final a = FutureProvider.autoDispose((ref) async => ref.watch(dep));
    final b = FutureProvider.autoDispose((ref) {
      buildCount++;
      return ref.watch(a.selectAsync((value) => value % 10));
    });

    container.listen(a, (p, n) {});
    container.listen(b, (p, n) {});

    expect(container.read(b), const AsyncLoading<int>());
    expect(container.read(b), const AsyncLoading<int>());
    expect(await container.read(b.future), 0);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 1;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(0), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(0));
    expect(buildCount, 1);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 11;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(1), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 1);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 12;
    expect(
      container.read(a),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(11), isRefresh: false),
    );
    expect(container.read(b), const AsyncData(1));
    expect(buildCount, 2);

    await container.read(a.future);
    expect(await container.read(b.future), 2);
    expect(buildCount, 3);
  });

  group('Supports ProviderContainer.read', () {
    test('and resolves with data', () async {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) async => 0);

      container.listen(provider, (p, n) {});

      expect(
        container.read(provider.selectAsync((data) => data.toString())),
        completion('0'),
      );
    });

    test('resolves with error', () async {
      final container = ProviderContainer.test();
      final provider =
          FutureProvider<int>((ref) async => throw StateError('err'));

      container.listen(provider, (p, n) {});

      expect(
        container.read(provider.selectAsync((data) => data)),
        throwsStateError,
      );
    });

    test('emits exceptions inside selectors as Future.error', () async {
      final container = ProviderContainer.test();
      final provider = FutureProvider<int>((ref) async => 42);

      container.listen(provider, (p, n) {});

      expect(
        container.read(provider.selectAsync((data) => throw StateError('err'))),
        throwsStateError,
      );
    });
  });
}
