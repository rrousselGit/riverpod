code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:16:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  // Public setters are OK
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:24:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int publicProperty = 0;<<<

  @protected
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:50:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:60:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:70:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:80:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:90:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```
