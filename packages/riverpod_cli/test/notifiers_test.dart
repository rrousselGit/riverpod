import 'dart:io';

import 'package:codemod_riverpod/codemod_riverpod.dart';
import 'package:test/test.dart';

import 'goldens.dart';

void main() {
  group('notifiers', () {
    Future<void> testNotifier(String type) async {
      final sourceFile =
          await fileContextForInput('./test/files/notifiers/input/$type.dart');
      final expected =
          File('./test/files/notifiers/golden/$type.dart').readAsStringSync();
      expectSuggestorGeneratesFormattedPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    }

    Future<void> testNotifierNoOp(String type) async {
      final sourceFile =
          await fileContextForInput('./test/files/notifiers/golden/$type.dart');
      final expected =
          File('./test/files/notifiers/golden/$type.dart').readAsStringSync();
      expectSuggestorGeneratesFormattedPatches(
          RiverpodNotifierChangesMigrationSuggestor(), sourceFile, expected);
    }

    test('ChangeNotifier', () async {
      await testNotifier('change_notifier_provider');
    });

    test('StateNotifier', () async {
      await testNotifier('state_notifier_provider');
    });

    test('StateProvider', () async {
      await testNotifier('state_provider');
    });

    group('Already Migrated', () {
      test('ChangeNotifier', () async {
        await testNotifierNoOp('change_notifier_provider');
      });

      test('StateNotifier', () async {
        await testNotifierNoOp('state_notifier_provider');
      });

      test('StateProvider', () async {
        await testNotifierNoOp('state_provider');
      });
    });
  });
}
