## 3.0.0-dev.18 - 2025-09-09

- Handle analyzer 8.0
- Removed `avoid_manual_providers_as_generated_provider_dependency`.
  The corresponding technical limitation has been solved, so this constraint is no-longer necessary.

## 3.0.0-dev.17 - 2025-08-01

Bump minimum `meta` version

## 3.0.0-dev.16 - 2025-06-20

- `riverpod` upgraded to `3.0.0-dev.16`
- `riverpod_analyzer_utils` upgraded to `1.0.0-dev.3`

## 3.0.0-dev.15 - 2025-05-04

- `riverpod` upgraded to `3.0.0-dev.15`

## 3.0.0-dev.14 - 2025-05-02

- `riverpod` upgraded to `3.0.0-dev.14`

## 3.0.0-dev.13 - 2025-05-01

- `riverpod` upgraded to `3.0.0-dev.13`

## 3.0.0-dev.12 - 2025-04-30

- All lints/assists now automatically add the relevant imports when
  updating code.
- Updated `provider_dependencies` to support `@Dependencies`
- added `riverpod_syntax_error`, for reporting errors when the generator would throw.
- added `avoid_keep_alive_dependency_inside_auto_dispose`
- Fix `provider_parameters` for objects using mixins.

- **Breaking**: No-longer exports various providers
  from `package:riverpod`.

Various lints had their severity changed:

- `avoid_build_context_in_providers` is now an INFO
- `avoid_ref_inside_state_dispose` is now a WARNING
- `functional_ref` is now a WARNING
- `notifier_build` is now an error.
- `missing_provider_scope` is now a WARNING
- `provider_dependencies` is now a WARNING
- `scoped_providers_should_specify_dependencies` is now a WARNING
- `notifier_extends` is now a WARNING
- `provider_parameters` is now a WARNING

## 2.6.5 - 2025-02-28

Upgrade dependencies

## 2.6.4 - 2025-01-08

Support latest analyzer

## 2.6.3 - 2024-11-18

- provider_dependencies now correctly detects nested ref invocations where a dependency is used as a parameter of another dependency (thanks to @josh-burton)

## 2.6.2 - 2024-10-27

- Support latest custom_lint

## 2.6.1 - 2024-10-22

- Support analyzer >=6.7.0 <7.0.0
  This should make it compatible with Flutter's stable channel.

## 2.4.0 - 2024-10-20

- `functional_ref` and its quick-fix now expect:
  ```dart
  @riverpod
  Model foo(Ref ref) => ..
  ```

## 2.3.14 - 2024-10-12

Bump analyzer to ^6.9.0

## 2.3.13 - 2024-08-15

Bump custom_lint

## 2.3.12 - 2024-05-14

- Correctly set minimum support analyzer version to 6.5.0

## 2.3.11 - 2024-05-14 (retracted)

- Support analyzer 6.5.0

## 2.3.10 - 2024-03-10

- `riverpod` upgraded to `2.5.1`

## 2.3.9 - 2024-02-04

- Bumped `custom_lint` version

## 2.3.8 - 2024-02-03

- Fix `async_value_nullable_pattern` false positive when used with generics
  that have non-nullable type constrains.
- Add migration widget field when convert Stateless-based and
  Stateful-based to each other (thanks to @Kurogoma4D)

## 2.3.7 - 2023-11-27

- `riverpod` upgraded to `2.4.9`

## 2.3.6 - 2023-11-20

- `riverpod` upgraded to `2.4.8`

## 2.3.5 - 2023-11-20

- Fix crash when encountering classes with a `ProviderBase` field.

## 2.3.4 - 2023-11-13

- Updated `scoped_providers_should_specify_dependencies` to ignore instances of using pumpWidget in tests (thanks to @lockieRichter)

## 2.3.3 - 2023-10-28

- `riverpod` upgraded to `2.4.5`
- `riverpod_analyzer_utils` upgraded to `0.4.3`

## 2.3.2 - 2023-10-21

- `riverpod_analyzer_utils` upgraded to `0.4.2`

## 2.3.1 - 2023-10-15

- Fixed a crash when a Notifier had a getter (thanks to @charlescyt)

## 2.3.0 - 2023-10-06

- Added `async_value_nullable_pattern` lint, to warn against using `AsyncValue(:final value?)` in pattern match when `value` is possibly nullable.
- Added `protected_notifier_state` lint, which warns against using the `Notifier.state`
  property of a notifier different than the current one.
  Aka a Notifier "A" should not directly access the `state` if a Notifier "B".

## 2.2.1 - 2023-10-02

- Updated `functional_ref` and `generator_class_extends` to support providers
  with generic parameters.
- Fixed `functional_ref` throwing if a provider specifies arguments but
  incorrectly did not specify a Ref

## 2.2.0 - 2023-10-02

- Added `avoid_build_context_in_providers` (thanks to @charlescyt)
- Fixed false positive with `avoid_manual_providers_as_generated_provider_dependency` when using import aliases

## 2.1.1 - 2023-09-27

- Fixed `provider_dependencies` lint causing false positives on providers with arguments.

## 2.1.0 - 2023-09-14

- Added `notifier_build`, a lint to catch when a Notifier has no `build` method (thanks to @LeonardoRosaa)

## 2.0.4 - 2023-09-04

- `riverpod` upgraded to `2.4.0`

## 2.0.3 - 2023-08-28

- `riverpod` upgraded to `2.3.10`

## 2.0.2 - 2023-08-28

- Fixed typos in the package description (thanks to @saltedpotatos)

## 2.0.1 - 2023-08-16

- Support both analyzer 5.12.0 and analyzer 6.0.0

## 2.0.0 - 2023-08-03

- **Breaking** Renamed `generator_class_extends` to `notifier_extends`
- **Breaking** Renamed `stateless_ref` to `functional_ref` (thanks to @AhmedLSayed9)
- Added `avoid_ref_inside_state_dispose` (thanks to @LeonardoRosaa).
  This warns if a `WidgetRef` is used in `State.dispose`, which would result
  in a runtime error.
- Support analyzer 6.0.0

## 1.4.0 - 2023-07-25

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

- Fix false positive with `functional_ref` lint on scoped providers
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
  This lint warns if a generated provider is overridden in a scoped ProviderScope/ProviderContainer and does not specifies `@Riverpod(dependencies: ...)`.

- Added `unsupported_provider_value` lint. This warns against
  using riverpod_generator to create a `StateNotifier` and other unsupported values.

- Fix exception thrown when the analyzed file has some syntax errors.

- Fix provider_parameters when applied on Freezed classes

- Fix exception when riverpod_lint analyzes files before riverpod_generator runs

## 1.0.1

- Fixed an exception thrown when a file contains `fn?.call()`
- Fix `notifier_extends` on private classes incorrectly
  expecting the generated class to be `_$_MyClass`
- Fix `missing_provider_scope` not detecting `UncontrolledProviderScope`
- Bump minimum riverpod_analyzer_utils version

## 1.0.0

Initial release

<!-- cSpell:ignoreRegExp @\w+ -->
