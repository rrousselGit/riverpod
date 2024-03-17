code: missing_provider_scope
severity: Severity.warning
message: Flutter applications should have a ProviderScope widget at the top of the widget tree.
test/lints/missing_provider_scope.dart:6:3

```dart
void main() {
  // expect_lint: missing_provider_scope
  >>>runApp<<<(
    MyApp(),
  );
```

=======

code: missing_provider_scope
severity: Severity.warning
message: Flutter applications should have a ProviderScope widget at the top of the widget tree.
test/lints/missing_provider_scope.dart:20:3

```dart
void definitelyNotAMain() {
  // expect_lint: missing_provider_scope
  >>>runApp<<<(
    MyApp(),
  );
```
