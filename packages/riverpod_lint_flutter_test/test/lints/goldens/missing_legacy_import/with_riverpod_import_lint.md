code: missing_legacy_import
severity: Severity.info
message: StateProvider/StateNotifierProvider/ChangeNotifierProvider/StateNotifier were used without importing `package:flutter_riverpod/legacy.dart`.
test/lints/missing_legacy_import/with_riverpod_import.dart:10:12

```dart

// expect_lint: missing_legacy_import
final p3 = >>>ChangeNotifierProvider<<<((ref) => 0);

final p4 = StateNotifierProvider<StateNotifier<int>, int>((ref) {
```
