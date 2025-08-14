import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<ValueT> with _$Result<ValueT> {
  Result._();
  factory Result.data(ValueT value) = _$ResultData<ValueT>;
  factory Result.error(Object error, [StackTrace? stackTrace]) =
      _$ResultError<ValueT>;

  factory Result.guard(ValueT Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  static Future<Result<ValueT>> guardFuture<ValueT>(
    Future<ValueT> Function() cb,
  ) async {
    try {
      return Result.data(await cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  Result<NewT> chain<NewT>(NewT Function(ValueT value) cb) {
    switch (this) {
      case _$ResultData(:final value):
        try {
          return Result.data(cb(value));
        } catch (err, stack) {
          return Result.error(err, stack);
        }

      case _$ResultError(:final error):
        return Result.error(error);
    }
  }

  ValueT get dataOrThrow {
    switch (this) {
      case _$ResultData(:final value):
        return value;
      case _$ResultError(:final error):
        // ignore: only_throw_errors
        throw error;
    }
  }
}
