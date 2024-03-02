import 'dart:async';

import 'package:mockito/mockito.dart';
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

ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );
  addTearDown(container.dispose);
  return container;
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
  void call();
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

// can subclass ProviderObserver without implementing all life-cycles
class CustomObserver extends ProviderObserver {}
