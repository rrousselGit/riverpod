import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'common.freezed.dart';

@freezed
abstract class AsyncValue<T> {
  factory AsyncValue.data(T value) = _Data<T>;
  const factory AsyncValue.loading() = _Loading<T>;
  factory AsyncValue.error(dynamic error, [StackTrace stackTrace]) = _Error<T>;
}
