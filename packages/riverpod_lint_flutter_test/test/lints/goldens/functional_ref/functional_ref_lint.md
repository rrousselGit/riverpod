code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/functional_ref.dart:8:3

```dart
int nameless(
  // expect_lint: functional_ref
  >>>ref<<<,
) {
  return 0;
```

=======

code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/functional_ref.dart:18:34

```dart
@riverpod
// expect_lint: functional_ref
int noGenerics<A extends num, B>(>>>NoGenericsRef<<< ref) => 0;

@riverpod
```

=======

code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/functional_ref.dart:22:27

```dart
@riverpod
// expect_lint: functional_ref
int missingGenerics<A, B>(>>>MissingGenericsRef<<< ref) => 0;

@riverpod
```

=======

code: functional_ref
severity: Severity.warning
message: Functional providers must receive a ref matching the provider name as their first positional parameter.
test/lints/functional_ref/functional_ref.dart:26:22

```dart
@riverpod
// expect_lint: functional_ref
int wrongOrder<B, A>(>>>WrongOrderRef<<< ref) => 0;
```
