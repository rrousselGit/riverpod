<p align="center">
<a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>
<a href="https://www.buymeacoffee.com/remirousselet" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="25px"></a>

<p align="center">
<img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

</p>

---

A command line for Riverpod, to help upgrade to newer versions of Riverpod.

## Installation

To install the migration tool, run:

```sh
dart pub global activate riverpod_cli
```

## Usage

To easily upgrade your Riverpod version:

- open in a terminal the project you want to migrate.
  You should be located in the same folder than the project's `pubspec.yaml` .
- Make sure that your code has no analysis errors otherwise the migration will have trouble running.
- run:
  ```sh
  riverpod migrate
  ```

One example would be:

```diff
- import 'package:riverpod/all.dart';
+ import 'package:riverpod/riverpod.dart';
```

You can then press `y` to accept the change or `n` to reject it.
