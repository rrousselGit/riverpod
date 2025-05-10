import 'dart:async';

import 'package:meta/meta.dart';

import '../internals.dart';

/// Rethrows as a [ProviderException] with the given stack trace.
@internal
Never throwProviderException(Object error, StackTrace stackTrace) {
  throw ProviderException._(error, stackTrace);
}

@internal
extension ProviderExceptionX on ProviderException {
  Never unwrap(StackTrace stackTrace) =>
      Error.throwWithStackTrace(exception, stackTrace);
}

/// An exception thrown when trying to read a provider that is in error state.
///
/// This exception can be thrown when either:
/// - You're using a synchronous provider ([Notifier]/[Provider]) and
///   the provider threw an exception during its initialization.
/// - You're using an asynchronous provider ([FutureProvider]/[StreamProvider]),
///   the state is an [AsyncError], and you called [AsyncValue.requireValue].
/// - Using an asynchronous provider, you awaited [FutureProvider.future],
///   and the provider was in error state.
///
///
/// Catching this exception can be useful to differentiate between
/// a provider in error state from a provider that depends on another provider
/// in error state.
///
/// In particular, Riverpod will:
/// - Disable automatic retry if a [ProviderException] is thrown by a provider.
///   This avoids retrying a provider that isn't the source of the problem.
/// - Not report the error to [Zone] if it is a [ProviderException].
///   This avoids reporting the same error twice.
@publicInMisc
final class ProviderException implements Exception {
  ProviderException._(this.exception, this.stackTrace);

  /// The exception that was thrown by the provider.
  final Object exception;

  /// The stack trace of the exception.
  final StackTrace stackTrace;

  @override
  String toString() {
    if (exception case final ProviderException exception) {
      return '''
$exception

And rethrown at:
$stackTrace''';
    }

    return '''
ProviderException: Tried to use a provider that is in error state.

A provider threw the following exception:
$exception

The stack trace of the exception:
$stackTrace''';
  }
}
