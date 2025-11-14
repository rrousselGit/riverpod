code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:20:19

```dart
  ref.read(legacy(list));
  // ignore: riverpod_lint/provider_parameters
  ref.read(legacy(>>>[42]<<<));
  ref.listen(legacy(42), (prev, next) {});
  // ignore: riverpod_lint/provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:23:21

```dart
  ref.listen(legacy(42), (prev, next) {});
  // ignore: riverpod_lint/provider_parameters
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
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(>>>[42]<<<));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy({'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:29:20

```dart
  ref.watch(legacy([42]));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(>>>{'string': 42}<<<));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy({42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:31:20

```dart
  ref.watch(legacy({'string': 42}));
  // ignore: riverpod_lint/provider_parameters
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
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(>>>Object()<<<));
  ref.watch(legacy(const Object()));
  ref.watch(legacy(FreezedExample()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:45:22

```dart

  // ignore: riverpod_lint/provider_parameters
  ref.watch(provider(>>>() {}<<<));
  ref.watch(provider(fn));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:51:20

```dart
  ref.watch(legacy(const ClassThatOverridesEqual()));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(legacy(>>>Factory.bar()<<<));
  ref.watch(legacy(const Factory.bar()));
  ref.watch(legacy(Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:58:38

```dart
  ref.watch(generatorProvider(value: 42));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>[42]<<<));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:60:38

```dart
  ref.watch(generatorProvider(value: [42]));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>{'string': 42}<<<));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: {42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:62:38

```dart
  ref.watch(generatorProvider(value: {'string': 42}));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>{42}<<<));
  ref.watch(generatorProvider(value: const [42]));
  ref.watch(generatorProvider(value: const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:68:38

```dart
  ref.watch(generatorProvider(value: null));
  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>Object()<<<));
  ref.watch(generatorProvider(value: const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:75:38

```dart

  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>Bar()<<<));
  ref.watch(generatorProvider(value: const Bar()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:79:38

```dart

  // ignore: riverpod_lint/provider_parameters
  ref.watch(generatorProvider(value: >>>Factory.bar()<<<));
  ref.watch(generatorProvider(value: const Factory.bar()));
  ref.watch(generatorProvider(value: Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:116:21

```dart
    ref.read(legacy(42));
    // ignore: riverpod_lint/provider_parameters
    ref.read(legacy(>>>[42]<<<));
    ref.listen(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:119:23

```dart
    ref.listen(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
    ref.listen(legacy(>>>[42]<<<), (prev, next) {});
    ref.listenManual(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:122:29

```dart
    ref.listenManual(legacy(42), (prev, next) {});
    // ignore: riverpod_lint/provider_parameters
    ref.listenManual(legacy(>>>[42]<<<), (prev, next) {});

    ref.watch(legacy(42));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:127:22

```dart
    ref.read(legacy(list));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>[42]<<<));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy({'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:129:22

```dart
    ref.watch(legacy([42]));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>{'string': 42}<<<));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy({42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:131:22

```dart
    ref.watch(legacy({'string': 42}));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>{42}<<<));
    ref.watch(legacy(const [42]));
    ref.watch(legacy(const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:137:22

```dart
    ref.watch(legacy(null));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>Object()<<<));
    ref.watch(legacy(const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:145:22

```dart
    ref.watch(legacy(const IndirectEqual()));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>Bar()<<<));
    ref.watch(legacy(const Bar()));
    // ignore: riverpod_lint/provider_parameters
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:148:22

```dart
    ref.watch(legacy(const Bar()));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(legacy(>>>Factory.bar()<<<));
    ref.watch(legacy(const Factory.bar()));
    ref.watch(legacy(Factory.foo()));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:155:40

```dart
    ref.watch(generatorProvider(value: 42));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>[42]<<<));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:157:40

```dart
    ref.watch(generatorProvider(value: [42]));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>{'string': 42}<<<));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: {42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:159:40

```dart
    ref.watch(generatorProvider(value: {'string': 42}));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>{42}<<<));
    ref.watch(generatorProvider(value: const [42]));
    ref.watch(generatorProvider(value: const {'string': 42}));
```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:165:40

```dart
    ref.watch(generatorProvider(value: null));
    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>Object()<<<));
    ref.watch(generatorProvider(value: const Object()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:174:40

```dart

    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>Bar()<<<));
    ref.watch(generatorProvider(value: const Bar()));

```

=======

code: provider_parameters
severity: Severity.warning
message: Providers parameters should have a consistent ==. Meaning either the values should be cached, or the parameters should override ==
test/lints/provider_parameters.dart:178:40

```dart

    // ignore: riverpod_lint/provider_parameters
    ref.watch(generatorProvider(value: >>>Factory.bar()<<<));
    ref.watch(generatorProvider(value: const Factory.bar()));
    ref.watch(generatorProvider(value: Factory.foo()));
```
