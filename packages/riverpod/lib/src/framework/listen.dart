part of '../framework.dart';

void _fireImmediately<State>(
  Result<State> currentState, {
  required void Function(State? previous, State current) listener,
  required void Function(Object error, StackTrace stackTrace)? onError,
}) {
  currentState.map(
    data: (data) => _runBinaryGuarded(listener, null, data.state),
    error: (error) {
      if (onError != null) {
        _runBinaryGuarded(onError, error.error, error.stackTrace);
      }
    },
  );
}
