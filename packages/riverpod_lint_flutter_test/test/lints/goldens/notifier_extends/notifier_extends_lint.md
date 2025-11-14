code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends/notifier_extends.dart:26:44

```dart
@riverpod
// ignore: riverpod_lint/notifier_extends
class NoGenerics<A extends num, B> extends >>>_$NoGenerics<<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends/notifier_extends.dart:32:37

```dart
@riverpod
// ignore: riverpod_lint/notifier_extends
class MissingGenerics<A, B> extends >>>_$MissingGenerics<A><<< {
  int build() => 0;
}
```

=======

code: notifier_extends
severity: Severity.warning
message: Classes annotated by @riverpod must extend _$ClassName
test/lints/notifier_extends/notifier_extends.dart:38:32

```dart
@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongOrder<A, B> extends >>>_$WrongOrder<B, A><<< {
  int build() => 0;
}
```
