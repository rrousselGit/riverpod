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
test/lints/scoped_providers_should_specify_dependencies.dart:82:9

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
test/lints/scoped_providers_should_specify_dependencies.dart:107:7

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
test/lints/scoped_providers_should_specify_dependencies.dart:132:9

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
test/lints/scoped_providers_should_specify_dependencies.dart:171:11

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
test/lints/scoped_providers_should_specify_dependencies.dart:185:13

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
test/lints/scoped_providers_should_specify_dependencies.dart:201:7

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
test/lints/scoped_providers_should_specify_dependencies.dart:217:11

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
test/lints/scoped_providers_should_specify_dependencies.dart:236:9

```dart
            .overrideWith(() => throw UnimplementedError()),
        // expect_lint: scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```
