code: provider_dependencies
severity: Severity.warning
contextMessages:
  message: generatedScoped
  test/lints/provider_dependencies/missing_dependencies2.dart:36:20

  ```dart
    Ref ref,
  ) {
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:32:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:62:20

  ```dart
    Ref ref,
  ) {
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:58:25

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
  test/lints/provider_dependencies/missing_dependencies2.dart:93:20

  ```dart
  ) {
    ref.watch(depProvider);
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:88:25

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
test/lints/provider_dependencies/missing_dependencies2.dart:122:7

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
test/lints/provider_dependencies/missing_dependencies2.dart:138:7

```dart
      // generatedRoot is extra
      // expect_lint: provider_dependencies
      >>>[
        dep,
        generatedRoot,
      ]<<<,
)
int specifiedDependencyButNeverUsed(Ref ref) {
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:219:17

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
  test/lints/provider_dependencies/missing_dependencies2.dart:229:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:227:17

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
  test/lints/provider_dependencies/missing_dependencies2.dart:229:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:224:15

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
test/lints/provider_dependencies/missing_dependencies2.dart:247:15

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
  test/lints/provider_dependencies/missing_dependencies2.dart:252:3

  ```dart
  // expect_lint: provider_dependencies
  void fn2() {
    >>>fn<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:251:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:261:3

  ```dart
  @riverpod
  int foo(Ref ref) {
    >>>fn<<<();
    return 0;
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:259:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:279:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:276:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:318:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:307:15

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
  test/lints/provider_dependencies/missing_dependencies2.dart:332:41

  ```dart
  class _Stateful3State extends State<FindStateFromClassList> {
    @override
    Widget build(BuildContext context) => >>>WidgetDependencies<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:323:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:338:13

  ```dart
  @riverpod
  int crossFileDependency(Ref ref) {
    ref.watch(>>>anotherNonEmptyScopedProvider<<<);
    return 0;
  }
  ```
message: Missing dependencies: anotherNonEmptyScoped
test/lints/provider_dependencies/missing_dependencies2.dart:336:1

```dart

// expect_lint: provider_dependencies
>>>@riverpod<<<
int crossFileDependency(Ref ref) {
  ref.watch(anotherNonEmptyScopedProvider);
```
