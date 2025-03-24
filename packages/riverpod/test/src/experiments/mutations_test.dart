import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';
import 'mock.dart';
import 'provider.dart';

void main() {
  test('Can listen a mutation', () async {
    final container = createContainer();
    final provider = TestProvider((ref) => 0);
    final mutation = provider.mutation<String>();

    final listener = ListenerMock<MutationState<int>>();

    container.listen(
      mutation,
      listener.call,
      fireImmediately: true,
    );

    verifyOnly(
      listener,
      listener(any, isIdleMutation()),
    );

    final future = container.invoke(
      provider.mutate(mutation, (ref) async {
        await Future.value();
        ref.setData(1);
        return 'Result';
      }),
    );

    verifyOnly(
      listener,
      listener(any, isPendingMutation()),
    );

    expect(await future, 'Result');

    verifyOnly(
      listener,
      listener(any, isSuccessMutation('Result')),
    );

    final future2 = container.invoke(
      provider.mutate(mutation, (ref) => throw StateError('42')),
    );

    await expectLater(future2, throwsA(isStateError));
    verifyInOrder([
      listener(any, isPendingMutation()),
      listener(any, isErrorMutation(isStateError)),
    ]);
    verifyNoMoreInteractions(listener);
  });

  test(
      skip: 'Todo',
      'Listening to a mutation does not cause the provider to rebuild when deps change',
      () async {});

  group('auto reset', () {
    test('Automatically resets the state when all listeners are removed',
        () async {
      final container = createContainer();
      final provider = TestProvider((ref) => 0);
      final increment = provider.mutation<void>();

      // The mutation should reset even if the provider is kept alive
      container.listen(provider, (a, b) {});

      final sub = container.listen(increment, (a, b) {});
      final sub2 = container.listen(increment, (a, b) {});

      await container.invoke(provider.mutate<void>(increment, (ref) {}));

      sub.close();
      await null;

      expect(container.read(increment), isSuccessMutation<void>());

      sub2.close();
      await null;

      expect(
        container.read(increment),
        isIdleMutation(),
      );
    });

    test('is cancelled if a listener is added during the delay', () async {
      final container = createContainer();
      final provider = TestProvider((ref) => 0);
      final increment = provider.mutation<void>();

      final sub = container.listen(increment, (a, b) {});

      await container.invoke(provider.mutate<void>(increment, (ref) {}));
      sub.close();

      container.listen(increment, (a, b) {});
      await null;

      expect(
        container.read(increment),
        isSuccessMutation<void>(),
      );
    });
  });

  test('Maintains progress even if a provider is when the provider is reset',
      () async {
    final container = createContainer();
    final provider = TestProvider((ref) => 0);
    final increment = provider.mutation<void>();

    final sub = container.listen(increment, (a, b) {});

    await container.invoke(provider.mutate<void>(increment, (ref) async {
      await Future.value();
    }));
    container.invalidate(provider);

    expect(sub.read(), isSuccessMutation());
  });

  test('Supports getting called again while pending', () async {
    final container = createContainer();
    final provider = TestProvider((ref) => 0);
    final mutation = provider.mutation<void>();

    final sub = container.listen(mutation, (a, b) {});

    final completer = Completer<int>();
    final completer2 = Completer<int>();
    final completer3 = Completer<int>();

    final future = container.invoke(provider.mutate(
        mutation, (ref) async => ref.setData(await completer.future)));
    final future2 = container.invoke(provider.mutate(
        mutation, (ref) async => ref.setData(await completer2.future)));
    final future3 = container.invoke(provider.mutate(
        mutation, (ref) async => ref.setData(await completer3.future)));

    completer.complete(42);

    await future;
    expect(sub.read(), isPendingMutation());
    expect(container.read(provider), (42));

    completer2.completeError(21);
    await expectLater(future2, throwsA(21));
    expect(sub.read(), isPendingMutation());
    expect(container.read(provider), (42));

    completer3.complete(21);
    await future3;
    expect(sub.read(), isSuccessMutation());
    expect(container.read(provider), (21));
  });

  test('Listening to a mutation keeps the provider alive', () async {
    final container = createContainer();
    final simpleProvider = TestProvider((ref) => 0);
    final increment = simpleProvider.mutation<void>();

    final sub = container.listen(increment, (a, b) {});

    expect(container.read(simpleProvider), 0);

    await container.pump();
    expect(container.exists(simpleProvider), true);

    sub.close();

    await container.pump();
    expect(container.exists(simpleProvider), false);
  });

  test(skip: 'Todo', 'Listening a mutation lazily initializes the provider',
      () async {
    final container = createContainer();
    final simpleProvider = TestProvider((ref) => 0);
    final increment = simpleProvider.mutation<void>();

    final element = container.readProviderElement(simpleProvider);

    expect(element.getState(), null);
    container.listen(increment, (a, b) {});
    expect(element.getState(), null);

    await container.invoke(simpleProvider.mutate(increment, (ref) {}));

    expect(container.read(simpleProvider), 2);
  });

  group('reset', () {
    test('Supports calling reset while pending', () async {
      final container = createContainer();
      final simpleProvider = TestProvider((ref) => 0);
      final increment = simpleProvider.mutation<int>();

      final sub = container.listen(increment, (a, b) {});

      final completer = Completer<int>();
      final future = container.invoke(
        simpleProvider.mutate(increment, (ref) => completer.future),
      );

      container.invoke(increment.reset());

      completer.complete(42);

      expect(await future, 42);
      expect(
        sub.read(),
        isIdleMutation(),
      );
    });

    test('sets the state back to idle', () async {
      final container = createContainer();
      final simpleProvider = TestProvider((ref) => 0);
      final increment = simpleProvider.mutation<int>();

      final sub = container.listen(increment, (a, b) {});

      await container.invoke(
        simpleProvider.mutate<int>(increment, (ref) => 0),
      );

      container.invoke(increment.reset());

      expect(
        sub.read(),
        isIdleMutation<int>(),
      );
    });
  });

  group('Integration with ProviderObserver', () {
    //   test('handles generic methods', () async {
    //     final observer = ObserverMock();
    //     final container = createContainer(
    //       observers: [observer],
    //     );

    //     container.listen(genericMutProvider, (a, b) {});
    //     container.listen(genericMutProvider.increment, (a, b) {});
    //     await container.read(genericMutProvider.future);

    //     clearInteractions(observer);

    //     await container.read(genericMutProvider.increment).call<double>(42);

    //     verify(
    //       observer.didUpdateProvider(
    //         argThat(
    //           isProviderObserverContext(
    //             genericMutProvider,
    //             container,
    //             mutation: isMutationContext(
    //               isInvocation(
    //                 memberName: #increment,
    //                 positionalArguments: [42.0],
    //                 kind: InvocationKind.method,
    //                 typeArguments: [double],
    //               ),
    //             ),
    //           ),
    //         ),
    //         const AsyncData<int>(0),
    //         const AsyncData<int>(42),
    //       ),
    //     );
    //   });

    //   test('sends current mutation to didUpdateProvider', () async {
    //     final observer = ObserverMock();
    //     final container = createContainer(
    //       observers: [observer],
    //     );

    //     final sub = container.listen(simpleProvider.notifier, (a, b) {});
    //     container.listen(simpleProvider.delegated, (a, b) {});

    //     clearInteractions(observer);

    //     Future<int> fn() async {
    //       sub.read().state = 1;
    //       return 42;
    //     }

    //     await container.read(simpleProvider.delegated).call(fn);

    //     verifyInOrder([
    //       observer.didUpdateProvider(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isMutationContext(
    //               isInvocation(
    //                 memberName: #delegated,
    //                 positionalArguments: [fn],
    //                 kind: InvocationKind.method,
    //                 typeArguments: isEmpty,
    //               ),
    //             ),
    //           ),
    //         ),
    //         0,
    //         1,
    //       ),
    //       observer.didUpdateProvider(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isMutationContext(
    //               isInvocation(
    //                 memberName: #delegated,
    //                 positionalArguments: [fn],
    //                 kind: InvocationKind.method,
    //                 typeArguments: isEmpty,
    //               ),
    //             ),
    //           ),
    //         ),
    //         1,
    //         42,
    //       ),
    //     ]);
    //   });

    //   test('handles mutationStart/Pending/Success/Error/Reset', () async {
    //     final observer = ObserverMock();
    //     final container = createContainer(
    //       observers: [observer],
    //     );

    //     container.listen(simpleProvider, (a, b) {});
    //     clearInteractions(observer);

    //     final sub = container.listen(simpleProvider.delegated, (a, b) {});
    //     verifyNoMoreInteractions(observer);

    //     Future<int> fn() async => 42;
    //     final stack = StackTrace.current;
    //     final err = StateError('foo');
    //     Future<int> fn2() async => Error.throwWithStackTrace(err, stack);

    //     final future = sub.read().call(fn);
    //     verifyOnly(
    //       observer,
    //       observer.mutationStart(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isNotNull,
    //           ),
    //         ),
    //         argThat(
    //           isMutationContext(
    //             isInvocation(
    //               memberName: #delegated,
    //               positionalArguments: [fn],
    //               kind: InvocationKind.method,
    //               typeArguments: isEmpty,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );

    //     await future;

    //     verify(
    //       observer.mutationSuccess(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isNotNull,
    //           ),
    //         ),
    //         argThat(
    //           isMutationContext(
    //             isInvocation(
    //               memberName: #delegated,
    //               positionalArguments: [fn],
    //               kind: InvocationKind.method,
    //               typeArguments: isEmpty,
    //             ),
    //           ),
    //         ),
    //         42,
    //       ),
    //     );

    //     final future2 = sub.read().call(fn2);

    //     verify(
    //       observer.mutationStart(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isNotNull,
    //           ),
    //         ),
    //         argThat(
    //           isMutationContext(
    //             isInvocation(
    //               memberName: #delegated,
    //               positionalArguments: [fn2],
    //               kind: InvocationKind.method,
    //               typeArguments: isEmpty,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );

    //     await expectLater(future2, throwsA(isStateError));

    //     verify(
    //       observer.mutationError(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isNotNull,
    //           ),
    //         ),
    //         argThat(
    //           isMutationContext(
    //             isInvocation(
    //               memberName: #delegated,
    //               positionalArguments: [fn2],
    //               kind: InvocationKind.method,
    //               typeArguments: isEmpty,
    //             ),
    //           ),
    //         ),
    //         err,
    //         stack,
    //       ),
    //     );

    //     sub.read().reset();

    //     verify(
    //       observer.mutationReset(
    //         argThat(
    //           isProviderObserverContext(
    //             simpleProvider,
    //             container,
    //             mutation: isNull,
    //           ),
    //         ),
    //       ),
    //     );
    //   });
  });
}
