import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  Result._();
  factory Result.data(T value) = _ResultData<T>;
  factory Result.error(Object error, [StackTrace stackTrace]) = _ResultError<T>;

  factory Result.guard(T Function() cb) {
    try {
      return Result.data(cb());
    } catch (err, stack) {
      return Result.error(err, stack);
    }
  }

  Result<Res> chain<Res>(Res Function(T value) cb) {
    return when(
      data: (value) {
        try {
          return Result.data(cb(value));
        } catch (err, stack) {
          return Result.error(err, stack);
        }
      },
      error: (err, stack) => Result.error(err, stack),
    );
  }

  T get dataOrThrow {
    return when(
      data: (value) => value,
      error: (err, stack) {
        // ignore: only_throw_errors
        throw err;
      },
    );
  }
}

extension ResultFlatten<T> on Result<Future<T>> {
  Future<Result<T>> flatten() async {
    return when(
      data: (future) async {
        try {
          final value = await future;
          return Result.data(value);
        } catch (err, stack) {
          return Result.error(err, stack);
        }
      },
      error: (err, stack) => Result.error(err, stack),
    );
  }
}
