import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

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

class ProviderObserverMock extends Mock implements ProviderObserver {}

class OverrideWithBuildMock<NotifierT, StateT, CreatedT> extends Mock {
  OverrideWithBuildMock(this.fallback);

  final CreatedT fallback;

  CreatedT call(Ref<StateT>? ref, NotifierT? value) {
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

class OnAddListener extends Mock {
  void call(ProviderSubscription? sub);
}

class OnRemoveListener extends Mock {
  void call(ProviderSubscription? sub);
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

class ObserverMock extends Mock implements ProviderObserver {
  ObserverMock([this.label]);

  final String? label;

  @override
  String toString() {
    return label ?? super.toString();
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?>? provider,
    ProviderContainer? container,
  ) {
    super.noSuchMethod(
      Invocation.method(#didDisposeProvider, [provider, container]),
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?>? provider,
    Object? error,
    Object? stackTrace,
    Object? container,
  ) {
    super.noSuchMethod(
      Invocation.method(
        #providerDidFail,
        [provider, error, stackTrace, container],
      ),
    );
  }

  @override
  void didAddProvider(
    ProviderBase<Object?>? provider,
    Object? value,
    ProviderContainer? container,
  ) {
    super.noSuchMethod(
      Invocation.method(#didAddProvider, [provider, value, container]),
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?>? provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer? container,
  ) {
    super.noSuchMethod(
      Invocation.method(
        #didUpdateProvider,
        [provider, previousValue, newValue, container],
      ),
    );
  }
}
