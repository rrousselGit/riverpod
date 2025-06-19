import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../old/utils.dart' show equalsIgnoringHashCodes;
import '../src/utils.dart';

void main() {
  test('Success flow', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();
    final listener = Listener<MutationState<int>>();
    final completer = Completer<int>();

    final sub = container.listen(
      mut,
      listener.call,
      fireImmediately: true,
    );

    verifyOnly(
      listener,
      listener(argThat(isNull), argThat(isMutationIdle<int>())),
    );

    final result = mut.run(container, (ref) => completer.future);

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

    final sub = container.listen(
      mut,
      listener.call,
      fireImmediately: true,
    );

    verifyOnly(
      listener,
      listener(argThat(isNull), argThat(isMutationIdle<int>())),
    );

    final result = mut.run(container, (ref) => completer.future);

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

  test('Notifies ProviderObserver', () {});

  test('Keeps used listenables active until the end of the transaction',
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

    final f = mut.run(container, (ref) async {
      ref.get(p);

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
  });

  test('Resets to idle if all listeners are removed', () async {
    final mut = Mutation<int>();
    final container = ProviderContainer.test();

    await mut.run(container, (ref) async => 0);

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

    await mut1.run(container, (ref) async => 1);
    await mut2.run(container, (ref) async => 2);
    await mut3.run(container, (ref) async => 3);
    await mut4.run(container, (ref) async => 4);
  });
}
