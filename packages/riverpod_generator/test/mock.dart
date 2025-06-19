import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart';
import 'package:test/test.dart';

TypeMatcher<ProviderException> isProviderException(
  Object exception, [
  Object? stackTrace,
]) {
  var matcher = isA<ProviderException>();
  matcher = matcher.having((e) => e.exception, 'exception', exception);
  if (stackTrace != null) {
    matcher = matcher.having((e) => e.stackTrace, 'stackTrace', stackTrace);
  }

  return matcher;
}

Matcher throwsProviderException(Object exception, [Object? stackTrace]) {
  return throwsA(isProviderException(exception, stackTrace));
}

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

enum InvocationKind {
  method,
  getter,
  setter,
}

TypeMatcher<Invocation> isInvocation({
  Object? memberName,
  List<Object?>? positionalArguments,
  Map<Symbol, Object?>? namedArguments,
  Object? typeArguments,
  InvocationKind? kind,
}) {
  var matcher = isA<Invocation>();

  if (kind != null) {
    switch (kind) {
      case InvocationKind.method:
        matcher = matcher.having((e) => e.isMethod, 'isMethod', true);
      case InvocationKind.getter:
        matcher = matcher.having((e) => e.isGetter, 'isGetter', true);
      case InvocationKind.setter:
        matcher = matcher.having((e) => e.isSetter, 'isSetter', true);
    }
  }

  if (typeArguments != null) {
    matcher = matcher.having(
      (e) => e.typeArguments,
      'typeArguments',
      typeArguments,
    );
  }

  if (memberName != null) {
    matcher = matcher.having((e) => e.memberName, 'memberName', memberName);
  }

  if (positionalArguments != null) {
    matcher = matcher.having(
      (e) => e.positionalArguments,
      'positionalArguments',
      positionalArguments,
    );
  }

  if (namedArguments != null) {
    matcher = matcher.having(
      (e) => e.namedArguments,
      'namedArguments',
      namedArguments,
    );
  }

  return matcher;
}
