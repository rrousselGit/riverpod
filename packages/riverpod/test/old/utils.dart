import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

final isAssertionError = isA<AssertionError>();

ValueT Function(KeyT) cacheFamily<KeyT, ValueT>(
  ValueT Function(KeyT key) create,
) {
  final cache = <KeyT, ValueT>{};
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

class OnAddListener extends Mock {
  void call();
}

class OnRemoveListener extends Mock {
  void call();
}

class Listener<StateT> extends Mock {
  void call(StateT? previous, StateT? next);
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

typedef VerifyOnly =
    VerificationResult Function<ResT>(Mock mock, ResT matchingInvocations);

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

class _Sentinel {
  const _Sentinel();
}
