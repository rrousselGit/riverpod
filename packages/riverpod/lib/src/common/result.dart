import 'package:meta/meta.dart';

import 'internal_lints.dart';
import 'stack_trace.dart';

/// A T|Error union type.
@immutable
@internal
@publicInCodegen
sealed class $Result<ValueT> {
  /// The data case
  factory $Result.data(ValueT state) = $ResultData;

  /// The error case
  factory $Result.error(Object error, StackTrace stackTrace) = $ResultError;

  static $Result<State> guard<State>(State Function() cb) {
    try {
      return $Result.data(cb());
    } catch (err, stack) {
      return $Result.error(err, stack);
    }
  }

  /// Whether this is a [$ResultData] or a [$ResultError].
  bool get hasData;
  bool get hasError => !hasData;

  /// The state if this is a [$ResultData], `null` otherwise.
  ValueT? get value;

  /// The state if this is a [$ResultData], throws otherwise.
  ValueT get valueOrProviderException;
  ValueT get valueOrRawException;

  /// The error if this is a [$ResultError], `null` otherwise.
  Object? get error;

  /// The stack trace if this is a [$ResultError], `null` otherwise.
  StackTrace? get stackTrace;
}

/// The data case
@internal
final class $ResultData<State> implements $Result<State> {
  /// The data case
  $ResultData(this.value);

  @override
  bool get hasData => true;

  @override
  bool get hasError => false;

  @override
  Object? get error => null;

  @override
  StackTrace? get stackTrace => null;

  @override
  final State value;

  @override
  State get valueOrProviderException => value;
  @override
  State get valueOrRawException => value;

  @override
  bool operator ==(Object other) =>
      other is $ResultData<State> &&
      other.runtimeType == runtimeType &&
      other.value == value;

  @override
  int get hashCode => Object.hash(runtimeType, value);
}

/// The error case
@internal
final class $ResultError<State> implements $Result<State> {
  /// The error case
  $ResultError(this.error, this.stackTrace);

  /// The error
  @override
  final Object error;

  /// The stack trace
  @override
  final StackTrace stackTrace;

  @override
  bool get hasData => false;

  @override
  bool get hasError => true;

  @override
  State? get value => null;

  @override
  State get valueOrRawException => Error.throwWithStackTrace(error, stackTrace);

  @override
  State get valueOrProviderException =>
      throwProviderException(error, stackTrace);

  @override
  bool operator ==(Object other) =>
      other is $ResultError<State> &&
      other.runtimeType == runtimeType &&
      other.stackTrace == stackTrace &&
      other.error == error;

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
