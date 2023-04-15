import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:riverpod_cli/src/migrate/notifiers.dart';
import 'package:test/test.dart';

import 'goldens.dart';

void main() {
  group('notifiers', () {
    Future<void> testNotifier(
      String type,
      VersionConstraint versionConstraint,
    ) async {
      final sourceFile =
          await fileContextForInput('./fixtures/notifiers/input/$type.dart');
      final expected =
          File('./fixtures/notifiers/golden/$type.dart').readAsStringSync();

      await expectSuggestorGeneratesFormattedPatches(
        RiverpodNotifierChangesMigrationSuggestor(versionConstraint),
        sourceFile,
        expected,
      );
    }

    Future<void> testAlreadyMigrated(
      String type,
      VersionConstraint versionConstraint,
    ) async {
      final sourceFile =
          await fileContextForInput('./fixtures/notifiers/golden/$type.dart');
      final expected =
          File('./fixtures/notifiers/golden/$type.dart').readAsStringSync();

      await expectSuggestorGeneratesFormattedPatches(
        RiverpodNotifierChangesMigrationSuggestor(versionConstraint),
        sourceFile,
        expected,
      );
    }

    test('ChangeNotifier', () async {
      await testNotifier(
        'change_notifier_provider',
        VersionConstraint.parse('^0.13.0'),
      );
    });

    test('StateNotifier', () async {
      await testNotifier(
        'state_notifier_provider',
        VersionConstraint.parse('^0.13.0'),
      );
    });

    test('StateProvider', () async {
      await testNotifier(
        'state_provider',
        VersionConstraint.parse('^0.13.0'),
      );
    });

    group('Already Migrated', () {
      test('ChangeNotifier', () async {
        await testAlreadyMigrated(
          'change_notifier_provider',
          VersionConstraint.parse('^0.14.0'),
        );
      });

      test('StateNotifier', () async {
        await testAlreadyMigrated(
          'state_notifier_provider',
          VersionConstraint.parse('^0.14.0'),
        );
      });

      test('StateProvider', () async {
        await testAlreadyMigrated(
          'state_provider',
          VersionConstraint.parse('^0.14.0'),
        );
      });
    });
  });
}
