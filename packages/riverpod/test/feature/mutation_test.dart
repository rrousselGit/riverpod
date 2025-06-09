import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

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

    verifyOnly(
      listener,
      listener(
        argThat(isMutationPending<int>()),
        argThat(isMutationSuccess<int>(42)),
      ),
    );

    expect(await result, 42);
  });
}
