# Unreleased minor

- Fix "convert to ConsumerStatefulWidget" assist on private widget
- Added `provider_dependencies` lint.
  This checks the validity of the `@Riverpod(dependencies: )` parameter, warning against
  missing or extra dependencies.
  It also contains a quick-fix to automatically update the list of `dependencies` to match.
  This lint only works with generated providers.

- Added `avoid_manual_providers_as_generated_provider_depenency` lint.
  This lint warns if a generated provider depends on a non-generated provider,
  as this would break the `provider_dependencies` lint.

- Fix exception thrown when the analyzed file has some syntax errors.

# 1.0.1

- Fixed an exception thrown when a file contains `fn?.call()`
- Fix `generator_class_extends` on private classes incorrectly
  expecting the generated class to be `_$_MyClass`
- Fix `missing_provider_scope` not detecting `UncontrolledProviderScope`
- Bump minimum riverpod_analyzer_utils version

# 1.0.0

Initial release
