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
  test/lints/provider_dependencies/missing_dependencies2.dart:64:20

  ```dart
    Ref ref,
  ) {
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:60:25

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
  test/lints/provider_dependencies/missing_dependencies2.dart:97:20

  ```dart
  ) {
    ref.watch(depProvider);
    return ref.watch(>>>generatedScopedProvider<<<);
  }
  
  ```
message: Missing dependencies: generatedScoped
test/lints/provider_dependencies/missing_dependencies2.dart:92:25

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
test/lints/provider_dependencies/missing_dependencies2.dart:123:25

```dart
}

@Riverpod(dependencies: >>>[
  // The dependency is redundant because it is not a scoped provider
  // expect_lint: provider_dependencies
  generatedRoot,
]<<<)
int watchGeneratedRootAndContainsDependency(
  Ref ref,
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: generatedRoot
test/lints/provider_dependencies/missing_dependencies2.dart:136:25

```dart
// A dependency is specified but never used

@Riverpod(dependencies: >>>[
  dep,
  // expect_lint: provider_dependencies
  generatedRoot,
]<<<)
int specifiedDependencyButNeverUsed(Ref ref) {
  ref.watch(depProvider);
```

=======

code: provider_dependencies
severity: Severity.warning
message: Unused dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:218:17

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
  test/lints/provider_dependencies/missing_dependencies2.dart:228:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:226:17

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
  test/lints/provider_dependencies/missing_dependencies2.dart:228:15

  ```dart
    @Dependencies([])
    int build(WidgetRef ref) {
      ref.watch(>>>depProvider<<<);
      return 0;
    }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:223:15

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
test/lints/provider_dependencies/missing_dependencies2.dart:246:15

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
  test/lints/provider_dependencies/missing_dependencies2.dart:251:3

  ```dart
  // expect_lint: provider_dependencies
  void fn2() {
    >>>fn<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:250:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:260:3

  ```dart
  @riverpod
  int foo(Ref ref) {
    >>>fn<<<();
    return 0;
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:258:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:278:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:275:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:317:12

  ```dart
    @override
    Widget build(BuildContext context) {
      return >>>WidgetDependencies<<<();
    }
  }
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:306:15

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
  test/lints/provider_dependencies/missing_dependencies2.dart:331:41

  ```dart
  class _Stateful3State extends State<FindStateFromClassList> {
    @override
    Widget build(BuildContext context) => >>>WidgetDependencies<<<();
  }
  
  ```
message: Missing dependencies: dep
test/lints/provider_dependencies/missing_dependencies2.dart:322:1

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
  test/lints/provider_dependencies/missing_dependencies2.dart:337:13

  ```dart
  @riverpod
  int crossFileDependency(Ref ref) {
    ref.watch(>>>anotherNonEmptyScopedProvider<<<);
    return 0;
  }
  ```
message: Missing dependencies: anotherNonEmptyScoped
test/lints/provider_dependencies/missing_dependencies2.dart:335:1

```dart

// expect_lint: provider_dependencies
>>>@riverpod<<<
int crossFileDependency(Ref ref) {
  ref.watch(anotherNonEmptyScopedProvider);
```
