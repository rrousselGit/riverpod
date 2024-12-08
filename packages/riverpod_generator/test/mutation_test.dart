import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/mutation.dart';
import 'mock.dart';

void main() {
  test('Can listen a mutation', () async {
    final container = ProviderContainer.test();
    final listener = ListenerMock<Simple$Delegated>();

    final sub = container.listen(
      simpleProvider.delegated,
      listener.call,
      fireImmediately: true,
    );

    verifyOnly(
      listener,
      listener(any, isMutationBase<int>(state: isIdleMutationState())),
    );

    final future = sub.read().call(() async => 1);

    verifyOnly(
      listener,
      listener(any, isMutationBase<int>(state: isPendingMutationState())),
    );

    expect(await future, 1);

    verifyOnly(
      listener,
      listener(any, isMutationBase<int>(state: isSuccessMutationState(1))),
    );

    final future2 = sub.read().call(() => throw StateError('42'));

    await expectLater(future2, throwsA(isStateError));
    verifyInOrder([
      listener(any, isMutationBase<int>(state: isPendingMutationState())),
      listener(
        any,
        isMutationBase<int>(state: isErrorMutationState(isStateError)),
      ),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test('Can listen a mutation with family', () async {
    final container = ProviderContainer.test();
    final listener = ListenerMock<SimpleFamily$Increment>();

    final sub =
        container.listen(simpleFamilyProvider('key').increment, listener.call);

    expect(
      sub.read(),
      isMutationBase<int>(state: isIdleMutationState()),
    );

    final future = sub.read().call(2);

    expect(
      sub.read(),
      isMutationBase<int>(state: isPendingMutationState()),
    );

    expect(await future, 2);

    expect(
      sub.read(),
      isMutationBase<int>(state: isSuccessMutationState(2)),
    );
  });

  test('Supports generic mutations', () async {
    final container = ProviderContainer.test();
    final listener = ListenerMock<GenericMut$Increment>();

    final sub = container.listen(genericMutProvider.increment, listener.call);

    expect(
      sub.read(),
      isMutationBase<int>(state: isIdleMutationState()),
    );

    final future = sub.read().call<double>(2.5);

    expect(await future, 3);

    expect(
      sub.read(),
      isMutationBase<int>(state: isSuccessMutationState(3)),
    );
  });

  group('auto reset', () {
    test('Automatically resets the state when all listeners are removed',
        () async {
      final container = ProviderContainer.test();

      // The mutation should reset even if the provider is kept alive
      container.listen(simpleProvider, (a, b) {});

      final sub = container.listen(simpleProvider.increment, (a, b) {});
      final sub2 = container.listen(simpleProvider.increment, (a, b) {});

      await sub.read().call(2);

      sub.close();
      await null;

      expect(
        container.read(simpleProvider.increment),
        isMutationBase<int>(state: isSuccessMutationState(2)),
      );

      sub2.close();
      await null;

      expect(
        container.read(simpleProvider.increment),
        isMutationBase<int>(state: isIdleMutationState()),
      );
    });

    test('is cancelled if a listener is added during the delay', () async {
      final container = ProviderContainer.test();

      final sub = container.listen(simpleProvider.increment, (a, b) {});

      await sub.read().call(2);
      sub.close();

      container.listen(simpleProvider.increment, (a, b) {});
      await null;

      expect(
        container.read(simpleProvider.increment),
        isMutationBase<int>(state: isSuccessMutationState(2)),
      );
    });
  });

  test('Maintains progress even if a provider is when the provider is reset',
      () async {
    final container = ProviderContainer.test();

    final sub = container.listen(simpleProvider.increment, (a, b) {});

    await sub.read().call(2);
    container.invalidate(simpleProvider);

    expect(
      sub.read(),
      isMutationBase<int>(state: isSuccessMutationState(2)),
    );
  });

  test('Supports getting called again while pending', () async {
    final container = ProviderContainer.test();
    final sub = container.listen(simpleAsyncProvider.delegated, (a, b) {});

    final completer = Completer<int>();
    final completer2 = Completer<int>();
    final completer3 = Completer<int>();

    final future = sub.read().call(() => completer.future);
    final future2 = sub.read().call(() => completer2.future);
    final future3 = sub.read().call(() => completer3.future);

    completer.complete(42);

    expect(await future, 42);
    expect(
      sub.read(),
      isMutationBase<int>(state: isPendingMutationState()),
    );
    expect(container.read(simpleAsyncProvider), const AsyncData(42));

    completer2.completeError(21);
    await expectLater(future2, throwsA(21));
    expect(
      sub.read(),
      isMutationBase<int>(state: isPendingMutationState()),
    );
    expect(container.read(simpleAsyncProvider), const AsyncData(42));

    completer3.complete(21);
    expect(await future3, 21);
    expect(
      sub.read(),
      isMutationBase<int>(state: isSuccessMutationState(21)),
    );
    expect(container.read(simpleAsyncProvider), const AsyncData(21));
  });

  test('Listening to a mutation keeps the provider alive', () async {
    final container = ProviderContainer.test();

    final sub = container.listen(simpleProvider.increment, (a, b) {});

    expect(container.read(simpleProvider), 0);

    await container.pump();
    expect(container.exists(simpleProvider), true);

    sub.close();

    await container.pump();
    expect(container.exists(simpleProvider), false);
  });

  test('Listening a mutation lazily initializes the provider', () async {
    final container = ProviderContainer.test();

    final sub = container.listen(simpleProvider.increment, (a, b) {});

    final element = container.readProviderElement(simpleProvider);

    expect(element.stateResult, null);

    await sub.read().call(2);

    expect(container.read(simpleProvider), 2);
  });

  test('If notifier constructor throws, the mutation immediately throws',
      () async {
    final observer = ObserverMock();
    final container = ProviderContainer.test(observers: [observer]);

    final sub = container.listen(failingCtorProvider.increment, (a, b) {});

    expect(sub.read(), isMutationBase<int>(state: isIdleMutationState()));

    expect(() => sub.read().call(2), throwsStateError);

    expect(
      sub.read(),
      isMutationBase<int>(state: isIdleMutationState()),
    );
    verifyNever(observer.mutationError(any, any, any, any));
  });

  group('reset', () {
    test('Supports calling reset while pending', () async {
      final container = ProviderContainer.test();
      final sub = container.listen(simpleProvider.delegated, (a, b) {});

      final completer = Completer<int>();
      final future = sub.read().call(() => completer.future);

      sub.read().reset();

      completer.complete(42);

      expect(await future, 42);
      expect(
        sub.read(),
        isMutationBase<int>(state: isIdleMutationState()),
      );
    });

    test('sets the state back to idle', () async {
      final container = ProviderContainer.test();
      final listener = ListenerMock<Simple$Increment>();

      final sub = container.listen(simpleProvider.increment, listener.call);

      await sub.read().call(2);

      sub.read().reset();

      expect(
        sub.read(),
        isMutationBase<int>(state: isIdleMutationState()),
      );
    });
  });

  group('Integration with ProviderObserver', () {
    test('handles generic methods', () async {
      final observer = ObserverMock();
      final container = ProviderContainer.test(
        observers: [observer],
      );

      container.listen(genericMutProvider, (a, b) {});
      container.listen(genericMutProvider.increment, (a, b) {});
      await container.read(genericMutProvider.future);

      clearInteractions(observer);

      await container.read(genericMutProvider.increment).call<double>(42);

      verify(
        observer.didUpdateProvider(
          argThat(
            isProviderObserverContext(
              genericMutProvider,
              container,
              mutation: isMutationContext(
                isInvocation(
                  memberName: #increment,
                  positionalArguments: [42.0],
                  kind: InvocationKind.method,
                  typeArguments: [double],
                ),
              ),
            ),
          ),
          const AsyncData<int>(0),
          const AsyncData<int>(42),
        ),
      );
    });

    test('sends current mutation to didUpdateProvider', () async {
      final observer = ObserverMock();
      final container = ProviderContainer.test(
        observers: [observer],
      );

      final sub = container.listen(simpleProvider.notifier, (a, b) {});
      container.listen(simpleProvider.delegated, (a, b) {});

      clearInteractions(observer);

      Future<int> fn() async {
        sub.read().state = 1;
        return 42;
      }

      await container.read(simpleProvider.delegated).call(fn);

      verifyInOrder([
        observer.didUpdateProvider(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isMutationContext(
                isInvocation(
                  memberName: #delegated,
                  positionalArguments: [fn],
                  kind: InvocationKind.method,
                  typeArguments: isEmpty,
                ),
              ),
            ),
          ),
          0,
          1,
        ),
        observer.didUpdateProvider(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isMutationContext(
                isInvocation(
                  memberName: #delegated,
                  positionalArguments: [fn],
                  kind: InvocationKind.method,
                  typeArguments: isEmpty,
                ),
              ),
            ),
          ),
          1,
          42,
        ),
      ]);
    });

    test('handles mutationStart/Pending/Success/Error/Reset', () async {
      final observer = ObserverMock();
      final container = ProviderContainer.test(
        observers: [observer],
      );

      container.listen(simpleProvider, (a, b) {});
      clearInteractions(observer);

      final sub = container.listen(simpleProvider.delegated, (a, b) {});
      verifyNoMoreInteractions(observer);

      Future<int> fn() async => 42;
      final stack = StackTrace.current;
      final err = StateError('foo');
      Future<int> fn2() async => Error.throwWithStackTrace(err, stack);

      final future = sub.read().call(fn);
      verifyOnly(
        observer,
        observer.mutationStart(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isNotNull,
            ),
          ),
          argThat(
            isMutationContext(
              isInvocation(
                memberName: #delegated,
                positionalArguments: [fn],
                kind: InvocationKind.method,
                typeArguments: isEmpty,
              ),
            ),
          ),
        ),
      );

      await future;

      verify(
        observer.mutationSuccess(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isNotNull,
            ),
          ),
          argThat(
            isMutationContext(
              isInvocation(
                memberName: #delegated,
                positionalArguments: [fn],
                kind: InvocationKind.method,
                typeArguments: isEmpty,
              ),
            ),
          ),
          42,
        ),
      );

      final future2 = sub.read().call(fn2);

      verify(
        observer.mutationStart(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isNotNull,
            ),
          ),
          argThat(
            isMutationContext(
              isInvocation(
                memberName: #delegated,
                positionalArguments: [fn2],
                kind: InvocationKind.method,
                typeArguments: isEmpty,
              ),
            ),
          ),
        ),
      );

      await expectLater(future2, throwsA(isStateError));

      verify(
        observer.mutationError(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isNotNull,
            ),
          ),
          argThat(
            isMutationContext(
              isInvocation(
                memberName: #delegated,
                positionalArguments: [fn2],
                kind: InvocationKind.method,
                typeArguments: isEmpty,
              ),
            ),
          ),
          err,
          stack,
        ),
      );

      sub.read().reset();

      verify(
        observer.mutationReset(
          argThat(
            isProviderObserverContext(
              simpleProvider,
              container,
              mutation: isNull,
            ),
          ),
        ),
      );
    });
  });
}
