import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_cli/src/migrate/unified_syntax.dart';
import 'package:test/test.dart';

import 'goldens.dart';

void main() {
  group('Unified Syntax', () {
    test('Migration', () async {
      final sourceFile = await fileContextForInput(
          './fixtures/unified_syntax/input/widgets.dart');
      final expected = File('./fixtures/unified_syntax/golden/widgets.dart')
          .readAsStringSync();

      await expectSuggestorSequenceGeneratesFormattedPatches(
        [
          RiverpodHooksProviderInfo(
            VersionConstraint.parse('^0.14.0'),
          ),
          RiverpodUnifiedSyntaxChangesMigrationSuggestor(
            VersionConstraint.parse('^0.14.0'),
          ),
        ],
        sourceFile,
        expected,
      );
    });

    test('Already Migrated', () async {
      final sourceFile = await fileContextForInput(
          './fixtures/unified_syntax/golden/widgets.dart');
      final expected = File('./fixtures/unified_syntax/golden/widgets.dart')
          .readAsStringSync();

      await expectSuggestorSequenceGeneratesFormattedPatches(
        [
          RiverpodHooksProviderInfo(
            VersionConstraint.parse('^1.0.0'),
          ),
          RiverpodUnifiedSyntaxChangesMigrationSuggestor(
            VersionConstraint.parse('^1.0.0'),
          ),
        ],
        sourceFile,
        expected,
      );
    });
  });
}
