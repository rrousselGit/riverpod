code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:8:10

```dart
    case AsyncValue<int?>(
        // expect_lint: async_value_nullable_pattern
        :>>>final value?<<<,
      ):
      print(value);
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:32:10

```dart
    case AsyncError<int?>(
        // expect_lint: async_value_nullable_pattern
        :>>>final value?<<<,
      ):
      print(value);
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:37:10

```dart
    case AsyncLoading<int?>(
        // expect_lint: async_value_nullable_pattern
        :>>>final value?<<<,
      ):
      print(value);
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:62:25

```dart
  switch (obj) {
    // expect_lint: async_value_nullable_pattern
    case AsyncValue<T>(:>>>final value?<<<):
      print(value);
  }
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:77:25

```dart
  switch (obj) {
    // expect_lint: async_value_nullable_pattern
    case AsyncValue<T>(:>>>final value?<<<):
      print(value);
  }
```
