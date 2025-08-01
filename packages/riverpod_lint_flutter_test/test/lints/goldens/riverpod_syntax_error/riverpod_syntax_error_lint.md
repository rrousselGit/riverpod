code: riverpod_syntax_error
severity: Severity.error
message: Classes annotated with @riverpod cannot be abstract.
test/lints/riverpod_syntax_error.dart:7:1

```dart

// expect_lint: riverpod_syntax_error
>>>@riverpod
abstract class ExampleProvider1 extends _$ExampleProvider1 {
  int build() => 0;
}<<<
```
