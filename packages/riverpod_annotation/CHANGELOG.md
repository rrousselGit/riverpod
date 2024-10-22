## 2.6.1 - 2024-10-22

- `riverpod` upgraded to `2.6.1`

## 2.6.0 - 2024-10-20

- `riverpod` upgraded to `2.6.0`

## 2.5.3 - 2024-10-12

- `riverpod` upgraded to `2.5.3`

## 2.3.5 - 2024-03-10

- `riverpod` upgraded to `2.5.1`

## 2.3.4 - 2024-02-03

- Improved `@Riverpod(dependencies: [...])` documentation.

## 2.3.3 - 2023-11-27

- `riverpod` upgraded to `2.4.9`

## 2.3.2 - 2023-11-20

- `riverpod` upgraded to `2.4.8`

## 2.3.1 - 2023-11-20

- `riverpod` upgraded to `2.4.7`

## 2.3.1 - 2023-11-13

- `riverpod` upgraded to `2.4.6`

## 2.3.0 - 2023-10-28

- Exported internal `FamilyOverride` API, for use in generated code.

## 2.2.1 - 2023-10-15

- `riverpod` upgraded to `2.4.4`

## 2.2.0 - 2023-10-06

- Exports `@internal` from `pkg:meta` for the code-generator to use.

## 2.1.6 - 2023-09-27

- `riverpod` upgraded to `2.4.1`

## 2.1.5 - 2023-09-04

- `riverpod` upgraded to `2.4.0`

## 2.1.4 - 2023-08-28

- `riverpod` upgraded to `2.3.10`

## 2.1.3 - 2023-08-28

- `riverpod` upgraded to `2.3.8`

## 2.1.2 - 2023-08-16

- `riverpod` upgraded to `2.3.7`

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

- Export necessary utilities for providers returning a Stream.
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
