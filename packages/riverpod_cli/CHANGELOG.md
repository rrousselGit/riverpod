# 1.0.3

Logged more errors, to help debug some potential issues

# 1.0.2

The command `riverpod migrate` will now fail if used on a project that already
uses the latest version available.

# 1.0.1

- Updated to migrate to version 1.0.1
- Fixed some issues with the migration

# 1.0.0

Updated to migrate to version 1.0.0

# 1.0.0-dev.6

Fix issues with the automatic migration of `ProviderContainer`.

# 1.0.0-dev.5

Enable debugging the command line.

# 1.0.0-dev.4

- Add codemod flags for migrate command

# 1.0.0-dev.2

- The migration now updates ScopedProvider => Provider

# 1.0.0-dev.1

- The migration now updates ProviderObserver methods to add the
  `ProviderContainer` parameter.

# 1.0.0-dev.0

- Migration for unifying syntax (riverpod 1.0.0) [RFC](https://github.com/rrousselGit/river_pod/issues/335)

# 0.0.2+2

- Fix migration for static final providers.

# 0.0.2+1

- Fix for windows paths

# 0.0.2

- Fix CHANGELOG and README

# 0.0.1

- Add migrations for notifiers
- Add migrations for imports
  - 'package:riverpod/all.dart';
  - 'package:hooks_riverpod/all.dart';
  - 'package:flutter_riverpod/all.dart';
