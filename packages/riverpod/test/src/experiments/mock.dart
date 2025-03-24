import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

TypeMatcher<IdleMutation<T>> isIdleMutation<T>() {
  return isA<IdleMutation<T>>();
}

TypeMatcher<PendingMutation<T>> isPendingMutation<T>() {
  return isA<PendingMutation<T>>();
}

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

TypeMatcher<SuccessMutation<T>> isSuccessMutation<T>([
  Object? value = _sentinel,
]) {
  var matcher = isA<SuccessMutation<T>>();
  if (value != _sentinel) {
    matcher = matcher.having((e) => e.value, 'value', value);
  }

  return matcher;
}

TypeMatcher<ErrorMutation<T>> isErrorMutation<T>(Object error) {
  return isA<ErrorMutation<T>>().having((e) => e.error, 'error', error);
}

class ListenerMock<T> with Mock {
  void call(Object? a, Object? b);
}
