code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/failing_functional_ref.dart:6:5

```dart
@riverpod
// expect_lint: functional_ref
int >>>refless<<<() {
  return 0;
}
```

=======

code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/failing_functional_ref.dart:13:3

```dart
int incorrectlyTyped(
  // expect_lint: functional_ref
  >>>int<<< ref,
) {
  return 0;
```

=======

code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/failing_functional_ref.dart:21:23

```dart
@riverpod
// expect_lint: functional_ref
int noRefButArgs({int >>>a<<< = 42}) {
  return 0;
}
```
