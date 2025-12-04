code: notifier_build
severity: Severity.error
message: Classes annotated by `@riverpod` must have the `build` method
test/lints/notifier_build.dart:12:7

```dart
@riverpod
// ignore: riverpod_lint/notifier_build
class >>>ExampleProvider1<<< extends _$ExampleProvider1 {}

@riverpod
```
