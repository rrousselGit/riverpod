code: riverpod_syntax_error
severity: Severity.error
message: Classes annotated with @riverpod cannot be abstract.
test/lints/riverpod_syntax_error.dart:8:16

```dart
@riverpod
// expect_lint: riverpod_syntax_error
abstract class >>>ExampleProvider1<<< extends _$ExampleProvider1 {
  int build() => 0;
}
```
