// Package imports:
import "package:freezed_annotation/freezed_annotation.dart";

part "auth_value_failures.freezed.dart";

@freezed
class AuthValueFailures<T> with _$AuthValueFailures<T> {
  const factory AuthValueFailures.invalidEmail({required String? failedValue}) =
      InvalidEmail<T>;

  const factory AuthValueFailures.shortPassword(
      {required String? failedValue}) = ShortPassword<T>;

  const factory AuthValueFailures.noSpecialSymbol(
      {required String? failedValue}) = NoSpecialSymbol<T>;

  const factory AuthValueFailures.noUpperCase({required String? failedValue}) =
      NoUpperCase<T>;

  const factory AuthValueFailures.noNumber({required String? failedValue}) =
      NoNumber<T>;

}
