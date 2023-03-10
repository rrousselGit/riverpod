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
