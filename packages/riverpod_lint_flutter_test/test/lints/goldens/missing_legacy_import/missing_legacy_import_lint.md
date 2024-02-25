code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/missing_legacy_import.dart:10:11

```dart

// expect_lint: missing_legacy_import
final p = >>>StateProvider<<<((ref) => 0);

// expect_lint: missing_legacy_import
```

=======

code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/missing_legacy_import.dart:13:12

```dart

// expect_lint: missing_legacy_import
final p2 = >>>StateProvider<<<.autoDispose((ref) => 0);

// expect_lint: missing_legacy_import
```

=======

code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/missing_legacy_import.dart:16:12

```dart

// expect_lint: missing_legacy_import
final p3 = >>>ChangeNotifierProvider<<<((ref) => 0);

// expect_lint: missing_legacy_import
```

=======

code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/missing_legacy_import.dart:19:12

```dart

// expect_lint: missing_legacy_import
final p4 = >>>StateNotifierProvider<<<((ref) => 0);

// expect_lint: missing_legacy_import
```

=======

code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/missing_legacy_import.dart:22:26

```dart

// expect_lint: missing_legacy_import
class MyNotifier extends >>>StateNotifier<int><<< {
  MyNotifier() : super(0);
}
```
