## 2.6.2 - 2024-10-27

- `riverpod_analyzer_utils` upgraded to `0.5.7`

## 2.6.1 - 2024-10-22

- Support analyzer >=6.7.0 <7.0.0
  This should make it compatible with Flutter's stable channel.

## 2.6.0 - 2024-10-20

- Deprecated the generated `Ref` subclasses.
  Instead of:
  ```dart
  @riverpod
  Model foo(FooRef ref) => ..
  ```
  Do:
  ```dart
  @riverpod
  Model foo(Ref ref) => ..
  ```

## 2.4.4 - 2024-10-12

- `@Riverpod(dependencies: [...])` now respects `build.yaml` options

## 2.4.3 - 2024-08-15

- `riverpod_analyzer_utils` upgraded to `0.5.4`

## 2.4.2 - 2024-05-14

- Correctly set minimum support analyzer version to 6.5.0

## 2.4.1 - 2024-05-14 (retracted)

- Support analyzer 6.5.0

## 2.4.0 - 2024-03-10

- Adds `provider_name_prefix` and `provider_family_name_prefix` to `build.yaml`. (thanks to @ValentinVignal)

## 2.3.11 - 2024-02-04

- `riverpod_analyzer_utils` upgraded to `0.5.1`

## 2.3.10 - 2024-02-03

- Improved error handling if:
  - a Notifier has no default constructor
  - a Notifier has has a default constructor but with required parameters
  - a Notifier is abstract

## 2.3.9 - 2023-11-27

- `riverpod_annotation` upgraded to `2.3.3`
- `riverpod` upgraded to `2.4.9`

## 2.3.8 - 2023-11-20

- `riverpod_annotation` upgraded to `2.3.2`
- `riverpod` upgraded to `2.4.8`

## 2.3.7 - 2023-11-20

- Fix crash when encountering classes with a `ProviderBase` field.

## 2.3.6 - 2023-11-13

- Fix typos and internal changes

## 2.3.5 - 2023-10-21

- `riverpod_analyzer_utils` upgraded to `0.4.1`

## 2.3.4 - 2023-10-19 (retracted)

- `riverpod_analyzer_utils` upgraded to `0.4.1`

## 2.3.3 - 2023-09-27

- `riverpod_analyzer_utils` upgraded to `0.3.4`
- `riverpod_annotation` upgraded to `2.1.6`

## 2.3.2 - 2023-09-04

- Disable `invalid_use_of_visible_for_testing_member` in generated files

## 2.3.1 - 2023-08-28

- `riverpod_annotation` upgraded to `2.1.4`

## 2.3.0 - 2023-08-28

- The "ref" object now contains the provider parameters too.
  This enabled `provider.overrideWith` to use the provider arguments:
  ```dart
  @riverpod
  int example(ExampleRef ref, {int? id}) { /* */ }
  // ...
  exampleProvider.overrideWith(
    (ref) {
      print(ref.id);
    }
  )
  ```
- Fix all `provider.overrideWith` causing a cast error if the notifier
  receives arguments.

## 2.2.6 - 2023-08-16

- Support both analyzer 5.12.0 and analyzer 6.0.0

## 2.2.5 - 2023-08-03

Support analyzer 6.0.0

## 2.2.4 - 2023-07-25

Disable all lints in generated files.

## 2.2.3 - 2023-05-12

- `riverpod_analyzer_utils` upgraded to `0.3.1`

## 2.2.2 - 2023-05-12

- Fix an issue where specifying a dependency on a provider declared in a
  different file could cause a missing import.

## 2.2.1 - 2023-04-24

- `riverpod_annotation` upgraded to `2.1.1`

## 2.2.0 - 2023-04-18

- Added support for `Raw` typedef in the return value of providers.
  This can be used to disable the conversion of Futures/Streams into AsyncValues
  ```dart
  @riverpod
  Raw<Future<int>> myProvider(...) async => ...;
  ...
  // returns a Future<int> instead of AsyncValue<int>
  Future<int> value = ref.watch(myProvider);
  ```

## 2.1.6 - 2023-04-07

- If a provider has an empty list of dependencies, the generated list is now `const`
  (thanks to @K9i-0)

## 2.1.5 - 2023-04-06

- `riverpod_annotation` upgraded to `2.0.3`

## 2.1.4 - 2023-03-13

- `riverpod_analyzer_utils` upgraded to `0.2.0`
- `riverpod_annotation` upgraded to `2.0.2`

## 2.1.3 - 2023-03-10

- Fixed InconsistentAnalysisException
- Fixed an `Unsupported operation: Unknown type SimpleIdentifierImpl` crash

## 2.1.2 - 2023-03-09

- `riverpod_analyzer_utils` upgraded to `0.1.3`

## 2.1.1 - 2023-03-09

- `riverpod_analyzer_utils` upgraded to `0.1.2`

## 2.1.0 - 2023-03-09

- Added support for configuring the name of providers with parameters ("families") (thanks to @K9i-0)

- Deprecate the (new) shorthand syntax for scoping provider using the `external`
  keyword. That syntax unfortunately does not work on web and therefore will be removed.

## 2.0.0

- Add support for returning a `Stream` inside providers.
  This is equivalent to creating a `StreamProvider` using the "old" syntax.
- Bump minimum riverpod_analyzer_utils version
- Fix exception thrown when the analyzed file has some syntax errors.

## 1.2.0

- It is now possible to specify `@Riverpod(dependencies: [...])` to scope providers
- Marked `@Riverpod` as `@sealed`

## 1.1.1

Upgrade Riverpod to latest

## 1.1.0

- The generated hash function of providers is now correctluy private (thanks to @westito)
- Allow customizing the name of the generated providers (thanks to @trejdych)
- Update dependencies.

## 1.0.6

Upgrade Riverpod to latest

## 1.0.5

- Upgrade Riverpod and annotation package to latest

## 1.0.4

- Update dependencies.

## 1.0.4

- Update dependencies.

## 1.0.2

- Update a dependency to the latest release.

## 1.0.1

Fix version conflict with Riverpod

## 1.0.0

Initial release
