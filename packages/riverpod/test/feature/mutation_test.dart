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

    final result = container.mutate(mut, (ref) => completer.future);

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

    final result = container.mutate(mut, (ref) => completer.future);

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

  group('auto reset', () {
    test('resets to idle if all listeners are removed', () {});
  });
}
