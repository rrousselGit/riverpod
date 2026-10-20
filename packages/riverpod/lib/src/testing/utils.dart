// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart' hide Retry;

import '../internals.dart';

extension CompleterX<ComplexT> on Completer<ComplexT> {
  void dispose() {
    if (isCompleted) return;
    completeError(StateError('disposed'));
  }
}

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
        )
        as CreatedT;
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
  OnDisposeMock([this.label]);

  final String? label;

  void call();

  @override
  String toString() {
    return 'OnDisposeMock($label)';
  }
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

class OnManualInvalidation extends Mock {
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
  Object? isReloading = const _Sentinel(),
  Object? isRefreshing = const _Sentinel(),
  Object? progress = const _Sentinel(),
}) {
  var matcher = isA<AsyncLoading<ValueT>>().having(
    (e) => e.isLoading,
    'isLoading',
    true,
  );
  if (progress != const _Sentinel()) {
    matcher = matcher.having((e) => e.progress, 'progress', progress);
  }
  if (isReloading != const _Sentinel()) {
    matcher = matcher.having((e) => e.isReloading, 'isReloading', isReloading);
  }
  if (isRefreshing != const _Sentinel()) {
    matcher = matcher.having(
      (e) => e.isRefreshing,
      'isRefreshing',
      isRefreshing,
    );
  }
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

typedef VerifyOnly =
    VerificationResult Function<ResT>(Mock mock, ResT matchingInvocations);

class Listener<StateT> extends Mock {
  void call(StateT? previous, StateT? next);
}

final class StorageMock<KeyT, EncodedT> extends Storage<KeyT, EncodedT>
    with Mock {
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
      return selector(i.positionalArguments.first as InT);
    });
  }

  final OutT fake;

  OutT call(InT? value) {
    return super.noSuchMethod(
          Invocation.method(#call, [value]),
          returnValue: fake,
          returnValueForMissingStub: fake,
        )
        as OutT;
  }
}

class Counter extends StateNotifier<int> {
  Counter([super._state = 0]);

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

ValueT Function(KeyT) cacheFamily<KeyT, ValueT>(
  ValueT Function(KeyT key) create,
) {
  final cache = <KeyT, ValueT>{};
  return (key) => cache.putIfAbsent(key, () => create(key));
}

// Copied from Flutter
/// Asserts that two [String]s are equal after normalizing likely hash codes.
///
/// A `#` followed by 5 hexadecimal digits is assumed to be a short hash code
/// and is normalized to #00000.
Matcher equalsIgnoringHashCodes(String value) {
  return _EqualsIgnoringHashCodes(value);
}

class _EqualsIgnoringHashCodes extends Matcher {
  _EqualsIgnoringHashCodes(String v) : _value = _normalize(v);

  final String _value;

  static final _mismatchedValueKey = Object();

  static String _normalize(String s) {
    return s.replaceAll(RegExp('#[0-9a-fA-F]{5}'), '#00000');
  }

  @override
  bool matches(Object? object, Map<Object?, Object?> matchState) {
    final description = _normalize(object! as String);
    if (_value != description) {
      matchState[_mismatchedValueKey] = description;
      return false;
    }
    return true;
  }

  @override
  Description describe(Description description) {
    return description.add('multi line description equals $_value');
  }

  @override
  Description describeMismatch(
    Object? item,
    Description mismatchDescription,
    Map<Object?, Object?> matchState,
    bool verbose,
  ) {
    if (matchState.containsKey(_mismatchedValueKey)) {
      final actualValue = matchState[_mismatchedValueKey]! as String;
      // Leading whitespace is added so that lines in the multiline
      // description returned by addDescriptionOf are all indented equally
      // which makes the output easier to read for this case.
      return mismatchDescription
          .add('expected normalized value\n  ')
          .addDescriptionOf(_value)
          .add('\nbut got\n  ')
          .addDescriptionOf(actualValue);
    }
    return mismatchDescription;
  }
}

final class ObserverMock extends ProviderObserver with Mock {
  ObserverMock([this.label]);

  final String? label;

  @override
  String toString() => label ?? super.toString();

  @override
  void didAddProvider(ProviderObserverContext? context, Object? value) {
    noSuchMethod(Invocation.method(#didAddProvider, [context, value]));
  }

  @override
  void providerDidFail(
    ProviderObserverContext? context,
    Object? error,
    StackTrace? stackTrace,
  ) {
    noSuchMethod(
      Invocation.method(#providerDidFail, [context, error, stackTrace]),
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext? context,
    Object? previousValue,
    Object? newValue,
  ) {
    noSuchMethod(
      Invocation.method(#didUpdateProvider, [context, previousValue, newValue]),
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext? context) {
    noSuchMethod(Invocation.method(#didDisposeProvider, [context]));
  }

  @override
  void mutationReset(
    ProviderObserverContext? context,
    Mutation<Object?>? mutation,
  ) {
    noSuchMethod(Invocation.method(#mutationReset, [context, mutation]));
  }

  @override
  void mutationStart(
    ProviderObserverContext? context,
    Mutation<Object?>? mutation,
  ) {
    noSuchMethod(Invocation.method(#mutationStart, [context, mutation]));
  }

  @override
  void mutationError(
    ProviderObserverContext? context,
    Mutation<Object?>? mutation,
    Object? error,
    StackTrace? stackTrace,
  ) {
    noSuchMethod(
      Invocation.method(#mutationError, [context, mutation, error, stackTrace]),
    );
  }

  @override
  void mutationSuccess(
    ProviderObserverContext? context,
    Mutation<Object?>? mutation,
    Object? result,
  ) {
    noSuchMethod(
      Invocation.method(#mutationSuccess, [context, mutation, result]),
    );
  }
}

// can subclass ProviderObserver without implementing all life-cycles
final class CustomObserver extends ProviderObserver {}

TypeMatcher<ProviderObserverContext> isProviderObserverContext({
  Object? provider = const _Sentinel(),
  Object? container = const _Sentinel(),
  Object? mutation = const _Sentinel(),
}) {
  var matcher = isA<ProviderObserverContext>();

  if (provider is! _Sentinel) {
    matcher = matcher.having((e) => e.provider, 'provider', provider);
  }
  if (container is! _Sentinel) {
    matcher = matcher.having((e) => e.container, 'container', container);
  }
  if (mutation is! _Sentinel) {
    matcher = matcher.having((e) => e.mutation, 'mutation', mutation);
  }

  return matcher;
}
