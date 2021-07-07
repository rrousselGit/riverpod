
import '../Authentication/auth_value_failures.dart';

class UnExpectedValueError extends Error {
  UnExpectedValueError(this.authValueFailures);

  final AuthValueFailures? authValueFailures;


  @override
  String toString() {
    return Error.safeToString(
        'UnExpectedValueError{authValueFailures: $authValueFailures}');
  }
}
