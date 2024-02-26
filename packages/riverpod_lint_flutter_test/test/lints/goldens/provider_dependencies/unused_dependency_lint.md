code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:22:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
    dep2,
  ]<<<,
)
int extraDep(ExtraDepRef ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:35:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
  ]<<<,
)
int noDep(NoDepRef ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:45:17

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
test/lints/provider_dependencies/unused_dependency.dart:56:17

```dart
@Riverpod(
  // expect_lint: provider_dependencies
  dependencies: >>>[
    dep,
  ]<<<,
)
int noDepNoParam(NoDepNoParamRef ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:65:43

```dart

// expect_lint: provider_dependencies
@Riverpod(keepAlive: false, dependencies: >>>[dep]<<<)
int noDepWithoutComma(NoDepWithoutCommaRef ref) {
  return 0;
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: root
test/lints/provider_dependencies/unused_dependency.dart:73:17

```dart
  keepAlive: false,
  // expect_lint: provider_dependencies
  dependencies: >>>[
    root,
  ]<<<,
)
int rootDep(RootDepRef ref) => 0;
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:80:15

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
test/lints/provider_dependencies/unused_dependency.dart:118:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[dep]<<<)
void fn() {}

```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/unused_dependency.dart:131:15

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
test/lints/provider_dependencies/unused_dependency.dart:137:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[
  dep2,
  dep,
]<<<)
void secondUnusedWithTrailingComma() {
  dep2Provider;
```
