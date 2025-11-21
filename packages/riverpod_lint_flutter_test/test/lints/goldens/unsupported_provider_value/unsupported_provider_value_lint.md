code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:13:17

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
MyStateNotifier >>>stateNotifier<<<(Ref ref) => MyStateNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:17:25

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
Future<MyStateNotifier> >>>asyncStateNotifier<<<(Ref ref) async {
  return MyStateNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:23:7

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
class >>>StateNotifierClass<<< extends _$StateNotifierClass {
  MyStateNotifier build() => MyStateNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:29:25

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
Future<MyStateNotifier> >>>stateNotifierAsync<<<(Ref ref) async => MyStateNotifier();

// Regression tests for https://github.com/rrousselGit/riverpod/issues/2302
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:51:7

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
class >>>StateNotifierClassAsync<<< extends _$StateNotifierClassAsync {
  Future<MyStateNotifier> build() async => MyStateNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using ChangeNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<ChangeNotifier>.
message: The riverpod_generator package does not support ChangeNotifier values.
test/lints/unsupported_provider_value.dart:61:18

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
MyChangeNotifier >>>changeNotifier<<<(Ref ref) => MyChangeNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using ChangeNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<ChangeNotifier>.
message: The riverpod_generator package does not support ChangeNotifier values.
test/lints/unsupported_provider_value.dart:65:7

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
class >>>ChangeNotifierClass<<< extends _$ChangeNotifierClass {
  MyChangeNotifier build() => MyChangeNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:73:12

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
MyNotifier >>>notifier<<<(Ref ref) => MyNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:77:23

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
MyAutoDisposeNotifier >>>autoDisposeNotifier<<<(Ref ref) {
  return MyAutoDisposeNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:83:7

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
class >>>NotifierClass<<< extends _$NotifierClass {
  MyNotifier build() => MyNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using AsyncNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<AsyncNotifier>.
message: The riverpod_generator package does not support AsyncNotifier values.
test/lints/unsupported_provider_value.dart:99:17

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
MyAsyncNotifier >>>asyncNotifier<<<(Ref ref) => MyAsyncNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using AsyncNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<AsyncNotifier>.
message: The riverpod_generator package does not support AsyncNotifier values.
test/lints/unsupported_provider_value.dart:103:7

```dart
@riverpod
// ignore: riverpod_lint/unsupported_provider_value
class >>>AsyncNotifierClass<<< extends _$AsyncNotifierClass {
  MyAsyncNotifier build() => MyAsyncNotifier();
}
```
