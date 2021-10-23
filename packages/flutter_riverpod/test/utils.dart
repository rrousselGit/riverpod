import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

class ErrorListener extends Mock {
  void call(Object? error, StackTrace? stackTrace);
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

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class Listener<T> extends Mock {
  void call(T? prev, T? value);
}

List<Object> errorsOf(void Function() cb) {
  final errors = <Object>[];
  runZonedGuarded(cb, (err, _) => errors.add(err));
  return [...errors];
}

class MayHaveChangedMock<T> extends Mock {
  void call(ProviderSubscription<T> sub);
}

class DidChangedMock<T> extends Mock {
  void call(ProviderSubscription<T> sub);
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
