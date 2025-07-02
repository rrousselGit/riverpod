import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart' hide Retry;

export '../old/utils.dart' show ObserverMock, isProviderObserverContext;

class _Sentinel {
  const _Sentinel();
}

TypeMatcher<MutationIdle<StateT>> isMutationIdle<StateT>() {
  return isA<MutationIdle<StateT>>();
}

TypeMatcher<MutationPending<StateT>> isMutationPending<StateT>() {
  return isA<MutationPending<StateT>>();
}

TypeMatcher<MutationSuccess<StateT>> isMutationSuccess<StateT>([
  Object? value = const _Sentinel(),
]) {
  final matcher = isA<MutationSuccess<StateT>>();

  if (value != const _Sentinel()) {
    return matcher.having((e) => e.value, 'value', value);
  }

  return matcher;
}

TypeMatcher<MutationError<StateT>> isMutationError<StateT>({
  Object? error = const _Sentinel(),
  Object? stackTrace = const _Sentinel(),
}) {
  var matcher = isA<MutationError<StateT>>();

  if (error != const _Sentinel()) {
    matcher = matcher.having((e) => e.error, 'error', error);
  }
  if (stackTrace != const _Sentinel()) {
    matcher = matcher.having((e) => e.stackTrace, 'stackTrace', stackTrace);
  }

  return matcher;
}

typedef RemoveListener = void Function();

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

List<Object?> captureErrors(List<void Function()> cb) {
  final errors = <Object?>[];
  for (final fn in cb) {
    try {
      fn();
      errors.add(null);
    } catch (e) {
      errors.add(e);
    }
  }
  return errors;
}

class StreamSubscriptionView<ValueT> implements StreamSubscription<ValueT> {
  StreamSubscriptionView(this.inner);

  final StreamSubscription<ValueT> inner;

  @override
  Future<CastValueT> asFuture<CastValueT>([CastValueT? futureValue]) =>
      inner.asFuture(futureValue);

  @override
  Future<void> cancel() => inner.cancel();

  @override
  bool get isPaused => inner.isPaused;

  @override
  void onData(void Function(ValueT data)? handleData) =>
      inner.onData(handleData);

  @override
  void onDone(void Function()? handleDone) => inner.onDone(handleDone);

  @override
  void onError(Function? handleError) => inner.onError(handleError);

  @override
  void pause([Future<void>? resumeSignal]) => inner.pause(resumeSignal);

  @override
  void resume() => inner.resume();
}

class _DelegatingStreamSubscription<StateT>
    extends StreamSubscriptionView<StateT> {
  _DelegatingStreamSubscription(
    super.inner, {
    this.onSubscriptionPause,
    this.onSubscriptionResume,
    this.onSubscriptionCancel,
  });

  final void Function()? onSubscriptionPause;
  final void Function()? onSubscriptionResume;
  final void Function()? onSubscriptionCancel;

  @override
  Future<void> cancel() {
    onSubscriptionCancel?.call();
    return super.cancel();
  }

  @override
  void pause([Future<void>? resumeSignal]) {
    onSubscriptionPause?.call();
    super.pause(resumeSignal);
  }

  @override
  void resume() {
    onSubscriptionResume?.call();
    super.resume();
  }
}

class DelegatingStream<ValueT> extends StreamView<ValueT> {
  DelegatingStream(
    super.stream, {
    this.onSubscriptionPause,
    this.onSubscriptionResume,
    this.onSubscriptionCancel,
  });

  final void Function()? onSubscriptionPause;
  final void Function()? onSubscriptionResume;
  final void Function()? onSubscriptionCancel;

  @override
  StreamSubscription<ValueT> listen(
    void Function(ValueT event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return _DelegatingStreamSubscription(
      super.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      ),
      onSubscriptionPause: onSubscriptionPause,
      onSubscriptionResume: onSubscriptionResume,
      onSubscriptionCancel: onSubscriptionCancel,
    );
  }
}

class OverrideWithBuildMock<NotifierT, StateT, CreatedT> extends Mock {
  OverrideWithBuildMock(this.fallback);

  final CreatedT fallback;

  CreatedT call(Ref? ref, NotifierT? value) {
    return super.noSuchMethod(
      Invocation.method(#call, [ref, value]),
      returnValue: fallback,
      returnValueForMissingStub: fallback,
    ) as CreatedT;
  }
}

class RetryMock extends Mock {
  RetryMock([Retry? retry]) {
    if (retry != null) {
      when(call(any, any)).thenAnswer(
        (i) => retry(
          i.positionalArguments[0] as int,
          i.positionalArguments[1] as Object,
        ),
      );
    }
  }

  Duration? call(int? retryCount, Object? error);
}

class OnBuildMock extends Mock {
  void call();
}

class OnDisposeMock extends Mock {
  void call();
}

class OnCancel extends Mock {
  void call();
}

class OnResume extends Mock {
  void call();
}

class OnPause extends Mock {
  void call();
}

class OnAddListener extends Mock {
  void call();
}

class OnRemoveListener extends Mock {
  void call();
}

TypeMatcher<AsyncError<ValueT>> isAsyncError<ValueT>(
  Object? error, {
  Object? stackTrace = const _Sentinel(),
  Object? retrying = const _Sentinel(),
  Object? isLoading = const _Sentinel(),
  Object? value = const _Sentinel(),
  Object? hasValue = const _Sentinel(),
}) {
  var matcher = isA<AsyncError<ValueT>>();
  matcher = matcher.having((e) => e.error, 'error', error);
  if (stackTrace != const _Sentinel()) {
    matcher = matcher.having((e) => e.stackTrace, 'stackTrace', stackTrace);
  }
  if (retrying != const _Sentinel()) {
    matcher = matcher.having((e) => e.retrying, 'retrying', retrying);
  }
  if (isLoading != const _Sentinel()) {
    matcher = matcher.having((e) => e.isLoading, 'isLoading', isLoading);
  }
  if (value != const _Sentinel()) {
    matcher = matcher.having((e) => e.value, 'value', value);
  }
  if (hasValue != const _Sentinel()) {
    matcher = matcher.having((e) => e.hasValue, 'hasValue', hasValue);
  }

  return matcher;
}

TypeMatcher<AsyncLoading<ValueT>> isAsyncLoading<ValueT>({
  Object? retrying = const _Sentinel(),
  Object? value = const _Sentinel(),
  Object? hasValue = const _Sentinel(),
  Object? error = const _Sentinel(),
  Object? stackTrace = const _Sentinel(),
  Object? hasError = const _Sentinel(),
}) {
  var matcher = isA<AsyncLoading<ValueT>>();
  if (retrying != const _Sentinel()) {
    matcher = matcher.having((e) => e.retrying, 'retrying', retrying);
  }
  if (value != const _Sentinel()) {
    matcher = matcher.having((e) => e.value, 'value', value);
  }
  if (hasValue != const _Sentinel()) {
    matcher = matcher.having((e) => e.hasValue, 'hasValue', hasValue);
  }
  if (error != const _Sentinel()) {
    matcher = matcher.having((e) => e.error, 'error', error);
  }
  if (stackTrace != const _Sentinel()) {
    matcher = matcher.having((e) => e.stackTrace, 'stackTrace', stackTrace);
  }
  if (hasError != const _Sentinel()) {
    matcher = matcher.having((e) => e.hasError, 'hasError', hasError);
  }

  return matcher;
}

/// Syntax sugar for:
///
/// ```dart
/// verify(mock()).called(1);
/// verifyNoMoreInteractions(mock);
/// ```
VerifyOnly get verifyOnly {
  final verification = verify;

  return <ResT>(mock, invocation) {
    final result = verification(invocation);
    result.called(1);
    verifyNoMoreInteractions(mock);
    return result;
  };
}

typedef VerifyOnly = VerificationResult Function<ResT>(
  Mock mock,
  ResT matchingInvocations,
);

class Listener<StateT> extends Mock {
  void call(StateT? previous, StateT? next);
}

class StorageMock<KeyT, EncodedT> extends Mock
    implements Storage<KeyT, EncodedT> {
  @override
  FutureOr<PersistedData<EncodedT>?> read(KeyT? key);
  @override
  FutureOr<void> write(KeyT? key, EncodedT? value, StorageOptions? options);
  @override
  FutureOr<void> delete(KeyT? key);
}

final isAssertionError = isA<AssertionError>();

Matcher isStateErrorWith({String? message}) {
  var matcher = isStateError;

  if (message != null) {
    matcher = matcher.having((e) => e.message, 'message', message);
  }

  return matcher;
}

class ErrorListener extends Mock {
  void call(Object? error, StackTrace? stackTrace);
}

class Selector<InT, OutT> extends Mock {
  Selector(this.fake, OutT Function(InT) selector) {
    when(call(any)).thenAnswer((i) {
      return selector(
        i.positionalArguments.first as InT,
      );
    });
  }

  final OutT fake;

  OutT call(InT? value) {
    return super.noSuchMethod(
      Invocation.method(#call, [value]),
      returnValue: fake,
      returnValueForMissingStub: fake,
    ) as OutT;
  }
}

class Counter extends StateNotifier<int> {
  Counter([super.initialValue = 0]);

  void increment() => state++;

  @override
  int get state => super.state;
  @override
  set state(int value) => super.state = value;
}

List<Object> errorsOf(void Function() cb) {
  final errors = <Object>[];
  runZonedGuarded(cb, (err, _) => errors.add(err));
  return [...errors];
}
