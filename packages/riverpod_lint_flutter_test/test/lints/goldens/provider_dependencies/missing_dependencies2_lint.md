code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: generatedScoped
  test/lints/provider_dependencies/missing_dependencies2.dart:37:20

  ```dart
    Ref ref,
  ) {
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:33:1

```dart

// expect_lint: provider_dependencies
>>>@riverpod<<<
int watchGeneratedScopedButNoDependencies(
  Ref ref,
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: generatedScoped
  test/lints/provider_dependencies/missing_dependencies2.dart:65:20

  ```dart
    Ref ref,
  ) {
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:61:25

```dart

// expect_lint: provider_dependencies
@Riverpod(dependencies: >>>[]<<<)
int watchGeneratedScopedButEmptyDependencies(
  Ref ref,
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: generatedScoped
  test/lints/provider_dependencies/missing_dependencies2.dart:98:20

  ```dart
  ) {
    ref.watch(depProvider);
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:93:25

```dart

// expect_lint: provider_dependencies
@Riverpod(dependencies: >>>[dep]<<<)
int watchGeneratedScopedButMissingDependencies(
  Ref ref,
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: generatedRoot
test/lints/provider_dependencies/missing_dependencies2.dart:128:7

```dart
      // The dependency is redundant because it is not a scoped provider
      // expect_lint: provider_dependencies
      >>>[
    generatedRoot,
  ]<<<,
)
int watchGeneratedRootAndContainsDependency(
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: generatedRoot
test/lints/provider_dependencies/missing_dependencies2.dart:143:5

```dart
    // generatedRoot is extra
    // expect_lint: provider_dependencies
    >>>[
  dep,
  generatedRoot,
]<<<)
int specifiedDependencyButNeverUsed(Ref ref) {
  ref.watch(depProvider);
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:225:17

```dart
class MemberDependencies {
  // expect_lint: provider_dependencies
  @Dependencies(>>>[dep]<<<)
  int build() => 0;
}
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:235:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:233:17

```dart
class CanUpdateMultipleDependenciesAtOnce {
  // expect_lint: provider_dependencies
  @Dependencies(>>>[]<<<)
  int build(WidgetRef ref) {
    ref.watch(depProvider);
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:235:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:230:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[]<<<)
class CanUpdateMultipleDependenciesAtOnce {
  // expect_lint: provider_dependencies
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:253:15

```dart
// Handle identifiers with dependencies
// expect_lint: provider_dependencies
@Dependencies(>>>[dep]<<<)
void fn() {}

```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:258:3

  ```dart
  // expect_lint: provider_dependencies
  void fn2() {
    >>>fn<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:257:1

```dart

// expect_lint: provider_dependencies
>>>void fn2() {
  fn();
}<<<

@Dependencies([dep])
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:267:3

  ```dart
  @riverpod
  int foo(Ref ref) {
    >>>fn<<<();
    return 0;
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:265:1

```dart

// expect_lint: provider_dependencies
>>>@riverpod<<<
int foo(Ref ref) {
  fn();
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:285:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:282:1

```dart

// expect_lint: provider_dependencies
>>>class WidgetDependencies2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetDependencies();
  }
}<<<

@Dependencies([dep])
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:324:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:313:15

```dart

// expect_lint: provider_dependencies
@Dependencies(>>>[]<<<)
class Stateful2 extends StatefulWidget {
  const Stateful2({super.key});
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: dep
  test/lints/provider_dependencies/missing_dependencies2.dart:338:41

  ```dart
  class _Stateful3State extends State<FindStateFromClassList> {
    @override
    Widget build(BuildContext context) => >>>WidgetDependencies<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:329:1

```dart

// expect_lint: provider_dependencies
>>>class FindStateFromClassList extends StatefulWidget {
  const FindStateFromClassList({super.key});

  @override
  State<FindStateFromClassList> createState() => _Stateful3State();
}<<<

class _Stateful3State extends State<FindStateFromClassList> {
```

=======

code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: anotherNonEmptyScoped
  test/lints/provider_dependencies/missing_dependencies2.dart:344:13

  ```dart
  @riverpod
  int crossFileDependency(Ref ref) {
    ref.watch(>>>anotherNonEmptyScopedProvider<<<);
    return 0;
  }
  ```
message: Missing dependencies: anotherNonEmptyScoped
test/lints/provider_dependencies/missing_dependencies2.dart:342:1

```dart

// expect_lint: provider_dependencies
>>>@riverpod<<<
int crossFileDependency(Ref ref) {
  ref.watch(anotherNonEmptyScopedProvider);
```
