import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';

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

(List<Object>, void Function() resetOnError) stubFlutterErrors() {
  final onError = FlutterError.onError;
  final errors = <Object>[];
  FlutterError.onError = (details) => errors.add(details.exception);

  return (errors, () => {FlutterError.onError = onError});
}

@isTest
void testWidgetsWithStubbedFlutterErrors(
  String description,
  Future<void> Function(WidgetTester tester, List<Object> errors) callback,
) {
  testWidgets(description, (tester) async {
    final (errors, resetOnError) = stubFlutterErrors();
    try {
      await callback(tester, errors);
    } finally {
      resetOnError();
    }
  });
}

class ErrorListener extends Mock {
  void call(Object? error, StackTrace? stackTrace);
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

class Listener<StateT> extends Mock {
  void call(StateT? prev, StateT? value);
}

List<Object> errorsOf(void Function() cb) {
  final errors = <Object>[];
  runZonedGuarded(cb, (err, _) => errors.add(err));
  return [...errors];
}

class MayHaveChangedMock<StateT> extends Mock {
  void call(ProviderSubscription<StateT> sub);
}

class DidChangedMock<StateT> extends Mock {
  void call(ProviderSubscription<StateT> sub);
}

typedef VerifyOnly = VerificationResult Function<ResultT>(
  Mock mock,
  ResultT matchingInvocations,
);

/// Syntax sugar for:
///
/// ```dart
/// verify(mock()).called(1);
/// verifyNoMoreInteractions(mock);
/// ```
VerifyOnly get verifyOnly {
  final verification = verify;

  return <ResultT>(mock, invocation) {
    final result = verification(invocation);
    result.called(1);
    verifyNoMoreInteractions(mock);
    return result;
  };
}
