// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

@immutable
@internal
abstract class Result<State> {
  // coverage:ignore-start
  factory Result.data(State state) = ResultData;
  // coverage:ignore-end

  // coverage:ignore-start
  factory Result.error(Object error, StackTrace stackTrace) = ResultError;
  // coverage:ignore-end

  static Result<State> guard<State>(State Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  bool get hasState;

  State? get stateOrNull;
  State get requireState;

  R map<R>({
    required R Function(ResultData<State> data) data,
    required R Function(ResultError<State>) error,
  });

  R when<R>({
    required R Function(State data) data,
    required R Function(Object error, StackTrace stackTrace) error,
  });
}

@internal
class ResultData<State> implements Result<State> {
  ResultData(this.state);

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
  bool operator ==(Object? other) =>
      other is ResultData<State> &&
      other.runtimeType == runtimeType &&
      other.state == state;

  @override
  int get hashCode => Object.hash(runtimeType, state);
}

@internal
class ResultError<State> implements Result<State> {
  ResultError(this.error, this.stackTrace);

  final Object error;
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
  bool operator ==(Object? other) =>
      other is ResultError<State> &&
      other.runtimeType == runtimeType &&
      other.stackTrace == stackTrace &&
      other.error == error;

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);
}
