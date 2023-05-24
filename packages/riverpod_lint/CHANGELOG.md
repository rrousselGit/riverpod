## Unreleased minor

- `avoid_public_notifier_properties` no-longer warns against public setters (thanks to @skreborn)

## 1.3.2 - 2023-05-12

- Upgrade `analyzer` to 5.12.0
- Upgrade `custom_lint_builder` to 0.4.0

## 1.3.1 - 2023-04-24

- `riverpod` upgraded to `2.3.6`

## 1.3.0 - 2023-04-18

- Added support for `Raw` typedef in the return value of providers.
  This can be used to silence `unsupported_provider_value` when a provider knowingly
  returns an unsupported object.

  ```dart
  // Will not trigger unsupported_provider_value
  @riverpod
  Raw<MyChangeNotifier> myProvider(...) => MyChangeNotifier();
  ```

- Improved documentation of `avoid_public_notifier_properties`

## 1.2.0 - 2023-04-08

- Added `avoid_public_notifier_properties` lint.
  This warns if a Notifier/AsyncNotifier contains any form of public state
  outside the `state` property.
- Added assists for converting widgets to HookWidget/HookConsumerWidget (thanks to @K9i-0)

## 1.1.8 - 2023-04-07

- Disable `unsupported_provider_value` when a notifier returns "this"
- Fix scoped_providers_should_specify_dependencies incorrectly triggering on functions other than "main"
- Handle cascade operators in ref expressions
- Fix `provider_dependencies` not considering dependencies inside methods
  other than `build` of a notifier.

## 1.1.7 - 2023-04-06

- Fix typo in the name of the lint `avoid_manual_providers_as_generated_provider_dependency` (thanks to @mafreud)

## 1.1.6 - 2023-03-13

- No-longer throw "Bad state: Too many elements"
- Fixed "type 'SimpleIdentifierImpl' is not a subtype of type 'PropertyAccess' in type cast"

## 1.1.5 - 2023-03-10

- `riverpod_analyzer_utils` upgraded to `0.1.4`

## 1.1.4 - 2023-03-09

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

- Added `avoid_manual_providers_as_generated_provider_dependency` lint.
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
