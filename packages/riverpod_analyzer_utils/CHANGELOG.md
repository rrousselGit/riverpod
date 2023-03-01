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
