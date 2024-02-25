code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends.dart:15:7

```dart
@riverpod
// expect_lint: notifier_extends
class >>>NoExtends<<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends.dart:21:28

```dart
@riverpod
// expect_lint: notifier_extends
class WrongExtends extends >>>AsyncNotifier<int><<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends.dart:39:44

```dart
@riverpod
// expect_lint: notifier_extends
class NoGenerics<A extends num, B> extends >>>_$NoGenerics<<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends.dart:45:37

```dart
@riverpod
// expect_lint: notifier_extends
class MissingGenerics<A, B> extends >>>_$MissingGenerics<A><<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends.dart:51:32

```dart
@riverpod
// expect_lint: notifier_extends
class WrongOrder<A, B> extends >>>_$WrongOrder<B, A><<< {
  int build() => 0;
}
```
