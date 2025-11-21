code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:8:8

```dart
    case AsyncValue<int?>(
      // ignore: riverpod_lint/async_value_nullable_pattern
      :>>>final value?<<<,
    ):
      print(value);
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:32:8

```dart
    case AsyncError<int?>(
      // ignore: riverpod_lint/async_value_nullable_pattern
      :>>>final value?<<<,
    ):
      print(value);
```

=======

code: async_value_nullable_pattern
severity: Severity.warning
message: Using AsyncValue(:final value?) on possibly nullable value is unsafe. Use AsyncValue(:final value, hasValue: true) instead.
test/lints/async_value_nullable_pattern.dart:37:8

```dart
    case AsyncLoading<int?>(
      // ignore: riverpod_lint/async_value_nullable_pattern
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
    // ignore: riverpod_lint/async_value_nullable_pattern
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
    // ignore: riverpod_lint/async_value_nullable_pattern
    case AsyncValue<T>(:>>>final value?<<<):
      print(value);
  }
```
