## Unreleased patch

Upgrade dependencies

## 1.1.3 - 2023-03-09

- Upgrade dependencies
- `riverpod_analyzer_utils` upgraded to `0.1.2`

## 1.1.2 - 2023-03-01

Fix quick-fix for provider_dependencies

## 1.1.1

- Fix false positive with `stateless_ref` lint on scoped providers
- Fix false positive with `provider_dependencies` lint on scoped providers

## 1.1.0

- Fix "convert to ConsumerStatefulWidget" assist on private widget
- Added `provider_dependencies` lint.
  This checks the validity of the `@Riverpod(dependencies: )` parameter, warning against
  missing or extra dependencies.
  It also contains a quick-fix to automatically update the list of `dependencies` to match.
  This lint only works with generated providers.

- Added `avoid_manual_providers_as_generated_provider_depenency` lint.
  This lint warns if a generated provider depends on a non-generated provider,
  as this would break the `provider_dependencies` lint.

- Added `scoped_providers_should_specify_dependencies` lint.
  This lint warns if a generated provider is overriden in a scoped ProviderScope/ProviderContainer and does not specifies `@Riverpod(dependencies: ...)`.

- Added `unsupported_provider_value` lint. This warns against
  using riverpod_generator to create a `StateNotifier` and other unsupported values.

- Fix exception thrown when the analyzed file has some syntax errors.

- Fix provider_parameters when applied on Freezed classes

- Fix exception when riverpod_lint analyzes files before riverpod_generator runs

## 1.0.1

- Fixed an exception thrown when a file contains `fn?.call()`
- Fix `generator_class_extends` on private classes incorrectly
  expecting the generated class to be `_$_MyClass`
- Fix `missing_provider_scope` not detecting `UncontrolledProviderScope`
- Bump minimum riverpod_analyzer_utils version

## 1.0.0

Initial release
