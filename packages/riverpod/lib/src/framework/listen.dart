part of '../framework.dart';

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void handleFireImmediately<State>(
  Result<State> currentState, {
  required void Function(State? previous, State current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  currentState.map(
    data: (data) => _runBinaryGuarded(listener, null, data.state),
    error: (error) => _runBinaryGuarded(onError, error.error, error.stackTrace),
  );
}
