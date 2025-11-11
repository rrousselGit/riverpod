## Unreleased major

- Generated providers are no-longer constant
- Fix a bug when using `Class.staticVariable` as parameter to `@Riverpod(retry: ...)`
- Fix Notifiers returning a `Future<void>`
- Fix providers from part files not being generated (thanks to @tguerin)

## 3.0.3 - 2025-10-09

- `riverpod` upgraded to `3.0.3`
- `riverpod_annotation` upgraded to `3.0.3`

## 3.0.2 - 2025-10-07

- `riverpod` upgraded to `3.0.2`
- `riverpod_annotation` upgraded to `3.0.2`

## 3.0.1 - 2025-09-30

- Now supports Dart 3.7.0

## 3.0.0 - 2025-09-10

Finally, a stable release for Riverpod 3.0!

For the full changelog, check out https://riverpod.dev/docs/whats_new

## 3.0.0-dev.18 - 2025-09-09

- Fix invalid generated code when a `Notifier` uses `static const` as default value for some of its `build` parameters.
- Support records with a single value.
- Set the default for `provider_name_strip_pattern` to `Notifier$`.

## 3.0.0-dev.17 - 2025-08-01

- Fixed a conflict between public and private providers of the same name
- Allow passing `persist(key: ...)`
- Bump minimum `meta` version
- Support `@Riverpod(name: ...)`
- Add `provider_name_strip_pattern` build option
- Bump minimum `meta` version
- Support `@Riverpod(name: ...)`
- Added `MutationState.isPending/isIdle/hasError/isSuccess`
- fixes various "pause" issues
- Bump minimum `meta` version
- Added `AsyncValue.retrying`, to check when a retry is scheduled or pending
- Exposed the default retry implementation (`ProviderContainer.defaultRetry`)
- Offline's Storage now is `base` and requires overriding `deleteOutOfDate`
- Make AsyncValue.copyWithPrevious `@internal`.
  This API was not meant to be public.

## 3.0.0-dev.16 - 2025-06-20

Reworked Mutations to be independent from code-generation

## 3.0.0-dev.15 - 2025-05-04

- `riverpod` upgraded to `3.0.0-dev.15`

## 3.0.0-dev.14 - 2025-05-02

- `riverpod` upgraded to `3.0.0-dev.14`
- `riverpod_annotation` upgraded to `3.0.0-dev.14`

## 3.0.0-dev.13 - 2025-05-01

- `riverpod` upgraded to `3.0.0-dev.13`
- `riverpod_annotation` upgraded to `3.0.0-dev.13`

## 3.0.0-dev.12 - 2025-04-30

- **Breaking** Removed support for `@riverpod external int fn();`.
- **Breaking** Family arguments are no-longer available on the `Ref` object.
  The various override methods now take two parameters:

  ```dart
  @riverpod
  String example(Ref ref, int arg, {required int anotherArg}) {...}
  // ...
  exampleProvider.overrideWith(
    (ref, ({int arg, int anotherArg}) args) {

    }
  )
  ```

- Added support for mutations. See also `@mutation` for further information.
- Added support for `@Riverpod(retry: ...)`

## 2.6.5 - 2025-02-28

- `riverpod_analyzer_utils` upgraded to `0.5.10`

## 2.6.4 - 2025-01-08

Support latest analyzer

## 2.6.3 - 2024-11-18

- `riverpod_analyzer_utils` upgraded to `0.5.8`

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
- Generated providers are now always `const`.
- Added support for abstract `build` method on Notifiers:
  ```dart
  @riverpod
  class Example extends _$Example {
    @override
    int build();
  }
  ```
  This is equivalent to writing:
  ```dart
  @Riverpod(dependencies: [])
  class Example extends _$Example {
    @override
    int build() => throw UnimplementedError();
  }
  ```
- Added support for documentation and annotations on providers/parameters.
  Comments on providers and family parameters will be
  injected in the generated code, for IDE documentation
  in the relevant places.
  Annotations will be pasted over, such as to mark parameters
  as `@deprecated` everywhere.
- Updated to support latest `riverpod_analyzer_utils`

## 3.0.0-dev.11 - 2023-11-27

- `riverpod_annotation` upgraded to `3.0.0-dev.3`
- `riverpod` upgraded to `3.0.0-dev.3`

## 3.0.0-dev.10 - 2023-11-20

- `riverpod_annotation` upgraded to `3.0.0-dev.2`
- `riverpod` upgraded to `3.0.0-dev.2`

## 3.0.0-dev.9 - 2023-11-20

- Fix crash when encountering classes with a `ProviderBase` field.

## 3.0.0-dev.8 - 2023-10-30

- `riverpod_analyzer_utils` upgraded to `1.0.0-dev.0`

## 3.0.0-dev.7 - 2023-10-29

- Providers can now be generic:

  ```dart
  @riverpod
  List<T> example<T extends num>(ExampleRef<T> ref) {
    return <T>[];
  }

  @riverpod
  class ClassExample<T> extends _$ClassExample<T> {
    @override
    List<T> build() => <T>[];
  }
  ```

  Specifying type parameters works the same as specifying arguments, and
  make the generated provider a "function":

  ```dart
  ref.watch(example<int>());
  ```

- Upgraded to use Riverpod 3.0
- Fixed `family.overrideWith` missing

## 3.0.0-dev.5 - 2023-10-21

- `riverpod_analyzer_utils` upgraded to `0.4.2`

## 3.0.0-dev.4 - 2023-10-15

- Annotating a provider with `@deprecated` and a few other annotations
  also annotate the generated code accordingly (thanks to @SunlightBro)
- `provider.argument` is now a record of all arguments in a provider.

## 3.0.0-dev.3 - 2023-10-06

- `riverpod_analyzer_utils` upgraded to `0.4.1`
- `riverpod_annotation` upgraded to `2.2.0`

## 3.0.0-dev.2 - 2023-10-02

- `riverpod_analyzer_utils` upgraded to `0.4.0`

## 3.0.0-dev.1 - 2023-10-02

The code generator now supports import aliases, generated types and typedefs
as input of providers!.

This comes with a few minor restrictions:

- **Breaking**: Returning a Typedef or type Future/FutureOr/Stream is no-longer supported:

  ```dart
  typedef Example = Future<int>;

  @riverpod
  Example foo(FooRef ref) async => 0;
  ```

- **Breaking**: Arguments of the form `fn(void myParameter())`
  are no-longer supported. Instead use `fn(void Function() myParameter)`.

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

Fix typos and internal changes

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

- The generated hash function of providers is now correctly private (thanks to @westito)
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

<!-- cSpell:ignoreRegExp @\w+ -->
