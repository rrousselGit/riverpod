code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:20:19

```dart
  ref.read(legacy(list));
  // expect_lint: provider_parameters
  ref.read(legacy(>>>[42]<<<));
  ref.listen(legacy(42), (prev, next) {});
  // expect_lint: provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:23:21

```dart
  ref.listen(legacy(42), (prev, next) {});
  // expect_lint: provider_parameters
  ref.listen(legacy(>>>[42]<<<), (prev, next) {});

  ref.watch(legacy(42));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:27:20

```dart
  ref.watch(legacy(42));
  // expect_lint: provider_parameters
  ref.watch(legacy(>>>[42]<<<));
  // expect_lint: provider_parameters
  ref.watch(legacy({'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:29:20

```dart
  ref.watch(legacy([42]));
  // expect_lint: provider_parameters
  ref.watch(legacy(>>>{'string': 42}<<<));
  // expect_lint: provider_parameters
  ref.watch(legacy({42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:31:20

```dart
  ref.watch(legacy({'string': 42}));
  // expect_lint: provider_parameters
  ref.watch(legacy(>>>{42}<<<));
  ref.watch(legacy(const [42]));
  ref.watch(legacy(const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:37:20

```dart
  ref.watch(legacy(null));
  // expect_lint: provider_parameters
  ref.watch(legacy(>>>Object()<<<));
  ref.watch(legacy(const Object()));
  ref.watch(legacy(FreezedExample()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:44:22

```dart

  // expect_lint: provider_parameters
  ref.watch(provider(>>>() {}<<<));
  ref.watch(provider(fn));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:50:20

```dart
  ref.watch(legacy(const ClassThatOverridesEqual()));
  // expect_lint: provider_parameters
  ref.watch(legacy(>>>Factory.bar()<<<));
  ref.watch(legacy(const Factory.bar()));
  ref.watch(legacy(Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:57:38

```dart
  ref.watch(generatorProvider(value: 42));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>[42]<<<));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:59:38

```dart
  ref.watch(generatorProvider(value: [42]));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>{'string': 42}<<<));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: {42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:61:38

```dart
  ref.watch(generatorProvider(value: {'string': 42}));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>{42}<<<));
  ref.watch(generatorProvider(value: const [42]));
  ref.watch(generatorProvider(value: const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:67:38

```dart
  ref.watch(generatorProvider(value: null));
  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>Object()<<<));
  ref.watch(generatorProvider(value: const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:74:38

```dart

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>Bar()<<<));
  ref.watch(generatorProvider(value: const Bar()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:78:38

```dart

  // expect_lint: provider_parameters
  ref.watch(generatorProvider(value: >>>Factory.bar()<<<));
  ref.watch(generatorProvider(value: const Factory.bar()));
  ref.watch(generatorProvider(value: Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:115:21

```dart
    ref.read(legacy(42));
    // expect_lint: provider_parameters
    ref.read(legacy(>>>[42]<<<));
    ref.listen(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:118:23

```dart
    ref.listen(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
    ref.listen(legacy(>>>[42]<<<), (prev, next) {});
    ref.listenManual(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:121:29

```dart
    ref.listenManual(legacy(42), (prev, next) {});
    // expect_lint: provider_parameters
    ref.listenManual(legacy(>>>[42]<<<), (prev, next) {});

    ref.watch(legacy(42));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:126:22

```dart
    ref.read(legacy(list));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>[42]<<<));
    // expect_lint: provider_parameters
    ref.watch(legacy({'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:128:22

```dart
    ref.watch(legacy([42]));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>{'string': 42}<<<));
    // expect_lint: provider_parameters
    ref.watch(legacy({42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:130:22

```dart
    ref.watch(legacy({'string': 42}));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>{42}<<<));
    ref.watch(legacy(const [42]));
    ref.watch(legacy(const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:136:22

```dart
    ref.watch(legacy(null));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>Object()<<<));
    ref.watch(legacy(const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:142:22

```dart
    ref.watch(legacy(const ClassThatOverridesEqual()));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>Bar()<<<));
    ref.watch(legacy(const Bar()));
    // expect_lint: provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:145:22

```dart
    ref.watch(legacy(const Bar()));
    // expect_lint: provider_parameters
    ref.watch(legacy(>>>Factory.bar()<<<));
    ref.watch(legacy(const Factory.bar()));
    ref.watch(legacy(Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:152:40

```dart
    ref.watch(generatorProvider(value: 42));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>[42]<<<));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:154:40

```dart
    ref.watch(generatorProvider(value: [42]));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>{'string': 42}<<<));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: {42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:156:40

```dart
    ref.watch(generatorProvider(value: {'string': 42}));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>{42}<<<));
    ref.watch(generatorProvider(value: const [42]));
    ref.watch(generatorProvider(value: const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:162:40

```dart
    ref.watch(generatorProvider(value: null));
    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>Object()<<<));
    ref.watch(generatorProvider(value: const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:169:40

```dart

    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>Bar()<<<));
    ref.watch(generatorProvider(value: const Bar()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:173:40

```dart

    // expect_lint: provider_parameters
    ref.watch(generatorProvider(value: >>>Factory.bar()<<<));
    ref.watch(generatorProvider(value: const Factory.bar()));
    ref.watch(generatorProvider(value: Factory.foo()));
```
