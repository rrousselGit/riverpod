import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

TypeMatcher<IdleMutationState<T>> isIdleMutationState<T>() {
  return isA<IdleMutationState<T>>();
}

TypeMatcher<PendingMutationState<T>> isPendingMutationState<T>() {
  return isA<PendingMutationState<T>>();
}

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

TypeMatcher<SuccessMutationState<T>> isSuccessMutationState<T>([
  Object? value = _sentinel,
]) {
  var matcher = isA<SuccessMutationState<T>>();
  if (value != _sentinel) {
    matcher = matcher.having((e) => e.value, 'value', value);
  }

  return matcher;
}

TypeMatcher<ErrorMutationState<T>> isErrorMutationState<T>(Object error) {
  return isA<ErrorMutationState<T>>().having((e) => e.error, 'error', error);
}

class ListenerMock<T> with Mock {
  void call(Object? a, Object? b);
}
