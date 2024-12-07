import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

import 'integration/mutation.dart';
import 'mock.dart';

void main() {
// Error:
// - Mutation returns a non-FutureOr<T> type
// - mutation is not on a notifier method
// mutation is static
// mutation is abstract

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
      listener(any, isMutationBase<int>(state: isErrorMutationState(42))),
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
}
