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

- Upcast `StatefulProviderDeclaratation.providerElement` &
  `StatelessProviderDeclaratation.providerElement` to their respective element type.

- Change error handling mechanism (no more exceptions)

- Parse `ProviderContainerInstanceCreationExpression` and `ProviderScopeInstanceCreationExpression`.

- Fix exception when riverpod_lint analyzes files before riverpod_generator runs

## 0.0.2

- Fix crash when parsing async generated providers
- Add `uncontrolledProviderScopeType`

## 0.0.1

- Initial version.
