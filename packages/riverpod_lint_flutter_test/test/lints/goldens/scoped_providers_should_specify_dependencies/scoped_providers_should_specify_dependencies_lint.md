code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:43:7

```dart
          .overrideWith(() => throw UnimplementedError()),
      // expect_lint: scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
  );
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:67:9

```dart
        // This is not a Flutter's runApp, so the ProviderScope is considered scoped
        // expect_lint: scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:81:9

```dart
            .overrideWith(() => throw UnimplementedError()),
        // expect_lint: scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:106:7

```dart
          .overrideWith(() => throw UnimplementedError()),
      // expect_lint: scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
  );
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:130:9

```dart
            .overrideWith(() => throw UnimplementedError()),
        // expect_lint: scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:168:11

```dart
              .overrideWith(() => throw UnimplementedError()),
          // expect_lint: scoped_providers_should_specify_dependencies
          >>>rootProvider.overrideWith((ref) => 0)<<<,
        ],
        child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:182:13

```dart
                .overrideWith(() => throw UnimplementedError()),
            // expect_lint: scoped_providers_should_specify_dependencies
            >>>rootProvider.overrideWith((ref) => 0)<<<,
          ],
          child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:198:7

```dart
          .overrideWith(() => throw UnimplementedError()),
      // expect_lint: scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
    child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:214:11

```dart
              .overrideWith(() => throw UnimplementedError()),
          // expect_lint: scoped_providers_should_specify_dependencies
          >>>rootProvider.overrideWith((ref) => 0)<<<,
        ],
        child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:233:9

```dart
            .overrideWith(() => throw UnimplementedError()),
        // expect_lint: scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```
