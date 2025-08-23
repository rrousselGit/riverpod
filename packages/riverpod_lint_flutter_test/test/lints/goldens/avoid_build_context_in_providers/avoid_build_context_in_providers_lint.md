code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:12:3

```dart
  Ref ref,
  // expect_lint: avoid_build_context_in_providers
  >>>BuildContext context1<<<, {
  // expect_lint: avoid_build_context_in_providers
  required BuildContext context2,
```

=======

code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:14:3

```dart
  BuildContext context1, {
  // expect_lint: avoid_build_context_in_providers
  >>>required BuildContext context2<<<,
}) => 0;

```

=======

code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:21:5

```dart
  int build(
    // expect_lint: avoid_build_context_in_providers
    >>>BuildContext context1<<<, {
    // expect_lint: avoid_build_context_in_providers
    required BuildContext context2,
```

=======

code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:23:5

```dart
    BuildContext context1, {
    // expect_lint: avoid_build_context_in_providers
    >>>required BuildContext context2<<<,
  }) => 0;

```

=======

code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:28:5

```dart
  void event(
    // expect_lint: avoid_build_context_in_providers
    >>>BuildContext context3<<<, {
    // expect_lint: avoid_build_context_in_providers
    required BuildContext context4,
```

=======

code: avoid_build_context_in_providers
severity: Severity.info
message: Passing BuildContext to providers indicates mixing UI with the business logic.
test/lints/avoid_build_context_in_providers.dart:30:5

```dart
    BuildContext context3, {
    // expect_lint: avoid_build_context_in_providers
    >>>required BuildContext context4<<<,
  }) {}
}
```
