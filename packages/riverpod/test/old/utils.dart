import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

final isAssertionError = isA<AssertionError>();

R Function(Key) cacheFamily<Key, R>(R Function(Key key) create) {
  final cache = <Key, R>{};
  return (key) => cache.putIfAbsent(key, () => create(key));
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

class ProviderObserverMock extends Mock implements ProviderObserver {}

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

class OnCancelMock extends Mock {
  void call();
}

class OnResume extends Mock {
  void call();
}

class OnAddListener extends Mock {
  void call();
}

class OnRemoveListener extends Mock {
  void call();
}

class Listener<T> extends Mock {
  void call(T? previous, T? next);
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

  static final Object _mismatchedValueKey = Object();

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

// can subclass ProviderObserver without implementing all life-cycles
class CustomObserver extends ProviderObserver {}

TypeMatcher<ProviderObserverContext> isProviderObserverContext(
  Object? provider,
  Object? container, {
  Object? mutation,
}) {
  var matcher = isA<ProviderObserverContext>();

  matcher = matcher.having((e) => e.provider, 'provider', provider);
  matcher = matcher.having((e) => e.container, 'container', container);
  if (mutation != null) {
    matcher = matcher.having((e) => e.mutation, 'mutation', mutation);
  }

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
