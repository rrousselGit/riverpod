import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
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

class ObserverMock extends Mock implements ProviderObserver {
  ObserverMock([this.label]);

  final String? label;

  @override
  String toString() {
    return label ?? super.toString();
  }

  @override
  void didAddProvider(
    ProviderObserverContext? context,
    Object? value,
  );

  @override
  void providerDidFail(
    ProviderObserverContext? context,
    Object? error,
    StackTrace? stackTrace,
  );

  @override
  void didUpdateProvider(
    ProviderObserverContext? context,
    Object? previousValue,
    Object? newValue,
  );

  @override
  void didDisposeProvider(ProviderObserverContext? context);

  @override
  void mutationReset(ProviderObserverContext? context);

  @override
  void mutationStart(
    ProviderObserverContext? context,
    MutationContext? mutation,
  );

  @override
  void mutationError(
    ProviderObserverContext? context,
    MutationContext? mutation,
    Object? error,
    StackTrace? stackTrace,
  );

  @override
  void mutationSuccess(
    ProviderObserverContext? context,
    MutationContext? mutation,
    Object? result,
  );
}

TypeMatcher<ProviderObserverContext> isProviderObserverContext(
  Object? provider,
  Object? container, {
  required Object? mutation,
}) {
  var matcher = isA<ProviderObserverContext>();

  matcher = matcher.having((e) => e.provider, 'provider', provider);
  matcher = matcher.having((e) => e.container, 'container', container);
  matcher = matcher.having((e) => e.mutation, 'mutation', mutation);

  return matcher;
}

TypeMatcher<MutationContext> isMutationContext(
  Object? invocation, {
  Object? notifier,
}) {
  var matcher = isA<MutationContext>();

  matcher = matcher.having((e) => e.invocation, 'invocation', invocation);
  if (notifier != null) {
    matcher = matcher.having((e) => e.notifier, 'notifier', notifier);
  }

  return matcher;
}
