part of '../framework.dart';

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
@internal
void handleFireImmediately<State>(
  Result<State> currentState, {
  required void Function(State? previous, State current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  switch (currentState) {
    case ResultData<State>():
      runBinaryGuarded(listener, null, currentState.value);
    case ResultError<State>():
      runBinaryGuarded(onError, currentState.error, currentState.stackTrace);
  }
}
