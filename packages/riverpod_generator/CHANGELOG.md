## 2.0.0

- Add support for returning a `Stream` inside providers.
  This is equivalent to creating a `StreamProvider` using the "old" syntax.
- Bump minimum riverpod_analyzer_utils version
- Syntax sugar for providers which _must_ be overridden is now available:

  ```dart
  @riverpod
  external int count();
  ```

  This is equivalent to writing:

  ```dart
  @riverpod
  int count(CountRef ref) => throw UnsupportedError('...');
  ```

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
