import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

class ListenerMock<T> with Mock {
  void call(Object? a, Object? b);
}

typedef VerifyOnly = VerificationResult Function<T>(
  Mock mock,
  T matchingInvocations,
);

/// Syntax sugar for:
///
/// ```dart
/// verify(mock()).called(1);
/// verifyNoMoreInteractions(mock);
/// ```
VerifyOnly get verifyOnly {
  final verification = verify;

  return <T>(mock, invocation) {
    final result = verification(invocation);
    result.called(1);
    verifyNoMoreInteractions(mock);
    return result;
  };
}

TypeMatcher<MutationBase<T>> isMutationBase<T>({
  TypeMatcher<MutationState<T>>? state,
}) {
  var matcher = isA<MutationBase<T>>();

  if (state != null) {
    matcher = matcher.having((e) => e.state, 'state', state);
  }

  return matcher;
}

TypeMatcher<IdleMutationState<T>> isIdleMutationState<T>() {
  return isA<IdleMutationState<T>>();
}

TypeMatcher<PendingMutationState<T>> isPendingMutationState<T>() {
  return isA<PendingMutationState<T>>();
}

TypeMatcher<SuccessMutationState<T>> isSuccessMutationState<T>(T value) {
  return isA<SuccessMutationState<T>>().having((e) => e.value, 'value', value);
}

TypeMatcher<ErrorMutationState<T>> isErrorMutationState<T>(Object error) {
  return isA<ErrorMutationState<T>>().having((e) => e.error, 'error', error);
}
