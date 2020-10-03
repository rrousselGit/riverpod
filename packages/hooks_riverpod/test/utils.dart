import 'package:mockito/mockito.dart';
import 'package:state_notifier/state_notifier.dart';

class ListenerMock<T> extends Mock {
  void call(T value);
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

class SelectorSpy<T> extends Mock {
  void call(T value);
}

class BuildSpy extends Mock {
  void call();
}

class MockCreateState extends Mock {
  void call();
}

class Counter extends StateNotifier<int> {
  Counter([int initialValue = 0]) : super(initialValue);

  void increment() => state++;

  @override
  set state(int value) {
    super.state = value;
  }
}
