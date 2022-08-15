import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart' hide ErrorListener;
import 'package:riverpod/src/async_notifier.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../utils.dart';
import 'factory.dart';

void main() {
  for (final factory in matrix()) {
    group(factory.label, () {
      group('supports refresh transition', () {
        test(
            'sets isRefreshing to true if triggered by a ref.invalidate/ref.refresh',
            () async {
          final container = createContainer();
          var count = 0;
          final provider = factory.simpleTestProvider(
            (ref) => Future.value(count++),
          );

          container.listen(provider, (previous, next) {});

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
          final provider = factory.simpleTestProvider(
            (ref) => Future.value(ref.watch(dep)),
          );

          container.listen(provider, (previous, next) {});

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(container.read(provider), const AsyncLoading<int>());

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        });

        test(
            'does not set isRefreshing if both triggered by a dependency change and ref.refresh',
            () async {
          final container = createContainer();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider(
            (ref) => Future.value(ref.watch(dep)),
          );

          container.listen(provider, (previous, next) {});

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(container.refresh(provider), const AsyncLoading<int>());

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        });
      });

      test('supports listenSelf', () {
        final listener = Listener<AsyncValue<int>>();
        final onError = ErrorListener();
        final provider = factory.simpleTestProvider<int>((ref) {
          ref.listenSelf(listener, onError: onError);
          Error.throwWithStackTrace(42, StackTrace.empty);
        });
        final container = createContainer();

        container.listen(provider, (previous, next) {});

        verifyOnly(
          listener,
          listener(null, const AsyncError<int>(42, StackTrace.empty)),
        );
        verifyZeroInteractions(onError);

        container.read(provider.notifier).state = const AsyncData(42);

        verifyNoMoreInteractions(onError);
        verifyOnly(
          listener,
          listener(
            const AsyncError<int>(42, StackTrace.empty),
            const AsyncData<int>(42),
          ),
        );
      });

      test(
          'converts AsyncNotifier.build into an AsyncData if the future completes',
          () async {
        final provider = factory.simpleTestProvider((ref) => Future.value(0));
        final container = createContainer();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncLoading()));
        expect(
          container.read(provider.notifier).state,
          const AsyncLoading<int>(),
        );

        expect(await container.read(provider.future), 0);

        verifyOnly(
          listener,
          listener(const AsyncLoading(), const AsyncData(0)),
        );
        expect(
          container.read(provider.notifier).state,
          const AsyncData<int>(0),
        );
      });

      test(
          'converts AsyncNotifier.build into an AsyncError if the future fails',
          () async {
        final provider = factory.simpleTestProvider<int>(
          (ref) => Future.error(0, StackTrace.empty),
        );
        final container = createContainer();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncLoading()));
        expect(
          container.read(provider.notifier).state,
          const AsyncLoading<int>(),
        );

        await expectLater(container.read(provider.future), throwsA(0));

        verifyOnly(
          listener,
          listener(const AsyncLoading(), const AsyncError(0, StackTrace.empty)),
        );
        expect(
          container.read(provider.notifier).state,
          const AsyncError<int>(0, StackTrace.empty),
        );
      });

      test('supports cases where the AsyncNotifier constructor throws',
          () async {
        final provider = factory.testProvider<int>(
          () => Error.throwWithStackTrace(0, StackTrace.empty),
        );
        final container = createContainer();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(
          listener,
          listener(null, const AsyncError(0, StackTrace.empty)),
        );
        expect(
          () => container.read(provider.notifier),
          throwsA(0),
        );

        await expectLater(container.read(provider.future), throwsA(0));
      });

      test(
          'synchronously emits AsyncData if AsyncNotifier.build emits synchronously',
          () async {
        final provider = factory.simpleTestProvider<int>((ref) => 0);
        final container = createContainer();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncData(0)));
        expect(container.read(provider.notifier).state, const AsyncData(0));
        expect(container.read(provider.future), isSynchronousFuture<int>(0));
      });

      test(
          'synchronously emits AsyncError if AsyncNotifier.build throws synchronously',
          () async {
        final provider = factory.simpleTestProvider<int>(
          (ref) => Error.throwWithStackTrace(42, StackTrace.empty),
        );
        final container = createContainer();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(
          listener,
          listener(null, const AsyncError(42, StackTrace.empty)),
        );
        expect(
          container.read(provider.notifier).state,
          const AsyncError<int>(42, StackTrace.empty),
        );
        await expectLater(container.read(provider.future), throwsA(42));
      });

      test(
          'stops listening to the previous future data when the provider rebuilds',
          () async {
        final container = createContainer();
        final dep = StateProvider((ref) => 0);
        final completers = {
          0: Completer<int>.sync(),
          1: Completer<int>.sync(),
        };
        final provider = factory.simpleTestProvider<int>(
          (ref) => completers[ref.watch(dep)]!.future,
        );
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener);

        expect(container.read(provider.future), completion(42));
        verifyZeroInteractions(listener);
        expect(container.read(provider), const AsyncLoading<int>());

        container.read(dep.notifier).state++;
        completers[0]!.complete(42);

        verifyZeroInteractions(listener);

        expect(container.read(provider.future), completion(21));
        expect(container.read(provider), const AsyncLoading<int>());

        completers[1]!.complete(21);

        expect(await container.read(provider.future), 21);
        expect(container.read(provider), const AsyncData<int>(21));
      });

      test(
          'stops listening to the previous future error when the provider rebuilds',
          () async {
        final container = createContainer();
        final dep = StateProvider((ref) => 0);
        final completers = {
          0: Completer<int>.sync(),
          1: Completer<int>.sync(),
        };
        final provider = factory.simpleTestProvider<int>(
          (ref) => completers[ref.watch(dep)]!.future,
        );
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener);

        expect(container.read(provider.future), throwsA(42));
        verifyZeroInteractions(listener);
        expect(container.read(provider), const AsyncLoading<int>());

        container.read(dep.notifier).state++;
        completers[0]!.completeError(42, StackTrace.empty);

        verifyZeroInteractions(listener);

        expect(container.read(provider.future), throwsA(21));
        expect(container.read(provider), const AsyncLoading<int>());

        completers[1]!.completeError(21, StackTrace.empty);

        await expectLater(container.read(provider.future), throwsA(21));
        expect(
          container.read(provider),
          const AsyncError<int>(21, StackTrace.empty),
        );
      });

      group('AsyncNotifier.state', () {
        test(
            'when read on outdated provider, refreshes the provider and return the up-to-date state',
            () async {
          final listener = OnBuildMock();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider<int>(
            (ref) {
              listener();
              return Future.value(ref.watch(dep));
            },
          );
          final container = createContainer();

          container.listen(provider, (previous, next) {});
          final notifier = container.read(provider.notifier);

          expect(notifier.state, const AsyncLoading<int>());
          expect(await container.read(provider.future), 0);
          expect(notifier.state, const AsyncData(0));
          verify(listener()).called(1);

          container.read(dep.notifier).state++;

          expect(notifier.state, const AsyncLoading<int>());
          expect(await container.read(provider.future), 1);
          expect(notifier.state, const AsyncData(1));
          verify(listener()).called(1);
        });

        test('can be read inside build', () {
          final dep = StateProvider((ref) => 0);
          late AsyncValue<int> state;
          final provider = factory.testProvider<int>(
            () {
              late AsyncTestNotifierBase<int> notifier;
              return notifier = factory.notifier<int>(
                (ref) {
                  state = notifier.state;
                  return Future.value(ref.watch(dep));
                },
              );
            },
          );
          final container = createContainer();

          container.listen(provider, (previous, next) {});

          expect(state, const AsyncLoading<int>());

          container.read(provider.notifier).state = const AsyncData(42);
          container.refresh(provider);

          expect(
            state,
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(42)),
          );
        });

        test('notifies listeners when the setter is called', () {
          final provider = factory.simpleTestProvider((ref) => 0);
          final container = createContainer();
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, listener);

          verifyZeroInteractions(listener);

          container.read(provider.notifier).state = const AsyncData(42);

          verifyOnly(
            listener,
            listener(const AsyncData(0), const AsyncData(42)),
          );
        });
      });

      test('performs AsyncValue transition on refresh', () {});
      test(
          'does not perform AsyncValue transition on dependency change', () {});

      group('AsyncNotifier.future', () {
        test('retuns a Future identical to that of .future', () {
          final listener = OnBuildMock();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider<int>(
            (ref) {
              listener();
              return Future.value(ref.watch(dep));
            },
          );
          final container = createContainer();

          container.listen(provider.notifier, (previous, next) {});
          final notifier = container.read(provider.notifier);

          expect(notifier.future(), same(container.read(provider.future)));
        });

        test(
            'when read on outdated provider, refreshes the provider and return the up-to-date state',
            () async {
          final listener = OnBuildMock();
          final dep = StateProvider((ref) => 0);
          final provider = factory.simpleTestProvider<int>(
            (ref) {
              listener();
              return Future.value(ref.watch(dep));
            },
          );
          final container = createContainer();

          container.listen(provider, (previous, next) {});
          final notifier = container.read(provider.notifier);

          expect(await container.read(provider.future), 0);
          verify(listener()).called(1);

          container.read(dep.notifier).state++;

          expect(notifier.future(), notifier.future());
          expect(notifier.future(), same(container.read(provider.future)));
          expect(await notifier.future(), 1);
          verify(listener()).called(1);
        });
      });

      group('AsyncNotifierProvider.notifier', () {
        test(
            'never emits an update. The Notifier is never recreated once it is instantiated',
            () async {
          final listener = OnBuildMock();
          final dep = StateProvider((ref) => 0);
          final provider = factory.testProvider<int>(() {
            listener();
            return factory.notifier((ref) => ref.watch(dep));
          });
          final container = createContainer();

          container.listen(provider, (previous, next) {});
          final notifier = container.read(provider.notifier);

          verify(listener()).called(1);
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;

          expect(container.read(provider), const AsyncData(1));
          expect(container.read(provider.notifier), same(notifier));
          verifyNoMoreInteractions(listener);
        });
      });

      group('AsyncNotifer.update', () {});
    });
  }

  group('AutoDispose variant', () {
    test('can watch autoDispose providers', () {
      final dep = Provider.autoDispose((ref) => 0);
      final provider = AutoDisposeAsyncNotifierProvider<
          AutoDisposeAsyncTestNotifier<int>, int>(
        () => AutoDisposeAsyncTestNotifier((ref) {
          return ref.watch(dep);
        }),
      );
      final container = createContainer();

      expect(container.read(provider), const AsyncData(0));
    });
  });
}

@immutable
class Equal<T> {
  // ignore: prefer_const_constructors_in_immutables
  Equal(this.value);

  final T value;

  @override
  bool operator ==(Object other) => other is Equal<T> && other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}
