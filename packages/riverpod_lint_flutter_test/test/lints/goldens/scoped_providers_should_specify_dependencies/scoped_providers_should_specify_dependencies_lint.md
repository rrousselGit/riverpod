code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:45:7

```dart
      ),
      // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
  );
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:71:9

```dart
        // This is not a Flutter's runApp, so the ProviderScope is considered scoped
        // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:98:7

```dart
      ),
      // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
  );
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:150:13

```dart
            ),
            // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
            >>>rootProvider.overrideWith((ref) => 0)<<<,
          ],
          child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:167:7

```dart
      ),
      // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
      >>>rootProvider.overrideWith((ref) => 0)<<<,
    ],
    child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:184:11

```dart
          ),
          // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
          >>>rootProvider.overrideWith((ref) => 0)<<<,
        ],
        child: Container(),
```

=======

code: scoped_providers_should_specify_dependencies
severity: Severity.warning
message: Providers which are overridden in a non-root ProviderContainer/ProviderScope should specify dependencies.
test/lints/scoped_providers_should_specify_dependencies.dart:204:9

```dart
        ),
        // ignore: riverpod_lint/scoped_providers_should_specify_dependencies
        >>>rootProvider.overrideWith((ref) => 0)<<<,
      ],
      child: Container(),
```
