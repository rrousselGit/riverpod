import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/misc.dart'
    show NotifierProviderFamily, ProviderOrFamily;
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

class Counter extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

/// A [Notifier] whose state tests set from outside, with
/// `container.read(provider.notifier).state = value`.
///
/// It replaces the legacy `StateProvider` in tests that only need a provider
/// whose state changes.
class SettableNotifier<StateT> extends Notifier<StateT> {
  SettableNotifier(this._build);

  final StateT Function(Ref ref) _build;

  @override
  StateT build() => _build(ref);

  /// Sets the state to the result of [cb] on the current state.
  StateT update(StateT Function(StateT state) cb) => state = cb(state);
}

/// A provider of a [SettableNotifier].
NotifierProvider<SettableNotifier<StateT>, StateT> settableProvider<StateT>(
  StateT Function(Ref ref) build, {
  String? name,
  Iterable<ProviderOrFamily>? dependencies,
  bool isAutoDispose = false,
}) {
  return NotifierProvider<SettableNotifier<StateT>, StateT>(
    () => SettableNotifier(build),
    name: name,
    dependencies: dependencies,
    isAutoDispose: isAutoDispose,
  );
}

/// A family of [SettableNotifier]s.
/// A family of [SettableNotifier]s.
NotifierProviderFamily<SettableNotifier<StateT>, StateT, ArgT>
settableProviderFamily<StateT, ArgT>(
  StateT Function(Ref ref, ArgT arg) build, {
  String? name,
  Iterable<ProviderOrFamily>? dependencies,
  bool isAutoDispose = false,
}) {
  return NotifierProvider.family<SettableNotifier<StateT>, StateT, ArgT>(
    (arg) => SettableNotifier((ref) => build(ref, arg)),
    name: name,
    dependencies: dependencies,
    isAutoDispose: isAutoDispose,
  );
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

typedef VerifyOnly =
    VerificationResult Function<ResultT>(
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

class DeferredNotifier<StateT> extends Notifier<StateT> {
  DeferredNotifier(this._build);

  final StateT Function(Ref ref, DeferredNotifier<StateT> self) _build;

  @override
  Ref get ref;

  @override
  StateT build() {
    return _build(ref, this);
  }
}
