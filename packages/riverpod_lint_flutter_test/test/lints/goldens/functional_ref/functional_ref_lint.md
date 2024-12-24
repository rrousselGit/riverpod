code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/functional_ref.dart:8:3

```dart
int nameless(
  // expect_lint: functional_ref
  >>>ref<<<,
) {
  return 0;
```
