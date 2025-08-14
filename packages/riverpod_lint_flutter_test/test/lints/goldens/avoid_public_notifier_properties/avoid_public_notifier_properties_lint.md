code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:33:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  // Public setters are OK
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:41:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int publicProperty = 0;<<<

  @protected
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:67:3

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

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:100:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```

=======

code: avoid_public_notifier_properties
severity: Severity.info
message: Notifiers should not have public properties/getters. Instead, all their public API should be exposed through the `state` property.
test/lints/avoid_public_notifier_properties.dart:113:3

```dart

  // expect_lint: avoid_public_notifier_properties
  >>>int get publicGetter => _privateGetter;<<<

  @override
```
