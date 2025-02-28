import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  Result._();
  factory Result.data(T value) = _ResultData<T>;
  factory Result.error(Object error, [StackTrace? stackTrace]) =
      _ResultError<T>;

  factory Result.guard(T Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  static Future<Result<T>> guardFuture<T>(Future<T> Function() cb) async {
    try {
      return Result.data(await cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  Result<Res> chain<Res>(Res Function(T value) cb) {
    switch (this) {
      case _ResultData(:final value):
        try {
          return Result.data(cb(value));
        } catch (err, stack) {
          return Result.error(err, stack);
        }

      case _ResultError(:final error):
        return Result.error(error);
    }
  }

  T get dataOrThrow {
    switch (this) {
      case _ResultData(:final value):
        return value;
      case _ResultError(:final error):
        // ignore: only_throw_errors
        throw error;
    }
  }
}
