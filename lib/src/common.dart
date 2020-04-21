import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'common.freezed.dart';

@freezed
abstract class AsyncValue<T> {
  @visibleForTesting
  factory AsyncValue.data(T value) = _Data<T>;
  @visibleForTesting
  const factory AsyncValue.loading() = _Loading<T>;
  @visibleForTesting
  factory AsyncValue.error(dynamic error, [StackTrace stackTrace]) = _Error<T>;
}
