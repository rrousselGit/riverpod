import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../old/utils.dart' show equalsIgnoringHashCodes, ProviderObserverMock;
import '../src/utils.dart';

void main() {
  test('Supports void mutations', () async {
    final mut = Mutation<void>();
    final container = ProviderContainer.test();

    final sub = container.listen(
      mut,
      (previous, next) {},
      fireImmediately: true,
    );

    await mut.run(container, (tsx) async {});

    expect(container.read(mut), isMutationSuccess<void>());
  });

  test('Concurrent run call ignores the previous run call', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();
    final completer1 = Completer<int>();
    final completer2 = Completer<int>();
    final listener = Listener<MutationState<int>>();

    final sub = container.listen(mut, listener.call);

    final a = mut.run(container, (tsx) => completer1.future);
    verifyOnly(
      listener,
      listener(
        argThat(isMutationIdle<int>()),
        argThat(isMutationPending<int>()),
      ),
    );

    final b = mut.run(container, (tsx) => completer2.future);
    verifyNoMoreInteractions(listener);

    completer1.complete(1);
    await a;

    verifyNoMoreInteractions(listener);

    completer2.complete(2);
    await b;

    verifyOnly(
      listener,
      listener(
        argThat(isMutationPending<int>()),
        argThat(isMutationSuccess<int>(2)),
      ),
    );
  });

  test('Success flow', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();
    final listener = Listener<MutationState<int>>();
    final completer = Completer<int>();

    final sub = container.listen(mut, listener.call, fireImmediately: true);

    verifyOnly(
      listener,
      listener(argThat(isNull), argThat(isMutationIdle<int>())),
    );

    final result = mut.run(container, (tsx) => completer.future);

    verifyOnly(
      listener,
      listener(
        argThat(isMutationIdle<int>()),
        argThat(isMutationPending<int>()),
      ),
    );

    completer.complete(42);
    await null;

    verifyOnly(
      listener,
      listener(
        argThat(isMutationPending<int>()),
        argThat(isMutationSuccess<int>(42)),
      ),
    );

    expect(await result, 42);
  });

  test('Failure flow', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();
    final listener = Listener<MutationState<int>>();
    final onError = ErrorListener();
    final completer = Completer<int>();

    final sub = container.listen(mut, listener.call, fireImmediately: true);

    verifyOnly(
      listener,
      listener(argThat(isNull), argThat(isMutationIdle<int>())),
    );

    final result = mut.run(container, (tsx) => completer.future);

    // caching errors before they are reported to the zone
    expect(result, throwsA(42));

    verifyOnly(
      listener,
      listener(
        argThat(isMutationIdle<int>()),
        argThat(isMutationPending<int>()),
      ),
    );

    completer.completeError(42);
    await null;

    verifyOnly(
      listener,
      listener(
        argThat(isMutationPending<int>()),
        argThat(isMutationError<int>(error: 42)),
      ),
    );
  });

  group('Mutation', () {
    group('.reset', () {
      test('simple flow', () async {
        final mut = Mutation<int>();
        final container = ProviderContainer.test();

        unawaited(mut.run(container, (tsx) async => 42));
        mut.reset(container);

        expect(container.read(mut), isMutationIdle<int>());
      });

      test('supports being called on an inactive mutation', () async {
        final mut = Mutation<int>();
        final container = ProviderContainer.test();

        mut.reset(container);

        expect(container.read(mut), isMutationIdle<int>());
      });
    });

    test('overrides ==/hashCode', () {
      expect(Mutation<int>(), isNot(Mutation<int>()));
      expect(Mutation<int>().hashCode, isNot(Mutation<int>().hashCode));

      final mut = Mutation<int>();
      expect(mut, mut);
      expect(mut.hashCode, mut.hashCode);

      expect(mut(1), mut(1));
      expect(mut(1).hashCode, mut(1).hashCode);
      expect(mut(1), isNot(mut(2)));
      expect(mut(1).hashCode, isNot(mut(2).hashCode));
      expect(mut(1), isNot(mut));
      expect(mut(1).hashCode, isNot(mut.hashCode));
    });

    test('toString', () {
      expect(
        Mutation<int>().toString(),
        equalsIgnoringHashCodes('Mutation<int>#00000()'),
      );
      expect(
        Mutation<int>()(1).toString(),
        equalsIgnoringHashCodes('Mutation<int>#00000(1)'),
      );

      expect(
        Mutation<int>(label: 'test').toString(),
        equalsIgnoringHashCodes('Mutation<int>#00000(label: test)'),
      );
      expect(
        Mutation<int>(label: 'test')(1).toString(),
        equalsIgnoringHashCodes('Mutation<int>#00000(1, label: test)'),
      );
    });
  });

  test('Notifies ProviderObserver', () async {
    final mut = Mutation<int>();
    final observer = ProviderObserverMock();
    final container = ProviderContainer.test(observers: [observer]);
    final completer = Completer<int>();

    final sub = container.listen(mut(1), (previous, next) {});
    final sub2 = container.listen(mut(2), (previous, next) {});

    final first = mut(1).run(container, (tsx) => completer.future);

    verifyOnly(
      observer,
      observer.mutationStart(
        argThat(
          isProviderObserverContext(mutation: mut(1), container: container),
        ),
        mut(1),
      ),
    );

    completer.complete(42);
    await first;

    verifyOnly(
      observer,
      observer.mutationSuccess(
        argThat(
          isProviderObserverContext(mutation: mut(1), container: container),
        ),
        mut(1),
        argThat(equals(42)),
      ),
    );

    final second = mut(
      2,
    ).run(container, (tsx) async => throw Exception('error'));

    verifyOnly(
      observer,
      observer.mutationStart(
        argThat(
          isProviderObserverContext(mutation: mut(2), container: container),
        ),
        mut(2),
      ),
    );

    await expectLater(second, throwsA(isA<Exception>()));

    verifyOnly(
      observer,
      observer.mutationError(
        argThat(
          isProviderObserverContext(mutation: mut(2), container: container),
        ),
        mut(2),
        argThat(isA<Exception>()),
        any,
      ),
    );

    // No provider event should be emitted
    verifyNoMoreInteractions(observer);
  });

  test(
    'While within `run`, ProviderObserver events log the current mutation',
    () async {
      final mut = Mutation<void>();
      final observer = ProviderObserverMock();
      final container = ProviderContainer.test(observers: [observer]);
      final provider = Provider<int>((ref) => 0);

      unawaited(
        mut.run(container, (tsx) async {
          tsx.get(provider);
        }),
      );

      verify(
        observer.didAddProvider(
          argThat(
            isProviderObserverContext(
              mutation: mut,
              provider: provider,
              container: container,
            ),
          ),
          any,
        ),
      );
    },
  );

  test(
    'Keeps used listenables active until the end of the transaction',
    () async {
      final mut = Mutation<int>();
      final onDispose = OnDisposeMock();
      final futureCompleter = Completer<int>();
      final p = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(onDispose.call);
        return futureCompleter.future;
      });
      final container = ProviderContainer.test();
      final completer = Completer<void>();

      final f = mut.run(container, (tsx) async {
        tsx.get(p);

        await completer.future;

        return 0;
      });

      await container.pump();
      futureCompleter.complete(42);
      await container.pump();

      verifyZeroInteractions(onDispose);

      completer.complete();
      await completer.future;
      await container.pump();

      verifyOnly(onDispose, onDispose.call());
    },
  );

  test('Resets to idle if all listeners are removed', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();

    await mut.run(container, (tsx) async => 0);

    await container.pump();

    expect(container.read(mut), isMutationIdle<int>());
  });

  test('Mutations are independent from one another', () async {
    final mut1 = Mutation<int>();
    final mut2 = mut1('foo');
    final mut3 = mut1('bar');
    final mut4 = Mutation<int>();
    final container = ProviderContainer.test();

    final sub1 = container.listen(mut1, (previous, next) {});
    final sub2 = container.listen(mut2, (previous, next) {});
    final sub3 = container.listen(mut3, (previous, next) {});
    final sub4 = container.listen(mut4, (previous, next) {});

    await mut1.run(container, (tsx) async => 1);
    await mut2.run(container, (tsx) async => 2);
    await mut3.run(container, (tsx) async => 3);
    await mut4.run(container, (tsx) async => 4);

    expect(container.read(mut1), isMutationSuccess<int>(1));
    expect(container.read(mut2), isMutationSuccess<int>(2));
    expect(container.read(mut3), isMutationSuccess<int>(3));
    expect(container.read(mut4), isMutationSuccess<int>(4));
  });
}
