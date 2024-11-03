code: unknown_scoped_usage
severity: Severity.warning
message: A provider was used, but could not find the associated `ref`.
test/lints/unknown_scoped_usage.dart:16:3

```dart
void fn(WidgetRef widgetRef, Ref ref) {
  // expect_lint: unknown_scoped_usage
  >>>scopedProvider<<<;
  rootProvider;

```

=======

code: unknown_scoped_usage
severity: Severity.warning
message: A provider was used, but could not find the associated `ref`.
test/lints/unknown_scoped_usage.dart:25:28

```dart
  // Unknown ref usage inside a ref expression
  // expect_lint: unknown_scoped_usage
  widgetRef.watch(identity(>>>scopedProvider<<<));
  // expect_lint: unknown_scoped_usage
  ref.watch(identity(scopedProvider));
```

=======

code: unknown_scoped_usage
severity: Severity.warning
message: A provider was used, but could not find the associated `ref`.
test/lints/unknown_scoped_usage.dart:27:22

```dart
  widgetRef.watch(identity(scopedProvider));
  // expect_lint: unknown_scoped_usage
  ref.watch(identity(>>>scopedProvider<<<));
  // expect_lint: unknown_scoped_usage
  ref.watch(identityMap[scopedProvider]);
```

=======

code: unknown_scoped_usage
severity: Severity.warning
message: A provider was used, but could not find the associated `ref`.
test/lints/unknown_scoped_usage.dart:29:25

```dart
  ref.watch(identity(scopedProvider));
  // expect_lint: unknown_scoped_usage
  ref.watch(identityMap[>>>scopedProvider<<<]);

  // Overrides are OK
```

=======

code: unknown_scoped_usage
severity: Severity.warning
message: A provider was used, but could not find the associated `ref`.
test/lints/unknown_scoped_usage.dart:36:16

```dart
  // If passed as widget constructor parameter, it's OK
  // expect_lint: unknown_scoped_usage
  RandomObject(>>>scopedProvider<<<);
  MyWidget(scopedProvider);
}
```
