code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:21:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
    dep2,
  ]<<<,
)
int extraDep(Ref ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:34:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
  ]<<<,
)
int noDep(Ref ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:44:17

```dart
@Riverpod(
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
  ]<<<,
  keepAlive: false,
)
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:55:17

```dart
@Riverpod(
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
  ]<<<,
)
int noDepNoParam(Ref ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:64:43

```dart

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false, dependencies: >>>[dep]<<<)
int noDepWithoutComma(Ref ref) {
  return 0;
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: root
test/lints/provider_dependencies/unused_dependency.dart:72:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    root,
  ]<<<,
)
int rootDep(Ref ref) => 0;
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:79:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[dep]<<<)
class StateNotFound extends ConsumerStatefulWidget {
  @override
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:117:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[dep]<<<)
void fn() {}

```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:130:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[dep2, dep]<<<)
void secondUnused() {
  dep2Provider;
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:136:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[
  dep2,
  dep,
]<<<)
void secondUnusedWithTrailingComma() {
  dep2Provider;
```
