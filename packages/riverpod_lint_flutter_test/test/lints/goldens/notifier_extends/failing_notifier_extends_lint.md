code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends/failing_notifier_extends.dart:6:7

```dart
@riverpod
// ignore: riverpod_lint/notifier_extends
class >>>NoExtends<<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends/failing_notifier_extends.dart:12:28

```dart
@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongExtends extends >>>AsyncNotifier<int><<< {
  int build() => 0;
}
```
