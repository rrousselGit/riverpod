code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:13:17

```dart
@riverpod
// expect_lint: unsupported_provider_value
MyStateNotifier >>>stateNotifier<<<(StateNotifierRef ref) => MyStateNotifier();

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
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> >>>asyncStateNotifier<<<(AsyncStateNotifierRef ref) async {
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
// expect_lint: unsupported_provider_value
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
// expect_lint: unsupported_provider_value
Future<MyStateNotifier> >>>stateNotifierAsync<<<(StateNotifierAsyncRef ref) async =>
    MyStateNotifier();

```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using StateNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<StateNotifier>.
message: The riverpod_generator package does not support StateNotifier values.
test/lints/unsupported_provider_value.dart:52:7

```dart
@riverpod
// expect_lint: unsupported_provider_value
class >>>StateNotifierClassAsync<<< extends _$StateNotifierClassAsync {
  Future<MyStateNotifier> build() async => MyStateNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using ChangeNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<ChangeNotifier>.
message: The riverpod_generator package does not support ChangeNotifier values.
test/lints/unsupported_provider_value.dart:62:18

```dart
@riverpod
// expect_lint: unsupported_provider_value
MyChangeNotifier >>>changeNotifier<<<(ChangeNotifierRef ref) => MyChangeNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using ChangeNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<ChangeNotifier>.
message: The riverpod_generator package does not support ChangeNotifier values.
test/lints/unsupported_provider_value.dart:66:7

```dart
@riverpod
// expect_lint: unsupported_provider_value
class >>>ChangeNotifierClass<<< extends _$ChangeNotifierClass {
  MyChangeNotifier build() => MyChangeNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:74:12

```dart
@riverpod
// expect_lint: unsupported_provider_value
MyNotifier >>>notifier<<<(NotifierRef ref) => MyNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:78:23

```dart
@riverpod
// expect_lint: unsupported_provider_value
MyAutoDisposeNotifier >>>autoDisposeNotifier<<<(AutoDisposeNotifierRef ref) {
  return MyAutoDisposeNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using Notifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<Notifier>.
message: The riverpod_generator package does not support Notifier values.
test/lints/unsupported_provider_value.dart:84:7

```dart
@riverpod
// expect_lint: unsupported_provider_value
class >>>NotifierClass<<< extends _$NotifierClass {
  MyNotifier build() => MyNotifier();
}
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using AsyncNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<AsyncNotifier>.
message: The riverpod_generator package does not support AsyncNotifier values.
test/lints/unsupported_provider_value.dart:100:17

```dart
@riverpod
// expect_lint: unsupported_provider_value
MyAsyncNotifier >>>asyncNotifier<<<(AsyncNotifierRef ref) => MyAsyncNotifier();

@riverpod
```

=======

code: unsupported_provider_value
severity: Severity.info
correctionMessage: If using AsyncNotifier even though riverpod_generator does not support it, you can wrap the type in "Raw" to silence the warning. For example by returning Raw<AsyncNotifier>.
message: The riverpod_generator package does not support AsyncNotifier values.
test/lints/unsupported_provider_value.dart:104:7

```dart
@riverpod
// expect_lint: unsupported_provider_value
class >>>AsyncNotifierClass<<< extends _$AsyncNotifierClass {
  MyAsyncNotifier build() => MyAsyncNotifier();
}
```
