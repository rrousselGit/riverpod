## 2.1.1 - 2023-04-24

- `riverpod` upgraded to `2.3.6`

## 2.1.0 - 2023-04-18

- Added support for `Raw` typedef in the return value of providers.
  This can be used to disable the conversion of Futures/Streams into AsyncValues
  ```dart
  @riverpod
  Raw<Future<int>> myProvider(...) async => ...;
  ...
  // returns a Future<int> instead of AsyncValue<int>
  Future<int> value = ref.watch(myProvider);
  ```

## 2.0.4 - 2023-04-07

- `riverpod` upgraded to `2.3.4`

## 2.0.3 - 2023-04-06

- `riverpod` upgraded to `2.3.3`

## 2.0.2 - 2023-03-13

- `riverpod` upgraded to `2.3.2`

## 2.0.1 - 2023-03-09

- `riverpod` upgraded to `2.3.1`

## 2.0.0

- Export necessary utilites for providers returning a Stream.
- Upgraded riverpod dependency

## 1.2.1

Bump minimum Riverpod version

## 1.2.0

- It is now possible to specify `@Riverpod(dependencies: [...])` to scope providers
- Marked `@Riverpod` as `@sealed`

## 1.1.1

Upgrade Riverpod to latest

## 1.1.0

Upgrade Riverpod to latest

## 1.0.6

Upgrade Riverpod to latest

## 1.0.5

Upgrade Riverpod to latest

## 1.0.4

Export more missing types

## 1.0.3

Export missing types

## 1.0.2

- Update a dependency to the latest release.

## 1.0.1

Upgrade Riverpod version

## 1.0.0

Initial release
