import 'package:dartz/dartz.dart';


import 'auth_value_failures.dart';

Either<AuthValueFailures<String>, String> validateEmailAddress({
  required String? email,
}) {
  final emailRegex = RegExp(
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&"*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  if (emailRegex.hasMatch(email!)) {
    return right(email);
  } else {
    return left(
      AuthValueFailures.invalidEmail(failedValue: email),
    );
  }
}

Either<AuthValueFailures<String>, String> validatePassword({
  required String? password,
}) {
  final hasMinLength = password!.length > 6;
  final hasUppercase = password.contains(RegExp('[A-Z]'));
  final hasDigits = password.contains(RegExp('[0-9]'));
  final hasSpecialCharacters =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  if (!hasMinLength) {
    return left(
      AuthValueFailures.shortPassword(failedValue: password),
    );
  } else if (!hasUppercase) {
    return left(
      AuthValueFailures.noUpperCase(failedValue: password),
    );
  } else if (!hasDigits) {
    return left(
      AuthValueFailures.noNumber(failedValue: password),
    );
  } else if (!hasSpecialCharacters) {
    return left(
      AuthValueFailures.noSpecialSymbol(failedValue: password),
    );
  } else {
    return right(password);
  }
}


