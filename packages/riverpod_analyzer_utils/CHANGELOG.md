## Unreleased build

- Bump minimum `meta` version
- Support `@Riverpod(name: ...)`

## 1.0.0-dev.3 - 2025-06-20

Reworked annotations. The old annotation logic has been removed.

## 1.0.0-dev.2 - 2025-04-30

- **Breaking**: Rewrote all RiverpodAst nodes to instead be extensions on `AstNodes`.
  Too many changes to detail everything. I'm the only one who uses this package anyway.
  If you're reading this, have a nice day!
- Added support for parsing `@mutation`

## 1.0.0-dev.1 - 2023-11-20

- **Breaking** `LegacyProviderDeclarationElement.providerType` is now nullable.
- Fix crash when parsing classes with a `ProviderBase` field.

## 1.0.0-dev.0 - 2023-10-30

- Added `GeneratorProviderDeclarationElement.isFamily`

## 0.5.10 - 2025-02-28

Upgrade dependencies

## 0.5.9 - 2025-01-08

Support latest analyzer

## 0.5.8 - 2024-11-18

- Fixed analyzer to correctly detect nested RefInvocations when used as parameters (e.g., ref.watch(provider(ref.watch(...)))). This improves the accuracy of the analyzer's error detection for complex provider compositions. (thanks to @josh-burton)

## 0.5.7 - 2024-10-27

- Support latest custom_lint

## 0.5.6 - 2024-10-22

- Support analyzer >=6.7.0 <7.0.0
  This should make it compatible with Flutter's stable channel.

## 0.5.5 - 2024-10-12

Bumped minimum analyzer to 6.9.0

## 0.5.4 - 2024-08-15

Bump custom_lint

## 0.5.3 - 2024-05-14

- Correctly set minimum support analyzer version to 6.5.0

## 0.5.2 - 2024-05-14 (retracted)

- Support analyzer 6.5.0

## 0.5.1 - 2024-02-04

- Bumped `custom_lint` version

## 0.5.0 - 2023-11-20

- **Breaking** `LegacyProviderDeclarationElement.providerType` is now nullable.
- Fix crash when parsing classes with a `ProviderBase` field.

## 0.4.3 - 2023-10-28

- Added `GeneratorProviderDeclarationElement.isFamily`

## 0.4.1 - 2023-10-06

- Added type checkers for AsyncValue and subclasses.

## 0.4.0 - 2023-10-02

- Correctly parse import aliases when used inside `ref.watch(<...>)`
- Fixed `refInvocations` not getting parsed for generated providers with arguments.

## 0.3.3 - 2023-08-16

- Support both analyzer 5.12.0 and analyzer 6.0.0

## 0.3.2 - 2023-08-03

Support analyzer 6.0.0

## 0.3.1 - 2023-05-12

- Upgrade `custom_lint_core` to 0.4.0
- Upgrade `analyzer` to 5.12.0

## 0.3.0 - 2023-04-18

- Added `DartType.isRaw` extension property for checking if a type is from a `Raw` typedef.
- Added `isFromRiverpodAnnotation` type checker.

## 0.2.1 - 2023-04-07

- Handle cascade operators in ref expressions
- Fix ref.watch/read/... not being decoded inside Notifier methods of generated providers.

## 0.2.0 - 2023-03-13

- Added `providerForType` TypeChecker for `ProviderFor` annotation
- Generated providers inside `.g.dart` no-longer are incorrectly parsed as legacy providers.
- Fixed "type 'SimpleIdentifierImpl' is not a subtype of type 'PropertyAccess' in type cast"

## 0.1.4 - 2023-03-10

- Fixed an `Unsupported operation: Unknown type SimpleIdentifierImpl` crash

## 0.1.3 - 2023-03-09

Upgrade dependencies

## 0.1.2 - 2023-03-09

Upgrade dependencies

## 0.1.1

Generated declarations now have a `needsOverride` and `providerELement.isScoped` property respecting
the `@riverpod external int value()` syntax.

## 0.1.0

- Decode generated StreamProviders.

- Upcast `ClassBasedProviderDeclaration.providerElement` &
  `FunctionalProviderDeclaration.providerElement` to their respective element type.

- Change error handling mechanism (no more exceptions)

- Parse `ProviderContainerInstanceCreationExpression` and `ProviderScopeInstanceCreationExpression`.

- Fix exception when riverpod_lint analyzes files before riverpod_generator runs

## 0.0.2

- Fix crash when parsing async generated providers
- Add `uncontrolledProviderScopeType`

## 0.0.1

- Initial version.
