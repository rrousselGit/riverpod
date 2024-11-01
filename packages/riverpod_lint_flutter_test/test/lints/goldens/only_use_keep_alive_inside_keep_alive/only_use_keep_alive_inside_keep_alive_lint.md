code: only_use_keep_alive_inside_keep_alive
severity: Severity.warning
correctionMessage: Either stop marking this provider as `keepAlive` or remove `keepAlive` from the used provider.
message: If a provider is declared as `keepAlive`, it can only use providers that are also declared as `keepAlive.
test/lints/only_use_keep_alive_inside_keep_alive.dart:28:3

```dart

  // expect_lint: only_use_keep_alive_inside_keep_alive
  >>>ref.watch(autoDisposeProvider)<<<;
  // expect_lint: only_use_keep_alive_inside_keep_alive
  ref.watch(autoDisposeClassProvider);
```

=======

code: only_use_keep_alive_inside_keep_alive
severity: Severity.warning
correctionMessage: Either stop marking this provider as `keepAlive` or remove `keepAlive` from the used provider.
message: If a provider is declared as `keepAlive`, it can only use providers that are also declared as `keepAlive.
test/lints/only_use_keep_alive_inside_keep_alive.dart:30:3

```dart
  ref.watch(autoDisposeProvider);
  // expect_lint: only_use_keep_alive_inside_keep_alive
  >>>ref.watch(autoDisposeClassProvider)<<<;

  return 0;
```
