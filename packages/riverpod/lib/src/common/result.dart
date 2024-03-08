import 'package:meta/meta.dart';

/// A T|Error union type.
@immutable
@internal
abstract class Result<State> {
  /// The data case
  // coverage:ignore-start
  factory Result.data(State state) = ResultData;
  // coverage:ignore-end

  /// The error case
  // coverage:ignore-start
  factory Result.error(Object error, StackTrace stackTrace) = ResultError;
  // coverage:ignore-end

  /// Automatically catches errors into a [ResultError] and convert successful
  /// values into a [ResultData].
  static Result<State> guard<State>(State Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  /// Whether this is a [ResultData] or a [ResultError].
  bool get hasState;

  /// The state if this is a [ResultData], `null` otherwise.
  State? get stateOrNull;

  /// The state if this is a [ResultData], throws otherwise.
  State get requireState;

  // TODO remove when migrating to Dart 3
  /// Returns the result of calling [data] if this is a [ResultData] or [error]
  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  });

  // TODO remove when migrating to Dart 3
  /// Returns the result of calling [data] if this is a [ResultData] or [error]
  R when<R>({
    required R Function(State data) data,
    required R Function(Object error, StackTrace stackTrace) error,
  });
}

/// The data case
@internal
class ResultData<State> implements Result<State> {
  /// The data case
  ResultData(this.state);

  /// The state
  final State state;

  @override
  bool get hasState => true;

  @override
  State? get stateOrNull => state;

  @override
  State get requireState => state;

  @override
  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  }) {
    return data(this);
  }

  @override
  R when<R>({
    required R Function(State data) data,
    required R Function(Object error, StackTrace stackTrace) error,
  }) {
    return data(state);
  }

  @override
  bool operator ==(Object other) =>
      other is ResultData<State> &&
      other.runtimeType == runtimeType &&
      other.state == state;

  @override
  int get hashCode => Object.hash(runtimeType, state);
}

/// The error case
@internal
class ResultError<State> implements Result<State> {
  /// The error case
  ResultError(this.error, this.stackTrace);

  /// The error
  final Object error;

  /// The stack trace
  final StackTrace stackTrace;

  @override
  bool get hasState => false;

  @override
  State? get stateOrNull => null;

  @override
  State get requireState => Error.throwWithStackTrace(error, stackTrace);

  @override
  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  }) {
    return error(this);
  }

  @override
  R when<R>({
    required R Function(State data) data,
    required R Function(Object error, StackTrace stackTrace) error,
  }) {
    return error(this.error, stackTrace);
  }

  @override
  bool operator ==(Object other) =>
      other is ResultError<State> &&
      other.runtimeType == runtimeType &&
      other.stackTrace == stackTrace &&
      other.error == error;

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
