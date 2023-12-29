import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class OnDisposeMock extends Mock {
  void call();
}

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

typedef VerifyOnly = VerificationResult Function<T>(
  Mock mock,
  T matchingInvocations,
);

class Listener<T> extends Mock {
  void call(T? previous, T? next);
}

final isAssertionError = isA<AssertionError>();

class ErrorListener extends Mock {
  void call(Object? error, StackTrace? stackTrace);
}

class Selector<Input, Output> extends Mock {
  Selector(this.fake, Output Function(Input) selector) {
    when(call(any)).thenAnswer((i) {
      return selector(
        i.positionalArguments.first as Input,
      );
    });
  }

  final Output fake;

  Output call(Input? value) {
    return super.noSuchMethod(
      Invocation.method(#call, [value]),
      returnValue: fake,
      returnValueForMissingStub: fake,
    ) as Output;
  }
}
