import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart' hide Retry;

export '../old/utils.dart' show ObserverMock;

typedef RemoveListener = void Function();

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

class StreamSubscriptionView<T> implements StreamSubscription<T> {
  StreamSubscriptionView(this.inner);

  final StreamSubscription<T> inner;

  @override
  Future<E> asFuture<E>([E? futureValue]) => inner.asFuture(futureValue);

  @override
  Future<void> cancel() => inner.cancel();

  @override
  bool get isPaused => inner.isPaused;

  @override
  void onData(void Function(T data)? handleData) => inner.onData(handleData);

  @override
  void onDone(void Function()? handleDone) => inner.onDone(handleDone);

  @override
  void onError(Function? handleError) => inner.onError(handleError);

  @override
  void pause([Future<void>? resumeSignal]) => inner.pause(resumeSignal);

  @override
  void resume() => inner.resume();
}

class _DelegatingStreamSubscription<T> extends StreamSubscriptionView<T> {
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

class DelegatingStream<T> extends StreamView<T> {
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
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
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

class OnBuildMock extends Mock {
  void call();
}

class OnDisposeMock extends Mock {
  void call();
}

class OnCancelMock extends Mock {
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

Matcher isStateErrorWith({String? message}) {
  var matcher = isA<StateError>();

  if (message != null) {
    matcher = matcher.having((e) => e.message, 'message', message);
  }

  return matcher;
}

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
