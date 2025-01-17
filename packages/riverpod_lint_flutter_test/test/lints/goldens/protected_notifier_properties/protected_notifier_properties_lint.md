code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:66:34

```dart

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).>>>state<<< = 42;

    // expect_lint: protected_notifier_properties
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:69:34

```dart

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:71:35

```dart
    ref.read(aProvider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:73:39

```dart
    ref.read(a2Provider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:75:39

```dart
    ref.read(a3Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:77:39

```dart
    ref.read(a4Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:79:39

```dart
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:81:39

```dart
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:83:39

```dart
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:85:39

```dart
    ref.read(a8Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).>>>state<<<;

    // expect_lint: protected_notifier_properties
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:88:39

```dart

    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).>>>future<<<;
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).ref;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:90:39

```dart
    ref.read(a8Provider(42).notifier).future;
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).>>>ref<<<;
  }
}
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:106:34

```dart

    // expect_lint: protected_notifier_properties
    ref.read(aProvider.notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:108:35

```dart
    ref.read(aProvider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a2Provider.notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:110:39

```dart
    ref.read(a2Provider.notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a3Provider(42).notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).state++;
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:112:39

```dart
    ref.read(a3Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a4Provider(42).notifier).>>>state<<<++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:114:39

```dart
    ref.read(a4Provider(42).notifier).state++;
    // expect_lint: protected_notifier_properties
    ref.read(a5Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:116:39

```dart
    ref.read(a5Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a6Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:118:39

```dart
    ref.read(a6Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a7Provider(42).notifier).>>>state<<< = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).state = AsyncData(42);
```

=======

code: protected_notifier_properties
severity: Severity.info
message: Notifier.state should not be used outside of its own class.
test/lints/protected_notifier_properties.dart:120:39

```dart
    ref.read(a7Provider(42).notifier).state = AsyncData(42);
    // expect_lint: protected_notifier_properties
    ref.read(a8Provider(42).notifier).>>>state<<< = AsyncData(42);
  }
}
```
